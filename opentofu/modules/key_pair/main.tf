resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags       = var.tags
}