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
        
        stage('Approval Required') {
            steps {
                script {
                    echo '⏳ Waiting for approval to create AWS resources...'
                    
                    try {
                        timeout(time: 10, unit: 'MINUTES') {
                            input message: '🚨 Do you want to create the AWS resources shown above?',
                                  ok: 'Yes, Create Resources',
                                  submitterParameter: 'APPROVER'
                        }
                        
                        echo "✅ Approved by: ${env.APPROVER}"
                        
                    } catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException e) {
                        echo '❌ Pipeline aborted - No approval received within 10 minutes'
                        currentBuild.result = 'ABORTED'
                        currentBuild.description = 'Aborted - No approval received'
                        error 'Pipeline aborted due to timeout or user rejection'
                    }
                }
            }
        }
        
        stage('Create Resources') {
            steps {
                echo '🚀 Creating AWS resources...'
                echo "Creating resources approved by: ${env.APPROVER}"
                
                sh 'terraform apply -auto-approve'
                
                echo '✅ Resources created successfully!'
                echo '📋 Showing created resources:'
                sh 'terraform output || echo "No outputs defined"'
            }
        }
        
        stage('Upload State File') {
            steps {
                echo 'Uploading state file to S3...'
                sh '''
                    aws s3 cp terraform.tfstate s3://ajitterraform/terraform.tfstate
                    
                    # Create backup with timestamp
                    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
                    aws s3 cp terraform.tfstate s3://ajitterraform/backups/terraform.tfstate-${TIMESTAMP}
                    
                    echo "State file uploaded and backed up"
                '''
            }
        }
    }
    
    post {
        success {
            script {
                if (currentBuild.description?.contains('already exist')) {
                    echo '✅ Completed: Resources already existed - No action taken'
                } else {
                    echo '✅ Completed: Resources created successfully!'
                }
            }
        }
        
        failure {
            echo '❌ Pipeline failed!'
        }
        
        aborted {
            echo '🛑 Pipeline was aborted - No resources were created'
        }
        always {
            echo '🔚 Pipeline execution completed'
        }
    }
}