
# IMS Docker Environment

This project provides a Docker-based environment for simulating an **IP Multimedia Subsystem (IMS)** architecture. It includes components such as:

- **FHOSS (Home Subscriber Server)**
- **MySQL** (for HSS backend)
- **Kamailio** (SIP Server)

## 📁 Project Structure

```
├── docker-compose.yaml
├── kamailio/
│   └── etc/kamailio/kamailio.cfg
├── sipp/
│   └── ...
├── uac-register_*.log
```

## 🚀 Quick Start

### 1. Prerequisites

Ensure Docker and Docker Compose are installed:

```bash
docker -v
docker-compose -v
```

### 2. Clone the Repository

```bash
git clone https://github.com/<your-org-or-username>/ims-docker-intern.git
cd ims-docker-intern
```

### 3. Start the Services

```bash
docker-compose up -d
```

### 4. Check Running Containers

```bash
docker ps -a
```

## 🧱 Services

### 1. **MySQL**
- **Image:** `mysql:8.0`
- **Container Name:** `fhoss-mysql`
- **Port:** `3306`
- **Environment Variables:**
  - `MYSQL_ROOT_PASSWORD: rootpass`
  - `MYSQL_DATABASE: fhoss_db`
  - `MYSQL_USER: fhoss`
  - `MYSQL_PASSWORD: fhospass`

### 2. **FHOSS (HSS)**
- **Image:** `gradianet/fhoss:develop`
- **Container Name:** `fhoss`
- **Port:** `8080`
- **Environment Variables:**
  - `MYSQL_IP: mysql`
  - `FHOSS_IP: fhoss`
  - `DNS_IP: 8.8.8.8`
  - `MYSQL_USER: fhoss`
  - `MYSQL_PASSWORD: fhospass`
  - `MYSQL_DATABASE: fhoss_db`

### 3. **Kamailio**
- **Image:** `kamailio/kamailio-ci`
- **Container Name:** `kamailio`
- **Network Mode:** `host`
- **Command:**
  ```bash
  kamailio -E -n 64 -M 8 -f /etc/kamailio/kamailio.cfg
  ```

## 🔍 Logs

SIP and UAC error logs can be found under filenames like:
- `uac-register_323076_errors.log`
- `uac-register_323127_errors.log`

## 🧪 Testing

You can use **SIPp** or other SIP traffic generators to register users or test SIP flows. See the `sipp/` folder or your scripts for automated test cases.

## 🛑 Stop the Environment

```bash
docker-compose down
```

Or to stop specific containers:

```bash
docker stop <container_name>
```

## 📦 Volume

The MySQL database is persisted via the Docker volume:
```yaml
volumes:
  mysql_data:
```

## 🔧 Notes

- The `kamailio` container uses `network_mode: host`, which may require elevated privileges.
- Make sure port `8080` and `3306` are free before launching the containers.
- Container `fhoss` exited with status `255` — inspect its logs to troubleshoot:
```bash
docker logs fhoss
```

## 🧑‍💻 Author

Giang Pham  
Intern @ Endava

---

## 📜 License

MIT License (or update this based on your project requirements)
