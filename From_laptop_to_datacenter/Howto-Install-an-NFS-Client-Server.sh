#on the server:
 
 yum install nfs-utils rpcbind
 systemctl enable nfs-server
 systemctl enable rpcbind
 systemctl enable nfs-lock
 systemctl enable nfs-idmap
 systemctl start rpcbind
 systemctl start nfs-server
 systemctl start nfs-lock
 systemctl start nfs-idmap
 systemctl status nfs
 vim /etc/exports
cat /etc/exports
      /data  <destination_host IP - USE the private IP>(rw,sync,no_wdelay)
 
exportfs -r
 
#On the client:
 
 yum install nfs-utils
 mount -t nfs -o ro,nosuid <your_server_ip>:/data /data
 ll /data/
 umount /data
 cat /etc/fstab
<SERVER_PRIVATE_IP>:/data /data   nfs defaults        0 0
