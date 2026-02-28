# Rubah nama mikrotik
/system identity set name="Asus Board"

# Disable ipv6
/ipv6 settings
set disable-ipv6=yes

# Tambah ether1 sebagai DHCP Client
/ip dhcp-client
add interface=ether1 use-peer-dns=yes use-peer-ntp=no add-default-route=yes

# Set DNS Server
/ip dns
set servers=1.1.1.1,1.0.0.1 allow-remote-requests=yes

# Set Firewall Masquerade Global
/ip firewall nat
add chain=srcnat action=masquerade

# Buat bridge
/interface bridge
add name=bridge1-LAN

# Masukkan ether2–ether5 ke bridge
/interface bridge port
add bridge=bridge1-LAN interface=ether2
add bridge=bridge1-LAN interface=ether3
add bridge=bridge1-LAN interface=ether4
add bridge=bridge1-LAN interface=ether5

# Set IP Address ke bridge1-LAN
/ip address
add address=10.10.8.1/21   interface=bridge1-LAN comment="==> Client 10MB"
add address=10.10.16.1/24 interface=bridge1-LAN comment="==> Client 15MB"
add address=10.10.17.1/24 interface=bridge1-LAN comment="==> Client 20MB"
add address=10.10.18.1/24 interface=bridge1-LAN comment="==> Client 35MB"
add address=10.10.19.1/24 interface=bridge1-LAN comment="==> Client 50MB"
add address=10.10.20.1/24 interface=bridge1-LAN comment="==> Client 100MB"

# Tambah Queue Type 
/queue type
add name=cake kind=cake
add name=pcq-5M  kind=pcq pcq-rate=5M  pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048
add name=pcq-6M  kind=pcq pcq-rate=6M  pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048
add name=pcq-7M  kind=pcq pcq-rate=7M  pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048
add name=pcq-8M  kind=pcq pcq-rate=8M  pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048
add name=pcq-9M  kind=pcq pcq-rate=9M  pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048
add name=pcq-10M kind=pcq pcq-rate=10M pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048
add name=pcq-12M kind=pcq pcq-rate=12M pcq-classifier=src-address,dst-address pcq-limit=64 pcq-total-limit=2048

# Buat Simple Queue
/queue simple
add name="Distribusi" target=10.10.0.0/16,10.20.20.0/24 parent=none queue=cake/cake
add name="Client 10MB" target=10.10.8.0/21  parent="Distribusi" queue=cake/cake
add name="Client 15MB" target=10.10.16.0/24 parent="Distribusi" queue=cake/cake
add name="Client 20MB" target=10.10.17.0/24 parent="Distribusi" queue=cake/cake
add name="Client 35MB" target=10.10.18.0/24 parent="Distribusi" queue=cake/cake
add name="Client 50MB" target=10.10.19.0/24 parent="Distribusi" queue=cake/cake
add name="Client 100MB" target=10.10.20.0/24 parent="Distribusi" queue=cake/cake
add name="Client Hotspot" target=10.20.20.0/24 parent="Distribusi" queue=cake/cake
add name="Zero End" target=250.250.250.250/32 parent="Distribusi" queue=cake/cake

# Buat IP Pool
/ip pool
add name=Pool_PPPOE_10MB  ranges=10.10.15.100-10.10.15.254,10.10.14.100-10.10.14.254,10.10.13.100-10.10.13.254,10.10.12.100-10.10.12.254
add name=Pool_PPPOE_15MB  ranges=10.10.16.100-10.10.16.254
add name=Pool_PPPOE_20MB  ranges=10.10.17.100-10.10.17.254
add name=Pool_PPPOE_35MB  ranges=10.10.18.100-10.10.18.254
add name=Pool_PPPOE_50MB  ranges=10.10.19.100-10.10.19.254
add name=Pool_PPPOE_100MB ranges=10.10.20.100-10.10.20.254
add name=Pool_Hotspot     ranges=10.20.20.21-10.20.20.250

# Buat Address List Client
/ip firewall address-list
add list=IP-CLIENT address=10.0.0.0/8
add list=IP-PPPOE  address=10.10.0.0/16

# Filter Rule: drop koneksi invalid di chain input
/ip firewall filter
add chain=input connection-state=invalid action=drop comment="===> Drop invalid input"
add chain=input in-interface=ether1 protocol=udp dst-port=53 action=drop comment="===> Block DNS (UDP 53) WAN"

# Set NTP Client
/system ntp client
set enabled=yes mode=unicast

/system ntp client servers
add address=0.id.pool.ntp.org
add address=1.id.pool.ntp.org
add address=2.id.pool.ntp.org

# Set Clock
/system clock
set time-zone-autodetect=yes
set time-zone-name=Asia/Jakarta

/system reboot
