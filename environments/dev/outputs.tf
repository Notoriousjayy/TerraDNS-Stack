output "instance_public_ip" {
  description = "Public IP of the Debian EC2 instance"
  value       = module.ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the Debian EC2 instance"
  value       = module.ec2.public_dns
}

output "private_key_pem" {
  description = "The generated private key; save this securely!"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}
