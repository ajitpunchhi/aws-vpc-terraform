pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TERRAFORM_PLAN_FILE = 'tfplan'
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
                echo 'Downloading existing state file from S3...'
                script {
                    try {
                        sh '''
                            if aws s3 ls s3://ajitterraform/terraform.tfstate; then
                                echo "Downloading existing state file..."
                                aws s3 cp s3://ajitterraform/terraform.tfstate .
                                echo "State file downloaded successfully"
                            else
                                echo "No existing state file found. This will be a fresh deployment."
                            fi
                        '''
                    } catch (Exception e) {
                        echo "No existing state file or S3 access issue. Proceeding with fresh state."
                    }
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh '''
                    terraform --version
                    terraform init -input=false
                '''
            }
        }
        
        stage('Terraform Plan') {
            steps {
                echo 'Creating Terraform execution plan...'
                sh '''
                    terraform plan -out=${TERRAFORM_PLAN_FILE} -input=false -detailed-exitcode
                '''
                script {
                    // Capture the exit code from terraform plan
                    def planExitCode = sh(
                        script: 'terraform plan -out=${TERRAFORM_PLAN_FILE} -input=false -detailed-exitcode',
                        returnStatus: true
                    )
                    
                    // Store the plan result for later stages
                    env.PLAN_EXIT_CODE = planExitCode.toString()
                    
                    echo "Terraform plan exit code: ${planExitCode}"
                    echo "Exit code 0: No changes needed"
                    echo "Exit code 1: Error occurred"  
                    echo "Exit code 2: Changes needed"
                }
            }
        }
        
        stage('Check Resource Status') {
            steps {
                script {
                    def planExitCode = env.PLAN_EXIT_CODE as Integer
                    
                    switch(planExitCode) {
                        case 0:
                            echo "🟢 SUCCESS: All resources are already created and up-to-date!"
                            echo "ℹ️  No changes required. Your infrastructure matches the desired state."
                            env.SKIP_APPLY = "true"
                            break
                            
                        case 1:
                            error "❌ ERROR: Terraform plan failed. Please check the configuration."
                            break
                            
                        case 2:
                            echo "🟡 CHANGES DETECTED: Resources need to be created or updated."
                            echo "📋 Showing what will be created/modified:"
                            sh 'terraform show -no-color ${TERRAFORM_PLAN_FILE}'
                            env.SKIP_APPLY = "false"
                            break
                            
                        default:
                            error "❌ UNEXPECTED: Unknown terraform plan exit code: ${planExitCode}"
                    }
                }
            }
        }
        
        stage('Resource Summary') {
            steps {
                script {
                    echo "📊 RESOURCE SUMMARY:"
                    sh '''
                        echo "Current state analysis:"
                        terraform show -json | jq -r '.values.root_module.resources[]?.address // empty' | sort || echo "No existing resources found"
                        
                        echo ""
                        echo "Plan summary:"
                        terraform show -json ${TERRAFORM_PLAN_FILE} | jq -r '
                            .resource_changes[]? | 
                            "\\(.change.actions[0] | ascii_upcase): \\(.address) (\\(.type))"
                        ' || echo "No changes planned"
                    '''
                }
            }
        }
        
        stage('Apply Changes') {
            when {
                expression { env.SKIP_APPLY == "false" }
            }
            steps {
                echo '🚀 Applying Terraform changes...'
                
                script {
                    // Optional: Add confirmation for production
                    // input message: 'Proceed with creating/updating resources?', ok: 'Yes, apply changes'
                    
                    echo "Creating/updating AWS resources..."
                }
                
                sh '''
                    terraform apply ${TERRAFORM_PLAN_FILE}
                    echo "✅ Terraform apply completed successfully!"
                '''
                
                echo "📋 Updated resource list:"
                sh '''
                    terraform output || echo "No outputs defined"
                    echo ""
                    echo "Resources now managed by Terraform:"
                    terraform show -json | jq -r '.values.root_module.resources[]?.address // empty' | sort
                '''
            }
        }
        
        stage('Skip Apply') {
            when {
                expression { env.SKIP_APPLY == "true" }
            }
            steps {
                echo "⏭️  SKIPPING APPLY: Resources already exist and are up-to-date"
                echo "🔍 Current resources:"
                sh '''
                    terraform show -json | jq -r '.values.root_module.resources[]?.address // empty' | sort || echo "No resources in state"
                '''
            }
        }
        
        stage('Upload State File') {
            steps {
                echo 'Uploading updated state file to S3...'
                sh '''
                    # Upload current state
                    aws s3 cp terraform.tfstate s3://ajitterraform/terraform.tfstate
                    
                    # Create backup with timestamp
                    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
                    aws s3 cp terraform.tfstate s3://ajitterraform/backups/terraform.tfstate-${TIMESTAMP}
                    
                    echo "State file uploaded and backed up successfully"
                '''
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up temporary files...'
            sh '''
                rm -f ${TERRAFORM_PLAN_FILE}
                rm -f .terraform.lock.hcl
            '''
            
            script {
                if (env.SKIP_APPLY == "true") {
                    echo "🎯 FINAL STATUS: No action needed - resources already exist"
                } else {
                    echo "🎯 FINAL STATUS: Resources created/updated successfully"
                }
            }
            
            cleanWs()
        }
        
        success {
            script {
                if (env.SKIP_APPLY == "true") {
                    echo '✅ COMPLETED: Infrastructure is already up-to-date!'
                } else {
                    echo '✅ COMPLETED: Infrastructure created/updated successfully!'
                }
            }
        }
        
        failure {
            echo '❌ FAILED: Infrastructure deployment failed!'
            
            script {
                try {
                    sh 'aws s3 cp terraform.tfstate s3://ajitterraform/failed-states/terraform.tfstate-${BUILD_NUMBER}'
                    echo "Failed state file backed up for troubleshooting"
                } catch (Exception e) {
                    echo "Could not backup failed state"
                }
            }
        }
    }
}