output "accelerator_dns_name" {
  value = aws_globalaccelerator_accelerator.this.dns_name
}

output "accelerator_static_ips" {
  value = aws_globalaccelerator_accelerator.this.ip_sets
}