# 🧩 IMS Docker Environment

This project provides a **Docker-based environment** for simulating a complete **IP Multimedia Subsystem (IMS)** architecture.  

It includes:

- **FHOSS** (Home Subscriber Server)  
- **MySQL** (HSS backend)  
- **Kamailio** (SIP servers implementing **P-CSCF**, **I-CSCF**, and **S-CSCF**)

---

## 📁 Project Structure

```
IMS-Docker-Project/
├── Dockerfile.kamailio-ims       # Builds local IMS-ready Kamailio image
├── docker-compose.yml             # Service definitions
└── kamailio/
    ├── pcscf/
    │   ├── kamailio.cfg
    │   └── diameter.xml
    ├── icscf/
    │   ├── kamailio.cfg
    │   └── diameter.xml
    └── scscf/
        ├── kamailio.cfg
        └── diameter.xml
```

Each Kamailio role mounts its own configuration directory into `/etc/kamailio` inside its container.

---

## 🚀 Quick Start

### 1️⃣ Prerequisites

Make sure **Docker** and **Docker Compose** are installed:

```bash
docker -v
docker compose version
```

### 2️⃣ Clone the Repository

```bash
git clone https://github.com/<your-org-or-username>/ims-docker-intern.git
```

### 3️⃣ Build the IMS Kamailio Image

```bash
docker build -f Dockerfile.kamailio-ims -t local/kamailio-ims:6.0.3 .
```

This step:
- Starts from the official `kamailio:6.0.3-focal` base image  
- Installs IMS-related modules (`kamailio-ims-modules`, `kamailio-extra-modules`, etc.)  
- Produces a ready-to-run image: `local/kamailio-ims:6.0.3`

### 3️⃣ Add host manually

```bash
echo "127.0.0.1   pcscf.ims.local icscf.ims.local scscf.ims.local hss.ims.local ims.local" | sudo tee -a /etc/hosts
```

### 4️⃣ Launch the Services

```bash
docker compose up -d
```

This spins up:
- MySQL (`fhoss-mysql`)
- FHoSS (Home Subscriber Server)
- Kamailio P-CSCF, I-CSCF, and S-CSCF nodes

### 5️⃣ Verify Running Containers

```bash
docker ps -a
```

Expected output:

```
kamailio-pcscf   Up
kamailio-icscf   Up
kamailio-scscf   Up
fhoss            Up
fhoss-mysql      Up
```

---

## 🧱 Services Overview

### 1. **MySQL**
- **Image:** `mysql:8.0`
- **Container:** `fhoss-mysql`
- **Port:** `3306`
- **Purpose:** backend database for FHoSS

### 2. **FHOSS (HSS)**
- **Image:** `gradiant/fhoss:develop`
- **Container:** `fhoss`
- **Ports:** `8080` (Web UI), `3868` (Diameter)
- **Environment Variables:**
  - `MYSQL_IP: fhoss-mysql`
  - `FHOSS_IP: fhoss`
  - `MYSQL_USER/PASSWORD/DATABASE` match the MySQL service

### 3. **Kamailio IMS Nodes**

Each node uses the **local IMS Kamailio image** and runs with `network_mode: host`,  
so ports `4060`, `5060`, and `6060` bind directly to your host.

| Role | Container | SIP Port | Config | Diameter Config |
|------|------------|----------|---------|-----------------|
| **P-CSCF** | `kamailio-pcscf` | `4060` | `kamailio/pcscf/kamailio.cfg` | `kamailio/pcscf/diameter.xml` |
| **I-CSCF** | `kamailio-icscf` | `5060` | `kamailio/icscf/kamailio.cfg` | `kamailio/icscf/diameter.xml` |
| **S-CSCF** | `kamailio-scscf` | `6060` | `kamailio/scscf/kamailio.cfg` | `kamailio/scscf/diameter.xml` |

> Each `kamailio.cfg` loads `cdp.so` with  
> `modparam("cdp","config_file","/etc/kamailio/diameter.xml")`.

---

## 🗄️ Database Management (FHOSS MySQL)

### 🔹 Delete and Recreate the Database

```bash
docker exec -it fhoss-mysql mysql -uroot -prootpass -e "DROP DATABASE IF EXISTS hss_db; CREATE DATABASE hss_db;"
```

### 🔹 Create Default Tables

```bash
docker exec -i fhoss-mysql mysql -uroot -prootpass hss_db < hss_db.schema.sql
```

### 🔹 Create Default User and Grant Privileges

```bash
docker exec -it fhoss-mysql mysql -uroot -prootpass -e "
CREATE USER IF NOT EXISTS 'hss'@'%' IDENTIFIED WITH mysql_native_password BY 'hss';
ALTER USER 'hss'@'%' IDENTIFIED WITH mysql_native_password BY 'hss';
GRANT ALL PRIVILEGES ON hss_db.* TO 'hss'@'%';
FLUSH PRIVILEGES;
"
```

### 🔹 Create credential root for FHoSS

```bash
docker exec -it fhoss sh -lc '
  cat > /root/.my.cnf <<EOF
[client]
user=root
password=rootpass
host=fhoss-mysql
EOF
  chmod 600 /root/.my.cnf
'
```

### 🔹 Insert Default Subscriber Data

```bash
docker exec -i fhoss-mysql mysql -uroot -prootpass hss_db < userdata.sql
```

---

## 🔍 Logs and Monitoring

View container logs:

```bash
docker logs -f kamailio-icscf
docker logs -f kamailio-scscf
docker logs -f fhoss
```

Check SIP and Diameter ports:

```bash
sudo ss -lpun | egrep ':4060|:5060|:6060|:3868'
```

---

## 🧪 Testing & Diagnostics

### 🔹 Test S-CSCF Node

```bash
sipsak -s sip:any@scscf.ims.local:6060 -vv
```

### 🔹 Test FHoSS log

```bash
docker logs -f fhoss | egrep -i 'Diameter|Peer|Realm|FQDN|StateMachine'
```

### 🔹 Register a SIP User (Alice)

```bash
sipsak -U   -s sip:alice@ims.local:6060   -u alice   -a 'alice'   -vv
```

### 🔹 Capture All IMS Traffic

```bash
sudo tcpdump -i any -n -s 0 -w ims_all.pcap '(udp port 4060 or udp port 5060 or udp port 6060) or (tcp port 3868 or tcp port 3870 or tcp port 3871 or tcp port 3872)'
```

### 🔹 Inspect the PCAP File

```bash
sudo tcpdump -nn -A -r ims_all.pcap
```

---

## 🛑 Stop the Environment

Stop all containers:

```bash
docker compose down
```

Or stop a single one:

```bash
docker stop kamailio-scscf
```

---

## 📦 Persistent Data

MySQL data is persisted via Docker volumes:

```yaml
volumes:
  mysql_data:
```

---

## ⚙️ Notes

- Ensure ports `4060`, `5060`, `6060`, `8080`, and `3868` are **free** before startup.  
- Restart a specific Kamailio node after modifying its configuration:

  ```bash
  docker compose up -d --force-recreate kamailio-icscf
  ```

- Rebuild Kamailio image anytime:

  ```bash
  docker build -f Dockerfile.kamailio-ims -t local/kamailio-ims:6.0.3 .
  ```

---

## 👤 Author

**Giang Pham**  
Intern @ Endava  

---

## 📜 License

This project is open-sourced for educational and internal use.  
