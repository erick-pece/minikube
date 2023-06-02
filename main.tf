terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

}

resource "kubectl_manifest" "namespace"{
yaml_body = <<YAML

kind: Namespace
apiVersion: v1
metadata:
  name: hello-kubernetes-ns
  labels:
    name: hello-kubernetes-ns

YAML
}




resource "kubectl_manifest" "deployment"{

yaml_body = <<YAML

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hellow-kubernetes
  name: hellow-kubernetes
  namespace : hello-kubernetes-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hellow-kubernetes
  template:
    metadata:
      labels:
        app: hellow-kubernetes
    spec:
      containers:
      - image: paulbouwer/hello-kubernetes:1.10
        name: hello-kubernetes
        ports:
        - containerPort: 8080
YAML
}

resource "kubectl_manifest" "service"{

yaml_body = <<YAML

apiVersion: v1
kind: Service
metadata:
  labels:
    app: hellow-kubernetes
  name: hellow-kubernetes
  namespace: hello-kubernetes-ns
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: hellow-kubernetes
  type: NodePort

YAML

}
