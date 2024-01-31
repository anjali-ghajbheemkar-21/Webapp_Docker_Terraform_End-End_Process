# Basic Template Structure & Working
[![License](https://img.shields.io/github/license/cicirello/pyaction)](https://github.com/cicirello/pyaction/blob/master/LICENSE)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/cicirello/pyaction?logo=github)](https://github.com/cicirello/pyaction/releases)

# AWS IAM USER
    * For this we mainly used two different policies for two different users.
        *  _Website_CI policy for the user based CI-CD Pipeline, who gonna deploy website over cloud.
        *  -Website-ProxyCIPushECR policy for proxy based NGINX CI-CD Pipeline, who gonna deploy SERVER over cloud and help website.
    * These policies are made private and assigned to only to the data in these policies refer towards only to the repositories created.
    * For this we create two different uses, where only programatic access is assigned. Because we want the user's to work as robots.So, we aren't providing password access it.

#### NOTE :: DON'T DELETE ANY OF THE USER.

### Dockerfile

    * apk referes alpine package manager.
    * The first app under copy is project directory in local environment.
    * The second app under copy is project directory name in docker container.
    * adduser --disabled-password --no-create-home app, this line will create a user by the name app.
    * USER app, the name of the user provide above.
    * apk add --update --no-cache postgresql-client; will download the postgresql client required for the connection of postgresql database.
    * apk add --update --no-cache --virtual .tmp-deps; will consider only the main files and delete the dependencies to make the container light weight.
    * mkdir -p /vol/web/static && \ considers the static files of application.
    * mkdir -p /vol/web/media && \ considers the media files uplodaded post production.
    * -R means recursive
    * As there was error in the mirroring of alpine, update with new mirror value.


### docker-compose.yml

    * The services refer to create different containers named as app and db.
    * Content refers the root directory.
    * Ports refer to the working ports.
    * The volumes refer the django project directory in local environment to the django directory in docker container
    * THis will manually restart the server to consider the changes by docker.
    * We named both directories with same name so don't get confused.
    * It's a fake secret key updated under the environment variables; and debug=1 because we want to run the code in debug mode.
    * Created new service called db, which uses the postgres database image. As we need a database for further usecases.
    * depends_on=db will help in the network connection in between services.
    * Created command under the build, becuase we want to make sure the process gets automated and follows a sequential method in running.


### Commands

    * docker-compose run --rm app sh -c "django-admin startproject project name ." This will help in creating a djangoproject in root directory.
    * docker-compose run --rm app sh -c "python manage.py startapp appname" This will help in creating the application using django cli.
    * Every time we do any changes in the files related to docker and in settings.py we need to run docker-compose build in order to make sure the container considers all the updated changes and creates new image container.
    * docker-compose run --rm app sh -c "python manage.py startapp makemigrations" This will help in running the migrations related to the project.
    * docker-compose -f docker-compose-deploy.yml down --volumes is used in order to run the production level deploy method of yml file.
    * docker-compose -f docker-compose-deploy.yml build to build thev container by considering the docker-compose-deploy.yml file.
    * docker-compose -f docker-compose-deploy.yml up to run the production level docker container.


### Configure Settings.py for production based environment.

    * In debug mode we create a bool value in which we provided 0; which means its a default value when we are running it locally.
    * Change the database to postgres and connected with docker-compose.yml where we can update the postgres changes dynamically.


### Configured wait_db.py

    * The reason to create wait_db.py is to create a gap between the connection of django sql server and python code.
    * As the project gonna be in production server, if there's no proper wait time the database will ge crashed or shows unkown error. So by telling user to wait for couple of seconds will help the server connect to django sql up and runing.


### proxy Folder

    * The proxy folder hold the data of the uwsgi params, which are used for the nginx server.
    * usgi_params file will hold all the parameters of the nginx server.
    * default.conf.tpl is the nginx configuration and helps nginx how to handle our files.
    * entrypoint.sh is used to run the proxy folder.
    * daemon refers the docker.
    * The reason to again create a Dockerfile inside proxy is to help in the production server environment.


### Configuring our application to run as a uWSGI service ( In Production Environment )

    * For this we created a folder by the name scripts which hold the run.sh file and the commands that help to run server in production environment.


### Configuring docker-compose for production level environment

    * docker-compose-deploy.yml will hold all the configuration required for the production level deployment.
    * The environment under services will hold the configuration of postgresql database and the allowed_host we are gonna use.
    * From now on we wont be using any files that are related to docker-compose.yml which we used to the development environment.
    * We will be using docker-compose-deploy.yml for the production level, for this we will be using the command docker-compose -f docker-compose-deploy.yml down --volumes
    * The reason to use docker-compose-deploy.yml down --volumes will delete all the previous volumes created and which gonna conflict with the main files.
    * Once the volumes are deleted we need to run the command docker-compose -f docker-compose-deploy.yml build inorder to build the container of production level.


## Configuring AWS CLI In Local

    * Follow this link to install the AWS-CLI updated version https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd
    * Post installation of AWS CLI configure the AWS Credentials by following the link:https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
    * The credentials required are IAM user credentials not the ROOT User Credentials.
    * aws configure list to list out the profiles registered in AWS CLI.
    * aws configure list-profiles this will list out different profile names, there will be a profile by name default initially.
    * aws configure --profile profile_user_name this will help in storing of the default credentials in AWS CLI.


## AWS Vault Configuration

    * Inorder to create AWS Vault in out local machine we need to install using home brew.
    * Search for AWS Vault in google and you will get the latest version of it available in github.com/. Run the link in brew and it gets installed.
    * Now we need to store the IAM user credentials in AWS Vault.
        * For this we need to run aws-vault add iamuser name
        * This will ask for AccessKey Id & Secret AccessKey, provide them and type in system password to store them.
    * From next time when we want to use AWS Vault we need to type in the MFA code to run AWS Vault.
    * sudo nano ~/.aws/config this will open a config file where our IAM user config file is being stored.
        * Type in region=our s3bucket region
        * mfa_serial=our mfa serial key available at iam user.
    * aws-vault exec iamusername to run the aws-vault command.
    * DON'T CHANGE ANYTHING IN THIS CONFIGURATION.
    * https://github.com/99designs/aws-vault/blob/master/USAGE.md#overriding-the-aws-cli-to-use-aws-vault
    * If aws-vault comes with any problem, like this unset AWS_VAULT to force. Run the command in terminal export AWS_VAULT="" this will make aws-vault clear and perfect. Makes sure the aws-vault runs again perfectly.
    * aws-vault remove iamusername to delete the iam user credentials.
    * aws-vault clear iamusername to delete the iam user session.
    * aws-vault exec iamusername --duration=35h to run for stipulated time session only.
    * aws-vault list provides the list of users created in aws-vault, by default we will be having dedault value as a user.

## Terraform

    * Using terraform helps in maintaining our code and deployment process much easier and faster.
    * We can configure anything that need to be created in the aws/gcp/azure directly from here that helps in the CI-CD Pipeline.
    * For creating terraform locally we need to have a mandatory files like
        * main.tf which holds the terraform image and cloud bucket configurations.
        * bastion.tf which holds the server configuration which need to be run automatically for making the website run smoothly.
        *
    * In s3 bucket created a file called  -devops-terraform and in permissions enabled versioning.
    * Created table in dynamo db by the name  -devops-terraform-lock and lockID as Partition Key / Primary Key where the terraform lock files are being stored.
    * Created File with name main.tf and entered names of the bucker names created in s3 & dynamo db.
    * Under s3 bucket we need to provide the key name in which the terraform lock files are being stored which will end with   .tfstate
    * Provided information to terraform that to create a table in the dynamodb by the name  -devops-terraform-lock-dynamodb-table".
    * Run aws-vault exec iam_user_name in the terminal, this is mainly used for the integration of aws keys we linked in our local machine with the folder aws keys which we installed earlier by the name aws-keys using git.
    * Once We run in terminal it will ask for Multi Factor Authentication we setup for the IAM user, need to provide keys and run it.
    * After Clearing the passwords open terminal and again type the same command, if we dont get any error we ar good to go. If there are any errors we need to follow the above steps again.
    * Run this command inorder to initialise terraform in our project. docker-compose -f deploy/docker-compose.yml run --rm terraform init. The initialised prompt will help in creating a teraaform server locally and helps in connecting to the cloud server from our local environment.
        * If you ever set or change modules or backend configuration for Terraform, rerun this command to reinitialize your working directory. If you forget, other commands will detect it and remind you to do so if necessary. Inorder to reinitialize terraform we need to run the following command docker-compose -f deploy/docker-compose.yml run --rm terraform init-reconfigure
    * Once we run the git init command it will create a folder by the name .terraform which include linux based os which helps the terraform to run in local development environment.
    * Post the creation of .terraform folder in our local machine we need to check whether the terraform is valid ornot for this we need to run the following command docker-compose -f deploy/docker-compose.yml run --rm terraform validate. This command will tell whether the terraform is valid or not, if it's not valid we need to make changes for the main.tf file and rerun the initialisation process.
    * Once we are successfully validated the terraform we need to plan the terraform for further processing. For this we need to run the following command docker-compose -f deploy/docker-compose.yml run --rm terraform plan. This command will provide all the information all the necessary tasks that terraform need to run/gonna update in the apply state.
    * In order to create the terraform instance over cloud and make webstie up and running we need to run, docker-compose -f deploy/docker-compose.yml run --rm terraform apply. This command is  also used to aply any cnfiguration changes that has been taken over for the terraform files. The apply command will consider all the configured information from bastion.tf and creates instances in the ec2console and a .tfstate folder in s3 bucket.
    * In order to destory the terraform instance over cloud we need to run the following command docker-compose -f deploy/docker-compose.yml run --rm terraform destroy. -- Heavy Risk to run this command in production level.
    * When we are using terraform it will by default create a workspace which helps us in the development of our environment by the name default. Inorder list the different workspaces we are using or created under terraform we need to run the following command docker-compose -f deploy/docker-compose.yml run --rm terraform workspace list. This will list all of the workspace environments under terraform.
        * Inorder to create a new terraform workspace we need to run the following command docker-compose -f deploy/docker-compose.yml run --rm terraform workspace new workspace_name.
    * Once the terraform server is up and running we will get many ec2 instances creeated in aws, differentiating between these instances for debugging will be tiresome as we couldn't find which instance refer to which system, so we will be suing variables.tf file for creation and storing of the instance names. variables.tf hold the names of the instance names which we desire to provide to the instance. Terraform will does this automatically for us.
        * For this we can provide a default prefix name for the instance.
        * Once we updated the default instance name in varibales.tf, we need to open main.tf and add locals and add the prefix.
        * The prefix will hold the prefix variable name and terraform work space name, for now we created a workspace called dev.
        * Navigate to bastion.tf and add tags under resources. This will create the tag name which ends with bastion.

<img src='https://quintagroup.com/services/service-images/terraform.jpg/@@images/b2bc0e63-614c-4c37-a369-3e2943091ebf.jpeg' width='100%' align='center'></img>

## VPC Network -- Virtual Private Cloud

    * VPC is mainly used in order to assign the application to cloud which will be used for our network requirements.
    * The requirements include subnets, internet gateway & nat gateway.
    * This will help in isoalting the different environments like development, staging and production, over the cloud inorder to makesure there won't be any conflicts in between other environments.
    * If someone breaks in to our one specific environment, they won't be able to access other environments.

<img src='https://cloudonaut.io/images/2016/10/vpc@730w2x.webp' width='100%' align='center'></img>
<img src='https://cpb-us-e1.wpmucdn.com/blogs.cornell.edu/dist/b/5998/files/2016/04/Typical-Cornell-VPC-Configuration-1f8gtsn.png' width='100%' align='center'></img>

    * Classless Inter-Domain Routing == cidr_block, is a method for allocating IP addresses and for IP routing.
    * <a href="https://www.aelius.com/njh/subnet_sheet.html">Inorder to understand more on the cidr_block, refer the link.</a>
    * The link mentioned above will help in understand the different numbers and the usecases of it.
    * For creating VPC network we need to have a cidr_block which refers to the Id's. These Id's are important inorder to run the website.
    * In this project this is our cidr_block of subnet 'cidr_block = "10.1.1.0/24"', in this we are using /24 as our netmask. The netmask /24 is capable of providing 254 different hosts. Which means per subnet we create we have 254 different host names. We can even update the subnet i'd numbers. Refer the above link in order to change with new subnet values.

<img src='https://www.tutorialspoint.com/ipv4/images/class_a_subnets.jpg' width='50%' align='center'></img>

    * The VPC we are using will be created across two different region's. Each region will include public and private subnets. The main reason to create two VPC across different regions to balance the load on servers so that the latency will reduce.
    * In network.tf file we will be differentiating the network subnet vpc's with the letter's a & b. If we look in the AWS-REGIONS, we will be seeing the regions like us-east-1, us-east-2, us-west-1, us-west-2, like this. If we choose the default region provided for the S3 bucket, this will consider us-east-1 and under this region this will create us-east-1a and us-east-1b.
    * Inorder to create sub-regions under the region, initially we mentioned the alphabets at the end of resource.
    * If we look at the network.tf under Public Subnets - Inbound/Outbound Internet Access; we created two different regions called a-side and b-side regions.
    * The template code of aws_subnet, aws_route_table, aws_route_table_association, aws_route, aws_eip, aws_nat_gateway are similar; but the main changes are in the cidr_block.
    * The cidr_block for the region-a is 10.1.1.0 and the cidr_block for the region-b is 10.1.2.0 and the public subnet region is varied by the alphabets a & b. This is to make sure that the sub regions are created under the main region.
    * Example of private subnets is our database in the cloud provider, no need to have a direct internet access, because this happens in the backend of our infrastructure. This will help in the more secure way of connecting to our website and reduce attack vectors.
    * As similar to the public subnets need to create private subnet will less access and more security to it.

#### Note :: Public Subnets are required for the Inbound/Outbound Internet Access && Private Subnets are required only for the Outbound Internet Access

## Issues with GitHub

    * The file sizes of the terraform is huge whcih makes git to stop from uploading to cloud.
    * To overcome the problem we need to follow the following steps.
        * git rm --cached giant_file (In the place of giant file we need to provide the file and path of the huge file which we can get from error logs of git in terminal. By running this command Stage our giant file for removal, but leave it on disk)
        * git commit --amend -CHEAD (Amend the previous commit with your change, Simply making a new commit won't work, as you need to remove the file from the unpushed history as well)
        * git push (code gets pushed in to cloud by ignoring the huge file.)

## GITLAB CI-CD Pipeline

    * In the gitlab pipleine we mainly created following stages;
        * Test and Lint
        * Build and Push
        * Staging Plan
        * Staging Apply
        * Production Plan
        * Production Apply
        * Destroy
    * In the gitlab pipleine we mainly created staging env, productionenv and destruction env.
    * The usages vary from one to other.
        * Staging Environment will consider all the changes in code commited and will create a staging environment, which is mandatory for checking any errors in the website before pushing in to production environment.
        * The test cases passed in the staging environment will be then pushed in to production environment for updating the website for user interaction.
        * The Reason to create staging plan, staging apply, production plan and production apply is to check in which stage the website testing is facing issue.
        * In production environment which include staging and apply we aren't commiting any thing to git branches, this is because we want the commits to be applied to the production level website. So we directly mentioned it "production" with out any branch name.
        * Destroy is one another rule we are using as this helps in killing the enviroment branches that has been created for different usecases. Which include staging & production.
    * In the .yml file whie installing docker-compose by default we will face errors W.R.T rust-compiler which was downgraded by the cryptography wheels for the latest version of docker-compose. Inorder to overcome the issue we need to stop exporting & building the rust-compiler in to the docker-environment. For this, we need to add the following command before installing docker-compose with pip.
        * export CRYPTOGRAPHY_DONT_BUILD_RUST=1

## Overcoming flake8 Error Handling

    * flake8 is mainly used in making our application more understandable to new people, by removing the unqanted stuff and indentation properly.
    * For this there are two ways to overcome the problem of linting.
        * Type-1 :: Add .flake8 in the project root directory and update with following commands.
            * [flake8]
            * exclude = .git,*migrations*
            * max-line-length = 119
        * Type-2 :: Adding the linting directly to flake8.
            * flake8 --max-line-length 119
    * In Type-1, this consider all the files & folders and bypasses the error outcome. We can add other error file's aswell. We can directly provide .py files and flake8 won't consider python files for the error poppings.
    * In Type-2, this can be only done for the characters count.

## Route53
    
    * Once the website is ready to get served over cloud, we need to get a domain. This domain can be from any registrar, for now I'm using domain registered with godaddy.
    * Once we got the domain registered successfully. Navigate to AWS and open ROUTE53.
    * As our servers are with godaddy, we need to make sure that our servers are ported towards cloud provider to host our website, whether by considering AWS or GCP or AZURE or DIGITALOCEAN.
    * We need to make sure our servers are ported to AWS, for that we need to update the NS[Name Servers] with godaddy.
    * Open AWS, create a hostedzone as similar as your website name. In my case,  .com is my host name. So, I need to create a hostedzone with the same name.
    * Once hostedzone gets created, you can find 2-4 NS records under it. Copy and paste them under godaddy servers page.
    * Upation takes in b/w 24-48 hrs, once the time is done your website will be up and running under AWS servers.

# Connecting CI-CD Pipeline -> AWS Instances Configuration

<h4 align='center'>Gitlab CI-CD
    <span>
    <img src='https://about.gitlab.com/images/press/logo/png/gitlab-icon-rgb.png' width='10%' align='center'>
    </span>
+ Terraform
    <span>
    <img src='https://www.scalefactory.com/blog/2021/04/30/hashicorp-terraform-release-key-rotation/Terraform.png' width='10%' align='center'>
    </span>
+ AWS ECR
    <span>
    <img src='https://www.nclouds.com/img/services/toolkit/ecr.png' width='15%' align='center'>
    </span>
+ AWS EC2
    <span>
    <img src='https://miro.medium.com/max/1400/1*LdDE1ymsojPJ5nmH9S28uQ.png' width='15%' align='center'>
    </span>
</h4>

<h1 align='center'> Full Structure
    <span>
    <img src='https://raw.githubusercontent.com/NVISIA/gitlab-terraform/master/blog-images/figure1.png' align='center'>
    </span>
</h1>

    * Inorder to the changes we did to the project that are perfectly aligned or not, we will be using local deployment server.
    * But when we are pushing the changes over the cloud we need to have two environments called as Staging & Production environments.
    * Staging environment will helps us to check whether all the changes updated are implementes or not. This also helps us to make sure if there's any errors that gonna effect the main page will display the errors.
    * If we don't use the staging environment and directly push the code to cloud if there are no errors everything is well and good and if there are any errors in the code and pushed to the production environment this will effect the page very badly.
    * So first we need to test out our servers working process and code deployed in the staging environment.
    * Once the code passes the staging environment we need to push it in to the production environment for user testing.
    * Inorder to bypass the process we are using terraform as out IAAS and GITLAB as out CI-CD Pipeline tool.
    * Now, inorder to make the process smooth, we need to create a new IAM user specifically only for the Integration of code pushed to gitlab will be pushed to the AWS cloud servers. A <a href="https://gitlab.com/LondonAppDev/recipe-app-api-devops-course-material/-/snippets/1944972">specific policy</a> is required to create that user.
    * Create a new policy, Copy and Paste the configuration in the json section of policies and update the configuration with our S3 bucket name specifically created for storing tf-state files, ECR folder name and dynamodb_table name. Save it and assign the created policy to the CI - IAMUser profile.
    * Open GITLAB headover to Settings -> CI/CD -> Variables -> Update the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, ECR_REPO URI in the settings and save the configuration.
    * Open .gitlab.yml file in project folder update the yaml file with the terraform image configuration, which include the recent commit ID collects from gitlab, ecr_repo, access key and secret key stored in the variables section.
    * Once the above process is done, the configuration is ready to be pushed over the cloud provider.

#### Note :: We want to make sure the process of pushing code to cloud server (AWS) is automated, which helps us reduce time on the creation of servers manually and connecting them with gitlab.

## Staging Level Deployment

    * Staging environment include two stages,
        * Stage-1 :: Planning
        * Stage-2 :: Apply Changes
    * In Stage-1, we will plan the actions that the process need to be carried out to the cloud provider, which include navigation to the project folder.
    * Exporting the terraform image in to the docker container and initialising the terraform.
    * Once terraform is initialised and read to next process, need to create a new environment for the staging section.
    * The next process will be planning what actions need to be applied for the servers. For this we need to run terraform plan, this will provide detailed information on the changes/updations that gonna be done to the servers in aws/gcp/azure.
    * In stage-2, we the changes/updation that all are planned need to be applied to the servers, for this we need to run a terraform command. terraform apply.
    * For this the basic process of navigation to the deployment folder and initialising the terraform need to be done.
    * The terraform environment created previously should need to be considered as main workspace for pushing the code in to staging section.
    * Finally we need to run the command which will apply the changes, terraform apply.

## Production Level Deployment

    * Production environment include two stages,
        * Stage-1 :: Planning
        * Stage-2 :: Apply Changes
    * In Stage-1, we will plan the actions that the process need to be carried out to the cloud provider, which include navigation to the project folder.
    * Exporting the terraform image in to the docker container and initialising the terraform.
    * Once terraform is initialised and read to next process, need to create a new environment for the production section.
    * The next process will be planning what actions need to be applied for the servers. For this we need to run terraform plan, this will provide detailed information on the changes/updations that gonna be done to the servers in aws/gcp/azure.
    * In stage-2, we the changes/updation that all are planned need to be applied to the servers, for this we need to run a terraform command. terraform apply.
    * For this the basic process of navigation to the deployment folder and initialising the terraform need to be done.
    * The terraform environment created previously should need to be considered as main workspace for pushing the code in to staging section.
    * Finally we need to run the command which will apply the changes, terraform apply.

#### Note :: The main difference b/w staging and production environment's is, in staging we can check our website working process in actual cloud infrastructure.
