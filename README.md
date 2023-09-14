# WordPressProject
The project contains terraform scripts to
1. Deploy a virtual network spread across the 2 availability zones (AZ) in a aws region
2. Deploy a highly available and fully managed rds database across the 2 AZs
3. Deploy an amazon Elastic File System (EFS) to provision a shared storage layer across the 2 AZs for the application tier
4. Deploy web servers with auto scaling groups (ASG) that automatically scales in response to load variations for the application tier
