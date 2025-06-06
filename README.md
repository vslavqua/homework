# Docker + Ansible infrastruktūras automatizācija

## Projekta apraksts

Šis projekts demonstrē infrastruktūras automatizāciju, izmantojot Ansible un Docker. Projekts uzstāda un konfigurē chrony laika sinhronizācijai un Zabbix agent2 monitorēšanai uz pieciem Docker konteineriem, kas darbojas kā Linux hosti divos datu centros (AAA un ZZZ).


### Funkcionalitāte

* Izveido "ansible" lietotāju ar sudo tiesībām visos hostos
* Instalē un konfigurē Chrony laika sinhronizācijai:
    * hostname1, hostname4 izmanto AAA datu centra NTP serveri
    * hostname2, hostname3, hostname5 izmanto ZZZ datu centra NTP serveri
* Instalē un konfigurē zabbix-agent2 tikai uz hostname*
* Visi hosti ir Docker konteineri, piekļu internetam nodrošina Squid proxijs

### Lietošana

Pēc Ansible izpildes:
* Visi hostname* hosti būs ar chrony un zabbix-agent2 instalētu un konfigurētu.
* Katrs datu centrs izmanto savu NTP serveri (172.20.10.20 AAA un 172.20.20.20 ZZZ).
* Zabbix serveris var sākt monitorēt šos hostus.


## Projekta struktūra
```
.
├── Project_A                       # Ansible konfigurācijas
│   ├── ansible.cfg                     # Ansible konfigurācijas fails
│   ├── group_vars                      # Visi mainīgie
│   │   └── all.yml
│   ├── inventory.yml                   # Inventarizācijas fails ar grupām dc_aaa un dc_zzz
│   ├── playbook.yml                    # Playbook: Izveido lietotāju, instalē un konfigurē Chrony un Zabbix-agent2
│   └── templates                       # konfigurācijas faili
│       ├── chrony.conf.j2
│       └── zabbix_agent2.conf.j2
├── Project_D                       # Docker infrastruktūra
│   ├── data
│   │   ├── zabbix-server
│   │   │   ├── alertscripts
│   │   │   └── externalscripts
│   │   └── zabbix-web
│   │       └── modules
│   ├── docker-compose.yml              # Veido visu vidi, izmantojot konteinerus
│   ├── host                            # Satur Dockerfile un entrypoint.sh konteineru hostiem
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   ├── ntp                             # NTP serveru (Chrony) konfigurācijas
│   │   ├── Dockerfile
│   │   ├── chrony-aaa.conf
│   │   └── chrony-zzz.conf
│   └── squid.conf                      # Squid proxy konfigurācija
```

## Serveru infrastruktūra
### Datacenter AAA:
* Hosti: hostname1, hostname4
* NTP server: ntp-aaa

### Datacenter ZZZ:
* Hosti: hostname2, hostname3, hostname5
* NTP server: ntp-zzz
* Zabbix server + proxy: zabbix_server
* Zabbix DB: zabbix_db
* Frontend Zabbix portāls: zabbix_web 

### Visiem hostiem pieejams    
* Сentrālais proxy serveris: squid_proxy

## Tīkla shēma
<p align="center">
  <img src="network-diagram.png" alt="Tīkla shēma" width="600"/>
</p>

## Instalēšana

Šis projekts pieņem, ka tev ir uzstādīts:
* Docker
* Docker Compose
* Ansible

Klonē repozitoriju:
```
git clone https://github.com/vslavqua/homework.git
cd homework/Project_D
```

Palaid Docker vidi:
```
docker compose up -d
```

Pārbaudi konteineru statusu:
```
docker ps
```

Palaid Ansible playbook:
```
../Project_A/ansible-playbook -i inventory.yml playbook.yml
```

## Testi

### Chrony
Run the following command inside a host:
```
chronyc tracking
chronyc sources -v
```

### Zabbix
Check Zabbix frontend:
* Navigate to Monitoring → Latest Data
* Filter by hostname* hosts
You should see metrics like system.uname, system.cpu.load, and others.


## Author: 
* Vjaceslavs S.
* https://vslavqua.github.io/