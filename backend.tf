terraform {
      backend "s3" {
      bucket         = "lahari-s3-terraform-2097" 
      key            = "lahari/terraform.tfstate"
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "terraform-lock"
   }
  }
