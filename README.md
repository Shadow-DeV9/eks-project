# EKS KubeSpace

This project deploys the KubeSpace application to EKS and exposes it through the
NGINX Ingress Controller. Terraform installs NGINX Ingress, cert-manager, and
ExternalDNS with Helm. Cert-manager uses a Let's Encrypt production
`ClusterIssuer` with Route53 DNS-01 validation; ExternalDNS publishes the
application hostname to the NGINX load balancer.

## Prerequisites

- AWS CLI credentials with permission to manage the project infrastructure,
  Route53, EKS, and IAM OIDC roles.
- Terraform and Helm provider support (Terraform installs the provider during
  `terraform init`).
- A public Route53 hosted zone named `shoshin.org.uk` in the same AWS account.
- The application image pushed to the ECR repository referenced by
  `k8s/deployment.yaml`.
- A `kubespace-secret` Secret in the `default` namespace with the `APP_TOKEN`
  key required by the Deployment. Create it from a secure source; do not commit
  real credentials in `k8s/secret.yaml`.

The domain defaults to `shoshin.org.uk` in `terraform/variables.tf`. If using a
different domain, set `domain_name` during Terraform operations and update the
host in `k8s/ingress.yaml` to match.

## Deploy

The Helm provider needs an already-created EKS API endpoint. Apply the EKS
infrastructure first, then apply Terraform again to configure IAM OIDC roles
and install the Helm releases:

```sh
cd terraform
terraform init
terraform apply -target=module.eks
aws eks update-kubeconfig --region eu-north-1 --name example
terraform apply
```

The Terraform backend uses the S3 bucket created by `bootstrap/`. If that bucket
does not exist yet, initialize and apply the bootstrap configuration first.
The targeted apply is only for the initial EKS creation; use a normal
`terraform apply` for subsequent changes.

Wait for the add-ons to become ready, then install the issuer and application:

```sh
kubectl get pods -n nginx-ingress
kubectl get pods -n cert-manager
kubectl get pods -n external-dns
kubectl wait --for=condition=Established --timeout=120s crd/clusterissuers.cert-manager.io
kubectl apply -f ../k8s/cluster-issuer.yaml
kubectl apply -n default -f ../k8s/configmap.yaml
kubectl apply -n default -f ../k8s/deployment.yaml
kubectl apply -n default -f ../k8s/service.yaml
kubectl apply -n default -f ../k8s/ingress.yaml
```

Create or verify the `kubespace-secret` before applying the Deployment. The
ingress controller's public Network Load Balancer is annotated for ExternalDNS,
which publishes the application hostname. Once DNS has propagated,
cert-manager creates the `kubespace-tls` Secret for the Ingress.

## Verify

```sh
kubectl get svc -n nginx-ingress
kubectl get ingress,certificate -n default
kubectl describe certificate kubespace-tls -n default
```

The certificate should become `Ready=True`. Check the Certificate and
cert-manager Challenge events if issuance is pending; verify the public
Route53 zone, OIDC role annotations, and the domain's DNS resolution before
troubleshooting the ACME challenge.
