resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.8.0"

  create_namespace = true
  namespace        = "nginx-ingress"

  values = [
    templatefile("${path.module}/helm-values/nginx-ingress.yaml", {
      domain_name = var.domain_name
    })
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.21.3"

  create_namespace = true
  namespace        = "cert-manager"

  values = [
    templatefile("${path.module}/helm-values/cert-manager.yaml", {
      role_arn = aws_iam_role.cert_manager.arn
    })
  ]

  depends_on = [aws_iam_role_policy_attachment.cert_manager_route53]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.23.0"

  create_namespace = true
  namespace        = "external-dns"

  values = [
    templatefile("${path.module}/helm-values/external-dns.yaml", {
      domain_name = var.domain_name
      role_arn    = aws_iam_role.external_dns.arn
    })
  ]

  depends_on = [aws_iam_role_policy_attachment.external_dns_route53]
}
