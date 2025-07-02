pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SONAR_TOKEN = credentials('SONAR_TOKEN')
        SONAR_HOST_URL = 'http://15.206.153.35:9000'  // Change to your SonarQube URL
    }
    
    tools {
        // Add SonarQube Scanner tool (configure in Jenkins Global Tools)
        'org.sonarsource.scanner.jenkins.tool.SonarQubeScanner' 'SonarQubeScanner'
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
                        echo '⏭️ Skipping SonarQube scan and resource creation'
                        currentBuild.result = 'SUCCESS'
                        currentBuild.description = 'Resources already exist - Pipeline exited early'
                        return
                    } else if (planExitCode == 1) {
                        error '❌ Terraform plan failed - Configuration error'
                    } else if (planExitCode == 2) {
                        echo '🟡 Resources need to be created. Proceeding with quality checks...'
                        env.PROCEED_WITH_CREATION = 'true'
                    }
                }
            }
        }
        
        stage('SonarQube Analysis') {
            when {
                environment name: 'PROCEED_WITH_CREATION', value: 'true'
            }
            steps {
                echo '🔍 Running SonarQube code quality analysis...'
                
                script {
                    withSonarQubeEnv('SonarQube') {  // 'SonarQube' should match your Jenkins SonarQube configuration name
                        sh '''
                            sonar-scanner \
                              -Dsonar.projectKey=terraform-aws-project \
                              -Dsonar.projectName="Terraform AWS Infrastructure" \
                              -Dsonar.projectVersion=1.0 \
                              -Dsonar.sources=. \
                              -Dsonar.inclusions="**/*.tf,**/*.tfvars" \
                              -Dsonar.exclusions="**/.terraform/**,**/terraform.tfstate*" \
                              -Dsonar.host.url=${SONAR_HOST_URL} \
                              -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
                
                echo '✅ SonarQube analysis completed'
            }
        }
        
        stage('Quality Gate') {
            when {
                environment name: 'PROCEED_WITH_CREATION', value: 'true'
            }
            steps {
                echo '⏳ Waiting for SonarQube Quality Gate result...'
                
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        
                        if (qg.status != 'OK') {
                            echo "❌ Quality Gate failed: ${qg.status}"
                            error "Pipeline failed due to quality gate failure: ${qg.status}"
                        } else {
                            echo '✅ Quality Gate passed! Proceeding with resource creation.'
                        }
                    }
                }
            }
        }
        
        stage('Show Terraform Plan') {
            when {
                environment name: 'PROCEED_WITH_CREATION', value: 'true'
            }
            steps {
                echo '📋 Showing what resources will be created:'
                sh 'terraform plan'
            }
        }
        
        stage('Create Resources') {
            when {
                environment name: 'PROCEED_WITH_CREATION', value: 'true'
            }
            steps {
                echo '🚀 Creating AWS resources...'
                echo '✅ Quality checks passed - Proceeding with deployment'
                
                sh 'terraform apply -auto-approve'
                
                echo '✅ Resources created successfully!'
                echo '📋 Showing created resources:'
                sh 'terraform output || echo "No outputs defined"'
            }
        }
        
        stage('Upload State File') {
            when {
                environment name: 'PROCEED_WITH_CREATION', value: 'true'
            }
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
                    echo '📊 SonarQube scan was skipped (not needed)'
                } else {
                    echo '✅ Completed: Resources created successfully after quality checks!'
                    echo '📊 SonarQube analysis passed'
                }
            }
        }
        
        failure {
            script {
                if (env.PROCEED_WITH_CREATION == 'true') {
                    echo '❌ Pipeline failed - Could be due to:'
                    echo '   • SonarQube quality gate failure'
                    echo '   • Terraform apply failure'
                    echo '   • Infrastructure deployment issue'
                } else {
                    echo '❌ Pipeline failed during initial checks'
                }
            }
        }
        
        always {
            // Archive SonarQube reports if they exist
            script {
                try {
                    archiveArtifacts artifacts: '.scannerwork/report-task.txt', allowEmptyArchive: true
                } catch (Exception e) {
                    echo "No SonarQube artifacts to archive"
                }
            }
            echo '🔚 Pipeline execution completed with sonarqube scanning'
        }
    }
}