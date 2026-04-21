# 🐳 Docker Setup (Manual - Without Compose)

## 📌 Overview

This section covers running a Laravel CRUD application using Docker with a MySQL container, without using Docker Compose.

---

## 🧱 Step 1: Build Docker Image

```bash
docker build -t laravel-app -f docker/Dockerfile .
```

---

## 🌐 Step 2: Create Docker Network

```bash
docker network create laravel-net
```

---

## 🗄️ Step 3: Run MySQL Container

```bash
docker run -d \
  --name mysql-container \
  --network laravel-net \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=laravel \
  mysql:8
```

> Note: Port mapping is not required since containers communicate over Docker network.

---

## ⚙️ Step 4: Configure Environment

Create `.env` file from example:

```bash
cp .env.example .env
```

Update database configuration:

```
DB_HOST=mysql-container
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=root
```

---

## 🚀 Step 5: Run Laravel Container

```bash
docker run -d \
  --name laravel-container \
  --network laravel-net \
  -p 8000:80 \
  yourdockerhubusername/laravel-app:v2
```

---

## 🔑 Step 6: Setup Laravel

Generate application key:

```bash
docker exec -it laravel-container php artisan key:generate
```

Run migrations:

```bash
docker exec -it laravel-container php artisan migrate
```

---

## 🌍 Step 7: Access Application

Open in browser:

```
http://localhost:8000
```

---

## 🧪 Step 8: Verify Database

Access MySQL container:

```bash
docker exec -it mysql-container mysql -u root -p
```

Run queries:

```sql
SHOW DATABASES;
USE laravel;
SHOW TABLES;
SELECT * FROM products;
```

---

## 💡 Key Learnings

* Manual container networking using Docker
* Connecting Laravel application to MySQL container
* Running multi-container setup without Docker Compose
* Debugging container and database connectivity

---





# 🐳 Docker Compose Setup (Laravel + MySQL)

## 📌 Overview

This project runs a Laravel CRUD application with MySQL using Docker Compose. It provides a fully containerized environment with persistent database storage.

---

## 🧱 Services Used

* **Laravel App (PHP 8.2 + Apache)**
* **MySQL 8 Database**
* Docker Network for internal communication
* Docker Volume for database persistence

---

## 📁 Project Structure (Compose)

```
docker/
│
├── docker-compose.yaml
└── Dockerfile (used for Laravel image build)
```

---

## ⚙️ Docker Compose Configuration

### Services

#### 🗄️ MySQL

* Image: `mysql:8`
* Stores data using Docker volume
* No external port exposure (internal network only)

#### 🚀 Laravel App

* Image: `sourav1911/laravel-app:v2`
* Exposed on port `8000`
* Connected to MySQL via Docker network

---

## 🔐 Environment Configuration (.env)

Update Laravel `.env` file:

```env id="env01"
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=root
```

---

## 🚀 Run the Project

### Step 1: Start containers

```bash id="run01"
docker compose up -d
```

### Step 2: Check running containers

```bash id="run02"
docker ps
```

---

## 🔑 Laravel Setup (First Time Only)

### Generate app key

```bash id="key01"
docker exec -it laravel-container php artisan key:generate
```

### Run migrations

```bash id="mig01"
docker exec -it laravel-container php artisan migrate
```

---

## 🌐 Access Application

Open in browser:

```
http://localhost:8000
```

---

## 💾 Data Persistence

* MySQL data is stored using Docker volume:

```
laravel-mysql-data
```

👉 Ensures data is not lost when containers restart

---

## 💡 Key Learnings

* Docker Compose multi-container orchestration
* Service-to-service networking
* Data persistence using volumes
* Environment-based configuration
* Separation of application and database layers

---

## ⚠️ Notes

* Do NOT mount application source in production mode
* Ensure `.env` matches service names
* MySQL service name is used as DB host

---

