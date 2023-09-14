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

Final Architecture:


   
