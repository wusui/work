#echo ',s/requiretty/\!requiretty/; w' | tr \; '\012' | sudo ed -s /etc/sudoers
sudo useradd -d /home/ceph -m ceph
echo -e "admin\nadmin" | (sudo passwd --stdin ceph)
echo "ceph ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph
sudo chmod 0440 /etc/sudoers.d/ceph
sudo yum -y install openssh-server
sudo -u ceph ssh-keygen -N '' -f /home/ceph/.ssh/id_rsa
cat auth_key | sudo -u ceph tee /home/ceph/.ssh/authorized_keys
sudo chmod 0600 /home/ceph/.ssh/authorized_keys
