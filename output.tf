output "instance_id" {
  value = aws_instance.example.id
}

output "instance_type" {
  value = aws_instance.example.instance_type
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

output "public_dns" {
  value = aws_instance.example.public_dns
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "Sgroup_id" {
  value = module.vpc.aws_security_group
}