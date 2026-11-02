resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress-controller"

  create_namespace = true
  namespace        = "nginx-ingress"
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = "cert-manager"

  # set {
  #    name = "wait-for"
  #    value = "module.cert_manager_irsa_role.iam_role_arn"
  #  }
  # This code above is what my mentor showed however i do not have a module irsa role so how do i work around this bc i belive that i need the cert manager permission role or a separate role that has the cert-manager role

  set = [{
    name  = "global.imagePullSecrets[0].name"
    value = "regcred"
  }]

  values = [
    file("${path.module}/helm-values/cert-manager.yaml")
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"

  values = [
    file("${path.module}/helm-values/external-dns.yaml")
  ]

  set = [{
    name  = "provider"
    value = "aws"
    },
    {
      name  = "aws.zoneType"
      value = "public"
    },
    {
      name  = "txtOwnerId"
      value = "my-identifier"
    },
    {
      name  = "policy"
      value = "upsert-only"
    },
    {
      name  = "rbac.create"
      value = true
    },
    {
      name  = "serviceAccount.create"
      value = true
    },
    {
      name  = "serviceAccount.name"
      value = "external-dns-sa"
  }]
}
