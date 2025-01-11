resource "aws_eip" "this" {
  instance = var.instance
  domain = var.domain

  tags = var.tags
}