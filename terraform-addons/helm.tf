resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.8.1"

  create_namespace = true
  namespace        = "nginx-ingress"

  values = [
    file("${path.module}/helm-values/nginx-ingress.yaml")
  ]

}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  namespace        = "cert-manager"
  version          = "v1.21.3"

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = data.terraform_remote_state.infrastructure.outputs.cert_manager_role_arn
    }
  ]

  values = [
    file("${path.module}/helm-values/cert-manager.yaml")
  ]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  version          = "1.23.0"
  create_namespace = true
  namespace        = "external-dns"

  values = [
    file("${path.module}/helm-values/external-dns.yaml")
  ]

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = data.terraform_remote_state.infrastructure.outputs.external_dns_role_arn
    }
  ]
}
