#!/bin/bash
kubespray_data_dir=${kubespray_data_dir}
apt_lock_max_wait_time=600
apt_retry_interval=10

# Disable "Pending kernel upgrade". https://askubuntu.com/questions/1349884/how-to-disable-pending-kernel-upgrade-message
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

# Avoid popup https://stackoverflow.com/questions/73397110/how-to-stop-ubuntu-pop-up-daemons-using-outdated-libraries-when-using-apt-to-i
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf

# Function to check if the apt lock file is open
is_lock_file_open() {
  sudo lsof -t "/var/lib/apt/lists/lock" >/dev/null 2>&1 ||
  sudo lsof -t "/var/lib/dpkg/lock-frontend" >/dev/null 2>&1 ||
  sudo lsof -t "/var/lib/dpkg/lock" >/dev/null 2>&1
}

# Wait until the lock file is released or maximum wait time is reached
wait_for_lock_release() {
  wait_time=0
  while is_lock_file_open; do
    if [ "$wait_time" -ge "$apt_lock_max_wait_time" ]; then
      echo "Timeout reached. Lock file is still present."
      exit 1
    fi
    echo "Waiting for apt lock file to be released..."
    sleep $apt_retry_interval
    wait_time=$((wait_time + $apt_retry_interval))
  done
}

wait_for_lock_release

# Verify if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    
    # Download Docker installation script
    if ! curl -fsSL https://get.docker.com -o get-docker.sh; then
        echo "Error downloading Docker installation script. Exiting." >&2
        exit 1
    fi

# Check and add DPkg::Lock::Timeout=600 to apt-get install if not already present
    if ! grep -q 'apt-get install.*DPkg::Lock::Timeout=600' get-docker.sh; then
        sed -i 's/apt-get install/apt-get install -o DPkg::Lock::Timeout=600/g' get-docker.sh
    fi

    # Check and add DPkg::Lock::Timeout=600 to apt-get update if not already present
    if ! grep -q 'apt-get update.*DPkg::Lock::Timeout=600' get-docker.sh; then
        sed -i 's/apt-get update/apt-get update -o DPkg::Lock::Timeout=600/g' get-docker.sh
    fi
    
    # Install Docker
    if ! sudo sh get-docker.sh; then
        echo "Error installing Docker. Exiting." >&2
        exit 1
    fi
    
    # Clean up by removing the Docker installation script
    rm -f get-docker.sh

    # Add current user to the `docker` group
    sudo usermod -aG docker $USER

    echo "Docker installed successfully."
else
    echo "Docker is already installed."
fi

mkdir -p $kubespray_data_dir
rm -rf $kubespray_data_dir/*
chmod 700 $kubespray_data_dir