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
