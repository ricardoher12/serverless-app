# Serverless App
A serverless App using an Api Gateway, lambda functions, Dynamo DB and Terraform.

## What id does?
This Terraform template, deploys an Api Gateway invoking three lambda functions saving/getting the info from Dynamo DB.

## Modules

### DB
In this module is in which the Dynamo DB table is created, it has the following parameters:

* db_name: refers to the name with which the Dynamo DB table will be created.
* db_billing: refers to the billing type that will be used in the table created.
* db_read_cap: refers to the reading capability of the database.
* db_write_cap: is the writting capability of the database

The outputs for this module are:
* db_arn
* db_name

### Lambda
In this module the lambdas for the create, delete and get modules are created, also in this module the policy for modify the Dynamo DB, created prevously, is set to the different functions. The module's parameters are:
 
* table_arn: is the dynamo table's arn created in the DB module.
* table_name:  is the dynamo table's name created in the DB module.
* stack_name: is the project's name.

The outputs for this module are:

* post_function_name
* post_function_arn
* get_function_name
* get_function_arn
* delete_function_name
* delete_function_arn

### API
In this module is where the API Gateway is created and deployed, also the HTTP methods are created and configured with their respective lambda function. The module's parameters are:

* api_name: refers the name with which the API will be created.
* aws_profile: the profile configured with the credentials.
* aws_region: the region in which the resources will be created.
* function_post_name: the post lambda function's name.
* function_post_arn: the post lambda function's arn.
* function_get_name: the get lambda function's name.
* function_get_arn: the get lambda function's arn.
* function_delete_name: the delete lambda function's name.
* function_delete_arn: the delete lambda function's arn.

### Main
Is the module in which the other modules are invoked and created.
