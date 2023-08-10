{
	"Version": "2012-10-17",
	"Statement": [
	  {
		"Effect": "Allow",
		"Action": "route53:GetChange",
		"Resource": "arn:aws:route53:::change/*"
	  },
	  {
		"Effect": "Allow",
		"Action": [
		  "route53:ChangeResourceRecordSets",
		  "route53:ListResourceRecordSets"
		],
		"Resource": "arn:aws:route53:::hostedzone/${r53_zone_id}"
	  },
	  {
		"Effect": "Allow",
		"Action": "route53:ListHostedZonesByName",
		"Resource": "*"
	  }
	]
  }