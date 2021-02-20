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

resource "kubernetes_deployment" "flask-app" {
  metadata {
    name = "scalable-flask-app"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableFlaskApp"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableFlaskApp"
        }
      }
      spec {
        container {
          image = "vakkasoglu/capstone-project"
          name  = "example"

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
}
resource "kubernetes_service" "flask" {
  metadata {
    name = "flask-app"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 31000
      port        = 5000
      target_port = 5000
    }

    type = "NodePort"
  }
}

