#!/bin/sh
echo "INFO: Copying kubeconfig file from the control plane."
ks_tmp=$1
CONTROL_PLANE_IP=$(set "2q;d" $ks_tmp/inventory.ini 2&>/dev/null)
[ -z "$CONTROL_PLANE_IP" ] && read -p 'Control plane IP: ' CONTROL_PLANE_IP
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new ubuntu@$CONTROL_PLANE_IP echo "Hello there" >/dev/null
[ "$?" -ne 0 ] && echo "WARN: Unable to SSH to $CONTROL_PLANE_IP with key-based authentication from this machine. Skipping." && exit 0
ssh ubuntu@$CONTROL_PLANE_IP mkdir -p /home/ubuntu/.kube
ssh ubuntu@$CONTROL_PLANE_IP sudo cp -rf /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
ssh ubuntu@$CONTROL_PLANE_IP sudo chown ubuntu /home/ubuntu/.kube/config
mkdir -p ~/.kube
scp -r ubuntu@$CONTROL_PLANE_IP:/home/ubuntu/.kube/config ~/.kube/.config >/dev/null
sed "s/127.0.0.1/$CONTROL_PLANE_IP/g" ~/.kube/.config > ~/.kube/config
rm -f ~/.kube/.config
echo "INFO: Completed"