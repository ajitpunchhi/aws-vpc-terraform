pipeline{
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'ap-south-1'
        SONAR_TOKEN = credentials('SONAR_TOKEN')
        SONAR_HOST_URL = 'http://15.206.153.35:9000'
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
                        echo '🛑 No action needed - Exiting pipeline'
                        currentBuild.result = 'SUCCESS'
                        currentBuild.description = 'Resources already exist - No changes needed'
                        return
                    } else if (planExitCode == 1) {
                        error '❌ Terraform plan failed - Configuration error'
                    } else if (planExitCode == 2) {
                        echo '🟡 Resources need to be created'
                        echo '📋 Showing what will be created:'
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                withSonarQubeEnv('SonarQube Scanner') {
                    sh '/bin/sonar-scanner'
                }
            }
        }
        stage('Quality Gate Check') {
            steps {
                echo 'Checking SonarQube Quality Gate...'
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('terraform Plan') {
            steps {
                echo 'Running Terraform plan...'
                sh 'terraform plan -out=tfplan'
            }
        }   
        stage('Create Resources') {
            steps {
                echo '⏳ Waiting for approval to create AWS resources...'
                script {
                    try {
                        timeout(time: 10, unit: 'MINUTES') {
                            input message: 'Do you want to create the AWS resources?', ok: 'Create Resources'
                        }
                    } catch (e) {
                        echo '❌ User aborted the pipeline - Exiting...'
                        currentBuild.result = 'ABORTED'
                        return
                    }
                }
                echo 'Creating AWS resources...'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Upload State File') {
            steps {
                echo 'Uploading state file to S3...'
                sh '''
                    aws s3 cp terraform.tfstate s3://ajitterraform/terraform.tfstate
                '''
            }
        }

    
}
    }