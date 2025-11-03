resource "aws_db_instance" "db" {
    identifier           = "db"
    engine               = "mysql"
    instance_class       = "db.t3.micro"
    allocated_storage    = 20
    db_name              = "mydb"
    username             = "admin"
    password             = "password"
    db_subnet_group_name = aws_db_subnet_group.rds.name
    vpc_security_group_ids = [aws_security_group.rds.id]
    multi_az = false
    skip_final_snapshot = true
    deletion_protection = false#←この設定をfalseにすること
}
