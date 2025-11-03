#web instance
resource "aws_instance" "web" {
  ami                         = "ami-04f51de327e6c4656" #AMI
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.web_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = aws_subnet.public_1a.id
  # user_data                   = <<-EOF
  #       snap install amazon-ssm-agent --classic
  #       snap start amazon-ssm-agent

  #   EOF
  tags = {
    Name = "web"
  }
}
