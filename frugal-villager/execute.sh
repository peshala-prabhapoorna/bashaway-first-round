#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Minikube if not installed
if ! command_exists minikube; then
    echo "Minikube not found. Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube /usr/local/bin/
    rm minikube
fi

# Install kubectl if not installed
if ! command_exists kubectl; then
    echo "kubectl not found. Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install kubectl /usr/local/bin/
    rm kubectl
fi

# Start Minikube
echo "Starting Minikube..."
minikube start

# Create namespace 'bashaway'
echo "Creating namespace 'bashaway'..."
kubectl create namespace bashaway || true

# Create a secret for Redis password
REDIS_PASSWORD="your_redis_password"
echo "Creating Redis secret..."
kubectl create secret generic redis --namespace=bashaway --from-literal=redis-password=$REDIS_PASSWORD || true

# Deploy Redis
echo "Deploying Redis..."
kubectl apply -n bashaway -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: bashaway
spec:
  ports:
    - port: 6379
      targetPort: 6379
  selector:
    app: redis
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: bashaway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: redis:alpine
          ports:
            - containerPort: 6379
          env:
            - name: REDIS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: redis
                  key: redis-password
          command: ["redis-server", "--requirepass", "$(REDIS_PASSWORD)"]
EOF

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
kubectl rollout status deployment/redis -n bashaway

# Forward the Redis port
echo "Forwarding port 6381 to Redis service..."
kubectl port-forward svc/redis 6381:6379 -n bashaway &

echo "Setup complete. You can now run your tests."

sleep 10
kubectl get all,cm,secret,ing -A
