# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     token                  = data.aws_eks_cluster_auth.cluster.token
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#   }
# }

# ECK Operator Deployment
resource "helm_release" "eck_operator" {
  name       = "eck-operator"
  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  namespace  = "elastic-system"
  create_namespace = true
}

# Elasticsearch & Kibana Deployment
resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart           = "elasticsearch"
  namespace       = "elk"
  create_namespace = true

  values = [<<EOF
replicas: 1
resources:
  requests:
    memory: 2Gi
    cpu: 500m
  limits:
    memory: 4Gi
    cpu: 1Gi
persistence:
  enabled: true
  accessModes:
    - ReadWriteOnce
  size: 10Gi
  storageClassName: "gp2" # Change this if using a different storage class

volumeClaimTemplate:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 10Gi
  storageClassName: "gp2"

nodeSelector:
  kubernetes.io/os: linux

affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: "app"
              operator: "In"
              values:
                - "elasticsearch"
        topologyKey: "kubernetes.io/hostname"
http:
  enabled: true
  service:
    type: ClusterIP
    port: 9200
  tls:
    selfSignedCertificate: true  # Using cert-manager with Let's Encrypt
EOF
  ]
}

resource "helm_release" "kibana" {
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  chart           = "kibana"
  namespace       = "elk"
  create_namespace = true

  values = [<<EOF
elasticsearchHosts: "https://elasticsearch-master:9200"

resources:
  limits:
    memory: 4Gi
    cpu: 1Gi
  requests:
    memory: 2Gi
    cpu: 500m

service:
  type: ClusterIP
  port: 5601

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: "nginx"
  hosts:
    - host: kibana.example.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: kibana-tls
      hosts:
        - kibana.example.com
EOF
  ]
}


# Fluent Bit Deployment
resource "helm_release" "fluentbit" {
  name       = "fluentbit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = "logging"
  create_namespace = true

  values = [<<EOF
config:
  service: |
    [SERVICE]
        HTTP_Server On
        HTTP_Listen 0.0.0.0
        HTTP_Port 2020
  outputs: |
    [OUTPUT]
        Name es
        Match *
        Host elasticsearch-master
        Port 9200
        Index logs
        Type _doc
        Logstash_Format On
        tls on   # Enable TLS
        tls.verify Off
        AWS_ElasticSearch On
    [OUTPUT]
        Name s3
        Match *
        bucket my-log-bucket
        region ap-south-1
        total_file_size 5M
        upload_chunk_size 1M
        json_date_format iso8601
        json_date_key timestamp
        auto_auth on
        use_put_object on
readinessProbe:
  httpGet:
    path: "/api/v1/healthz"
    port: 2020
  initialDelaySeconds: 15
  periodSeconds: 5
  failureThreshold: 5
EOF
  ]

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "1Gi"
  }

  set {
    name  = "resources.limits.memory"
    value = "512Mi"
  }

}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  depends_on = [ var.eks_cluster_id ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
  depends_on = [ var.eks_cluster_id ]
}


