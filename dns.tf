/*
#Istio ingress LB
#a04ebe15fe03d4254b494f4af55876ae-2072504753.ap-northeast-1.elb.amazonaws.com
# Actual there's probably a way to retrieve this dynamically... hmm

kubectl provider -> k get svc -n ${var.istio_namespace} ${helm_release.istio_ingress.chartname(?)} | jq ...
k get svc istio-ingress -n istio-system -o yaml | yq '.status.loadBalancer.ingress[0].hostname' 

Actually...
*/

resource "aws_route53_record" "records" {
  for_each = toset([
    "",
    "app.server4.",
    "dev.vault.",
    "dev",
    "docker.nexus.",
    "monitor.",
    "nexus.",
    "server4.",
    "vault."
  ])

  zone_id = var.r53_zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = 5

  records = [data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname]
}



