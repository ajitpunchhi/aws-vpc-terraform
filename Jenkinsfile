pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning Terraform repository...'
                git url: 'https://github.com/ajitpunchhi/aws-vpc-terraform.git', branch: 'main'
            }
        }
        
        stage('Download State File') {
            steps {
                echo 'Downloading state file from S3...'
                sh '''
                    aws s3 cp s3://ajitterraform/terraform.tfstate . || echo "No existing state file found"
                '''
            }
        }
        
        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }
        
        stage('Check If Resources Exist') {
            steps {
                echo 'Checking if resources already exist...'
                script {
                    def planExitCode = sh(
                        script: 'terraform plan -detailed-exitcode',
                        returnStatus: true
                    )
                    
                    if (planExitCode == 0) {
                        echo '✅ Resources already exist and are up-to-date!'
                        echo '🛑 Exiting pipeline - No action needed'
                        currentBuild.result = 'SUCCESS'
                        return
                    } else if (planExitCode == 1) {
                        error '❌ Terraform plan failed - Configuration error'
                    } else if (planExitCode == 2) {
                        echo '🟡 Resources need to be created. Proceeding...'
                    }
                }
            }
        }
        
        stage('Create Resources') {
            steps {
                echo '🚀 Creating AWS resources...'
                sh 'terraform apply -auto-approve'
                echo '✅ Resources created successfully!'
            }
        }
        
        stage('Upload State File') {
            steps {
                echo 'Uploading state file to S3...'
                sh 'aws s3 cp terraform.tfstate s3://ajitterraform/'
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}