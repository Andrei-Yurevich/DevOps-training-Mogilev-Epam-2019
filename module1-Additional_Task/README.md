## CentOs 7 configuration
1. Install nfs server tools and portmap (tool for RPC service).</br>
  `yum install nfs-utils portmap git`</br>
Then enable and start nfs server:</br></br>
`systemctl enable nfs-server.service`</br>
`systemctl start nfs-server.service`</br></br>
2. Drop all firewall rules</br>
`iptables -F`
3. Next, allow the NFS ports to ensure that you will be able to connect by NFS from our NFS client.</br></br>
`firewall-cmd --permanent --zone=public --add-service=ssh`</br>
`firewall-cmd --permanent --zone=public --add-service=nfs`</br>
`firewall-cmd --reload`</br></br>

4. Create toor user, clone repo and set permissions:</br></br>
`useradd -m toor -s /bin/bash`</br>
`mkdir /git && cd /git`</br>
`git clone https://github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019`</br>
`chown -R toor:toor /git`</br>

5. After we need to add NFS configuration to `/etc/exports`:</br></br>
`/git 192.168.43.0/255.255.255.0(rw,sync,root_squash,no_subtree_check)`</br>
`/git 192.168.43.167/255.255.255.0(rw,sync,root_squash,insecure,no_subtree_check)`</br>
</br>
First string for all hosts in my subnet. Second string for my windows host.</br>
`rw` — Allow read and write on my volume.</br>
`sync` — Reply to requests only after the changes have been recorded.</br>
`root_squash` — Client root user haven't special permissions to volume.</br>
`no_subtree_check` — Disable subtree checking(not required in my case)</br>
`insecure` — Means that client can connect from more then 1024 port(need to escape error №53 on my windows host)</br>

6. Commit new configuration and restart NSF service:</br></br>
`exports -a`</br>
`service nfs restart`</br>

## Windows server 2012 configuration

1. Add nfs client support:
![alt tag](https://pp.userapi.com/c847218/v847218782/1899fa/3U5MmrFUJIo.jpg)</br></br>
2. Set UID and GUID for anonimous user on windows equal toor UID on server.
![alt tag](https://pp.userapi.com/c845522/v845522782/18d408/6V9HMebThOM.jpg)</br></br>
3. Reboot your VM.</br>
4. Finally connect to your share
![alt tag](https://pp.userapi.com/c846021/v846021782/184858/ya6eAjy6f1s.jpg)</br></br>

## Testing permissions
1. Try to create empty file on client:

![alt tag](https://pp.userapi.com/c846021/v846021453/184d9f/60Lx8TGrpGU.jpg)</br></br>
2. On server check information about inode of new file
![alt tag](https://pp.userapi.com/c851324/v851324254/9f27e/0IGrs-NC8QA.jpg)</br></br>

### Done.
