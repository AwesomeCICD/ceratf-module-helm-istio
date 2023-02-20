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
            "${oidc_provider_name}:sub": "system:serviceaccount:${namespace}:${r53_service_account_name}"
          }
        }
      }
    ]
  }