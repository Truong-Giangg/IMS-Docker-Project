# IMS Docker Environment

This project provides a Docker-based environment for simulating a full **IP Multimedia Subsystem (IMS)** architecture.  
It includes:

- **FHOSS** (Home Subscriber Server)  
- **MySQL** (HSS backend)  
- **Kamailio** (SIP servers implementing **P-CSCF**, **I-CSCF**, and **S-CSCF**)

---

## 📁 Project Structure

```
IMS-Docker-Project/
├── Dockerfile.kamailio-ims       # builds local IMS-ready Kamailio image
├── docker-compose.yml             # service definitions
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

Each Kamailio role mounts its own config folder into `/etc/kamailio` inside the container.

---

## 🚀 Quick Start

### 1️⃣ Prerequisites

Ensure **Docker** and **Docker Compose** are installed:

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
- Starts from the official Kamailio `6.0.3-focal` base image  
- Installs IMS-related modules (`kamailio-ims-modules`, `kamailio-extra-modules`, etc.)
- Produces a ready-to-run image: `local/kamailio-ims:6.0.3`

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
- **Ports:** `8080` (web) and `3868` (Diameter)
- **Environment Variables:**
  - `MYSQL_IP: fhoss-mysql`
  - `FHOSS_IP: fhoss`
  - `MYSQL_USER/PASSWORD/DATABASE` match the MySQL service

### 3. **Kamailio IMS Nodes**

Each node uses the **local IMS image** and runs with `network_mode: host`  
(so ports 4060, 5060, and 6060 bind directly to your host).

| Role | Container | SIP Port | Config | Diameter Config |
|------|------------|----------|---------|-----------------|
| **P-CSCF** | `kamailio-pcscf` | `4060` | `kamailio/pcscf/kamailio.cfg` | `kamailio/pcscf/diameter.xml` |
| **I-CSCF** | `kamailio-icscf` | `5060` | `kamailio/icscf/kamailio.cfg` | `kamailio/icscf/diameter.xml` |
| **S-CSCF** | `kamailio-scscf` | `6060` | `kamailio/scscf/kamailio.cfg` | `kamailio/scscf/diameter.xml` |

> Each `kamailio.cfg` file loads `cdp.so` with  
> `modparam("cdp","config_file","/etc/kamailio/diameter.xml")`,  
> and uses **XML-based Diameter configuration**.

---

## 🔍 Logs

Follow container logs with:

```bash
docker logs -f kamailio-icscf
docker logs -f kamailio-scscf
docker logs -f fhoss
```

Common checks:
- Kamailio logs showing `CDiameterPeer connection established`
- SIP ports listening:

```bash
sudo ss -lpun | egrep ':4060|:5060|:6060'
```

---

## 🧪 Testing

You can use **SIPp** or any SIP UA to simulate:
- SIP REGISTER via P-CSCF (`sip:localhost:4060`)
- INVITE calls routed through I- and S-CSCF

Example SIPp commands and scenarios can be placed in a `sipp/` directory.

---

## 🛑 Stop the Environment

```bash
docker compose down
```

Or stop a single container:

```bash
docker stop kamailio-scscf
```

---

## 📦 Volume

The MySQL data is persisted across restarts:

```yaml
volumes:
  mysql_data:
```

---

## ⚙️ Notes

- Kamailio containers run in **host network mode**, so ensure ports  
  `4060`, `5060`, `6060`, `8080`, and `3868` are free before startup.
- If you modify any Kamailio configs (`kamailio.cfg` or `diameter.xml`), restart the service:

```bash
docker compose up -d --force-recreate kamailio-icscf
```

- The `local/kamailio-ims:6.0.3` image can be rebuilt anytime using `Dockerfile.kamailio-ims`.

---

## 👤 Author

**Giang Pham**  
Intern @ Endava  

---

## 📜 License
