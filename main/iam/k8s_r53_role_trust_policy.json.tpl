{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${oidc_provider_name}:aud": "sts.amazonaws.com",
            "${oidc_provider_name}:sub": "system:serviceaccount:${istio_namespace}:${r53_service_account_name}"
          }
        }
      }
    ]
  }