resource "aws_globalaccelerator_accelerator" "this" {
  name            = "prod-multi-region-accelerator"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "http" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port   = 80
    to_port     = 80
  }
}

# Endpoint Group for Region A (Primary)
resource "aws_globalaccelerator_endpoint_group" "region_a" {
  listener_arn            = aws_globalaccelerator_listener.http.id
  endpoint_group_region   = "us-east-1"
  traffic_dial_percentage = 100

  endpoint_configuration {
    endpoint_id = var.region_a_alb_arn
    weight      = 128
  }
}

# Endpoint Group for Region B (Secondary / Standby)
resource "aws_globalaccelerator_endpoint_group" "region_b" {
  listener_arn            = aws_globalaccelerator_listener.http.id
  endpoint_group_region   = "us-west-2"
  traffic_dial_percentage = 0 # 0 for active-passive failover testing

  endpoint_configuration {
    endpoint_id = var.region_b_alb_arn
    weight      = 128
  }
}