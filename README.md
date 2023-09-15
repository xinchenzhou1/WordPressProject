# Usage
1. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Have an AWS IAM user account with sufficient permissions to create the necessary resources shown in the architecture diagram
3. Configure AWS IAM credentials using environment variables [AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
4. Fill up the sensitive variable values in terraform.tfvars file
5. Run ```terraform init``` to initialize
6. Run ```terraform plan``` to inspect infrastructure
7. Run ```terraform apply``` to create infrastructure
8. Example Word Press application URL (append "/wp-login.php" after the DNS Name of ALB): myWPAppELB-5e007e74j7f638.ca-central-1.amazonaws.com/wp-login.php
9. Run ```terraform destroy``` to clean up
# WordPressProject
The project contains terraform scripts to
1. Deploy a virtual network spread across the 2 availability zones (AZ) in a aws region
   ![wordpress architecture draft](https://github.com/xinchenzhou1/WordPressProject/assets/113848420/f9356c09-923a-44aa-ba83-a6076805e253)
2. Deploy a highly available and fully managed amazon aurora rds primary instance in one AZ and a read replica in the other AZ
   ![wordpress architecture rds](https://github.com/xinchenzhou1/WordPressProject/assets/113848420/447280e1-d452-4e46-b0fc-a0b4364eb242)
3. Deploy an amazon Elastic File System (EFS) to provision a shared storage layer across the 2 AZs for the application tier
   ![EFS wordpress architecture rds](https://github.com/xinchenzhou1/WordPressProject/assets/113848420/d3868bd7-a7dc-4404-aacc-94b0b25eac09)
4. Deploy web servers with auto scaling groups (ASG) that automatically scales in response to load variations for the application tier
  ![ASG wordpress architecture rds](https://github.com/xinchenzhou1/WordPressProject/assets/113848420/c5868bed-9d81-40fb-b15d-7b93a77a423c)
5. Final Architecture
  ![final draft wordpress architecture rds](https://github.com/xinchenzhou1/WordPressProject/assets/113848420/57a07d49-358b-4c9e-b82a-651a2135c76d)




   
