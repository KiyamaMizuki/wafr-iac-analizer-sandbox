resource "aws_iam_role" "web" {
  name               = "web"
  assume_role_policy = data.aws_iam_policy_document.web_assume_role.json
}
data "aws_iam_policy_document" "web_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_ssm_managed_instance_core" {
  role       = aws_iam_role.web.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

# privte-isuインスタンスプロファイルを作成
resource "aws_iam_instance_profile" "web_profile" {
  name = "web-instance-profile"
  role = aws_iam_role.web.name
}

# iam.tf に追記

data "aws_iam_policy" "enhanced_monitoring" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

#aurora用のIAMロールを作成
resource "aws_iam_role" "rds_monitoring_role" {
    name = "rds-monitoring-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "rds.amazonaws.com"
            }
        },
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "monitoring.rds.amazonaws.com"
            }
        },
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })

    tags = {
        Name = "private-isu RDS Monitoring Role"
    }
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring_attachment" {
    role       = aws_iam_role.rds_monitoring_role.name
    policy_arn = data.aws_iam_policy.enhanced_monitoring.arn
}