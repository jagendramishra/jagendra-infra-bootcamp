# resource "helm_release" "elasticsearch" {
#   name       = "elasticsearch"
#   repository = "https://helm.elastic.co"
#   chart      = "elasticsearch"
#   namespace  = "elastic-system"
# }

# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   namespace  = "grafana-system"
# }

# resource "helm_release" "ingress" {
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "ingress-nginx"
# }

# resource "kubernetes_ingress_v1" "elasticsearch_ingress" {
#   metadata {
#     name      = "elasticsearch-ingress"
#     namespace = "elastic-system"
#   }

#   spec {
#     rule {
#       http {
#         path {
#           path = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "elasticsearch"
#               port {
#                 number = 9200
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
