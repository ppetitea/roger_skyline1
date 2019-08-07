********************************************************** 42 project - Roger Skyline **********************************************************

1.  Download debian multi architecture iso on official website  -->  https://cdimage.debian.org/debian-cd/current/multi-arch/iso-cd/
2.  Download and Launch Virtualbox, create new VM --> clic on "New" button, then type debian and create the Virtual Disk Image on USB stick
3.  In Virtualbox clic on "Configuration", select "Storage", set SATA on VDI path, set IDE on debian iso path
4.  
5.  Suivre les etapes d'installation            ->  https://www.youtube.com/watch?v=3lRkjWTUuhc
6.  Remplacer le service DHCP par une IP fixe
        sudo vim /etc/network/interfaces        ->  auto enp0s3
                                                    iface enp0s3 inet static
                                                        address 192.168.1.52/30
                                                        gateway 192.168.1.51
        Relancer le reseau avec                 ->  sudo /etc/init.d/networking restart
        Test du reseau                          ->  ping 8.8.8.8 et sudo ifconfig

7.  Changer le port par defaut du service ssh exemple port 1000
        sudo vim /etc/ssh/sshd_config           ->  Port 1000
        Relancer service ssh                    ->  sudo systemctl restart ssh

8.  Cree acces ssh par publickeys
        sur la machine actuelle                 ->  ssh-keygen -t rsa -b 4096
        envoyer la cle publique au serveur      ->  ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
        sur le serveur autoriser la cle         ->  cat id_rsa.pub > ~/.ssh/authorized_keys

8.  Acces ssh uniquement par publickeys
        sudo vim /etc/ssh/sshd_config           ->  PubkeyAuthentification yes
                                                ->  AuthorizedKeysFile .ssh/authorized_keys
                                                ->  PasswordAuthentification no
                                                ->  PermitEmptyPasswords no
                                                ->  ChallengeResponseAuthentification no
        Pas d'acces ssh root                    ->  PermitRootLogin no
        Relancer service ssh                    ->  sudo systemctl restart ssh

9. Mettre en place des regles de parefeu, limiter l'acces aux services utilise en dehors de la VM
        ressources                              ->  https://debian-facile.org/doc:reseau:iptables-pare-feu-pour-un-client
        service ssh, port 1000                  ->  iptables
        service reseau local                    ->  iptables -t filter -A OUTPUT -o lo -j ACCEPT
        voir fichier                            ->  firewall.sh

10. Protection DDOS                             ->  https://geekeries.org/2017/12/configuration-avancee-du-firewall-iptables/?cn-reloaded=1
        Bloquer le mode "loose" qui autorise un paquet ACK a ouvrir une connexion
        Creer un SYN proxy qui va eviter la surcharge de connexions non suivies
        Gerer le surnombre de connexions
        
11.
