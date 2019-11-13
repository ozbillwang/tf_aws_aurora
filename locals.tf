locals {
  common_tags = {
    "stack"     = var.stack
    "env"       = var.env
    "terraform" = "true"
  }

  name = "${var.stack}-${var.env}"
}

