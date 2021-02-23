terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "flaskapp" {
  metadata {
    annotations = {
      name = "flask-app"
    }

    labels = {
      mylabel = "flask-app"
    }

    name = "flask-app"
  }
}

resource "kubernetes_deployment" "flask-app" {
  metadata {
    name = "flask-app"
    labels = {
      App = "flask-app"
    }
  }

  spec {
    replicas = 4
    selector {
      match_labels = {
        App = "flask-app"
      }
    }
    template {
      metadata {
        labels = {
          App = "flask-app"
        }
      }
      spec {
        container {
          image = "vakkasoglu/capstone-project"
          name  = "flask-app"

          port {
            container_port = 5000
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
  # deployment shouldn't take longer than a few minutes normally
  timeouts {
    create = "1m"
    update = "1m"
    delete = "2m"
  }
}

resource "kubernetes_service" "flask-app" {
  metadata {
    name = "flask-app"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask-app.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 5000
      target_port = 5000
    }

    type = "NodePort"
  }
}

