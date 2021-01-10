data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_eip" "nat" {
  count = "${var.networking_module.enabled && var.networking_module.nat.enabled ? length(var.networking_module.private_subnet.cidr) : 0}"
  vpc   = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = var.networking_module.enabled

  name = "${var.meta.project_slug}-${var.meta.environment}-vpc"
  cidr = var.networking_module.vpc.cidr

  azs             = data.aws_availability_zones.available.names
  public_subnets  = var.networking_module.public_subnet.cidr
  private_subnets = var.networking_module.private_subnet.cidr

  enable_nat_gateway  = var.networking_module.nat.enabled
  single_nat_gateway  = var.networking_module.nat.single_nat_gateway
  reuse_nat_ips       = var.networking_module.nat.reuse_nat_ips
  external_nat_ip_ids = "${aws_eip.nat.*.id}"

  enable_dns_hostnames = var.networking_module.vpc.enable_dns_hostnames
  enable_dns_support   = var.networking_module.vpc.enable_dns_support

  tags = merge(var.meta.project_tags, {
    Environment = var.meta.environment
    Terraform   = "Yes"
  })
}
