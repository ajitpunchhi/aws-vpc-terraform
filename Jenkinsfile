
pipeline{
    agent any
    
    environment{
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage('clone repository') {
            steps {
                echo 'Cloning repository...'
                // Replace with your repository URL
                git url: 'https://github.com/ajitpunchhi/aws-vpc-terraform.git', branch: 'main'
            }
        }
        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform changes...'
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform changes...'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('upload state file') {
            steps {
                echo 'Uploading Terraform state file to S3...'
                sh 'aws s3 cp terraform.tfstate s3://ajitterraform/'
            }          
            
        stage('Terraform Destroy') {
            steps {
                echo 'Destroying Terraform resources...'
                sh 'terraform destroy -auto-approve'
            }
        }   
        stage('destroy terraform state file') {
            steps {
                echo 'Deleting Terraform state file...'
                sh 'aws s3 rm s3://ajitterraform/terraform.tfstate'
            }
        }
    }  
    }
}