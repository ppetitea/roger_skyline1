#!/bin/bash

##	RESET
sudo iptables -F # vide toutes les chaines existantes
sudo iptables -X # supprimes les chaines personnelles

##	DROP
sudo iptables -P INPUT ACCEPT		# -P --> Choisir une chaine cible
sudo iptables -P OUTPUT ACCEPT		# DROP signifie que le paquet est detruit
sudo iptables -P FORWARD ACCEPT		# -t --> Choisir une table

##	EXEMPLE
#iptables -t <table> -A <Chaine> -p <Protocole> --dport <Port de destination> -j <Resultat>

##	LOCALHOST
#sudo iptables -A INPUT -i lo -j ACCEPT
#sudo iptables -A OUTPUT -o lo -j ACCEPT

##	SSH
sudo iptables -A INPUT -i enp0s3 -p tcp --dport 1000 -j ACCEPT
sudo iptables -A OUTPUT -o enp0s3 -p tcp --sport 1000 -j ACCEPT

##	HTTP
sudo iptables -A INPUT -i enp0s3 -p tcp --sport 80 -j ACCEPT #-m state --state ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o enp0s3 -p tcp --dport 80 -j ACCEPT #-m state --state NEW,ESTABLISHED -j ACCEPT

##	HTTPS
sudo iptables -A INPUT -i enp0s3 -p tcp --sport https -j ACCEPT
sudo iptables -A OUTPUT -o enp0s3 -p tcp --dport https -j ACCEPT

##	DNS
sudo iptables -A INPUT -i enp0s3 -p udp --sport 53 -j ACCEPT #-m state --state ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o enp0s3 -p udp --dport 53 -j ACCEPT #-m state --state NEW,ESTABLISHED -j ACCEPT

##	FTP
sudo iptables -A INPUT -i enp0s3 -p udp --sport 20:21 -j ACCEPT #-m state --state ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o enp0s3 -p udp --dport 20:21 -j ACCEPT #-m state --state NEW,ESTABLISHED -j ACCEPT

##	DDOS
# 1. Desactive le mode loose qui autorise par défaut un paquet ACK ouvrir une connexion
#####sudo iptables -A INPUT -m state --state INVALID -j DROP
# 2. Mettre en place un SYN proxy
#	en -t raw, les paquets TCP avec le flag SYN à destination des port ssh, http ou https ne seront pas suivi par le connexion tracker (et donc traités plus rapidement)
######sudo iptables -t raw -A PREROUTING -i enp0s3 -p tcp -m multiport --dports 1000,80,443 -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j CT --notrack
#	en input-filter, les paquets TCP avec le flag SYN à destination des portsssh ,http ou https non suivi (UNTRACKED ou INVALID) et les fais suivre à SYNPROXY.
#	C'est à ce moment que synproxy répond le SYN-ACK à l'émeteur du SYN et créer une connexion à l'état ESTABLISHED dans conntrack, si et seulement si l'émetteur retourne un ACK valide.
######sudo iptables -t filter -A INPUT -i enp0s3 -p tcp -m multiport --dports 1000,80,443 -m tcp -m state --state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
#	en input-filter, la règles SYNPROXY doit être suivi de celle-ci pour rejeter les paquets restant en état INVA.
######sudo iptables -t filter -A INPUT -i enp0s3 -p tcp -m multiport --dports 22,80,443 -m tcp -m state --state INVALID -j DROP
#sudo iptables -A OUTPUT -o enp0s3 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
# 3. Gerer la surcharge du nombre de connexion




