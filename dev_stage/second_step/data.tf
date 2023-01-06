data "terraform_remote_state" "first_step" {
  backend = "s3"
  config = {
    bucket = "maintfstatebucketarevozyan"
    key    = "dev_stage/scraperapidash/firststep.tfstate"
    region = "us-east-2"
  }
}

