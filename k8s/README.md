# 🚀 Laravel CRUD App on Kubernetes (Minikube)

This project demonstrates deploying a **Laravel CRUD application with MySQL** on a local Kubernetes cluster using **Minikube**.

---

# 🧠 Architecture Overview

```
Laravel App (Deployment)
        ↓
Kubernetes Service (ClusterIP)
        ↓
Ingress Controller (NGINX)
        ↓
MySQL Deployment + PVC
        ↓
Persistent Volume (hostPath)
```

---

# ⚙️ Tech Stack

* Laravel (PHP App)
* MySQL 8
* Kubernetes
* Minikube (Docker driver)
* NGINX Ingress Controller

---

# 📦 Kubernetes Components Used

## 1. Namespace

```yaml
laravel-crud
```

---

## 2. ConfigMap

Used for Laravel DB configuration:

```yaml
DB_CONNECTION: mysql
DB_HOST: mysql-service
DB_PORT: "3306"
DB_DATABASE: laravel_db
DB_USERNAME: root
```

---

## 3. Secret

Used for MySQL root password:

```yaml
MYSQL_ROOT_PASSWORD: root
```

(Base64 encoded)

---

## 4. Persistent Volume (PV)

Local storage for MySQL data:

```yaml
hostPath: /mnt/data/mysql
capacity: 500Mi
accessModes: ReadWriteOnce
```

👉 This stores data on Minikube node disk.

---

## 5. Persistent Volume Claim (PVC)

Requests storage from PV:

```yaml
storage: 500Mi
storageClassName: manual
```

---

## 6. MySQL Deployment

* Uses MySQL 8 image
* Mounts PVC at `/var/lib/mysql`
* Uses Secret for root password

---

## 7. MySQL Service

```yaml
type: ClusterIP
port: 3306
```

Used for internal communication with Laravel.

---

## 8. Laravel Deployment

* Custom Docker image: `sourav1911/laravel-app:v2`
* Loads ConfigMap + Secret
* Connects to MySQL service

---

## 9. Laravel Service

```yaml
type: NodePort
port: 80
nodePort: 30008
```

---

## 10. Ingress

Routes traffic:

```yaml
host: laravel.crud
path: /
```

---

# 🧪 Deployment Steps

## 1. Start Minikube

```bash
minikube start --driver=docker
```

---

## 2. Enable Ingress

```bash
minikube addons enable ingress
```

---

## 3. Create Namespace

```bash
kubectl create namespace laravel-crud
```

---

## 4. Apply ConfigMap & Secret

```bash
kubectl apply -f crud-configmap.yaml -n laravel-crud
kubectl apply -f mysql-secret.yaml -n laravel-crud
```

---

## 5. Apply Storage

```bash
kubectl apply -f crud-pv.yaml
kubectl apply -f crud-pvc.yaml -n laravel-crud
```

---

## 6. Deploy MySQL

```bash
kubectl apply -f mysql-deployment.yaml -n laravel-crud
kubectl apply -f mysql-service.yaml -n laravel-crud
```

---

## 7. Deploy Laravel App

```bash
kubectl apply -f deployment.yaml -n laravel-crud
kubectl apply -f service.yaml -n laravel-crud
```

---

# Check running pods
kubectl get pods -n laravel-crud

kubectl exec -it <laravel-pod-name> -n laravel-crud -- php artisan key:generate

kubectl exec -it <laravel-pod-name> -n laravel-crud -- php artisan migrate


---



## 8. Apply Ingress

```bash
kubectl apply -f crud-ingress.yaml -n laravel-crud
```

---

# 🌐 Access Methods

## Option 1: Port Forward (Most Stable)

```bash
kubectl port-forward svc/crud-service 8080:80 -n laravel-crud
```

Open:

```
http://localhost:8080
```

---

## Option 2: NodePort

```
http://<minikube-ip>:30008
```

---

## Option 3: Ingress (Experimental in Minikube)

Add to `/etc/hosts`:

```
192.168.49.2 laravel.crud
```

Then open:

```
http://laravel.crud
```

---

# 🧠 Key Learnings

* Kubernetes networking (Service types)
* PV vs PVC storage concept
* ConfigMap vs Secret usage
* Ingress routing basics
* Minikube limitations (tunnel, IP access)

---

# ⚠️ Issues Faced

* Ingress IP not reachable via browser
* NodePort not exposed due to Docker driver
* Minikube tunnel instability

✔ Solution: Port-forward used for stable access

---

# 🚀 Next Phase (Planned)

We will move to:

## 🌐 AWS Production Setup

* VPC (Terraform)
* EKS Cluster
* ALB Ingress Controller
* Real DNS (Route53)

---

# 👨‍💻 Status

✔ Minikube deployment completed
✔ Laravel + MySQL working
✔ Kubernetes concepts implemented

---

🔥 End of current phase

