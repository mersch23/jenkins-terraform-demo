pipeline {
    agent { label 'linux' }

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action')
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
    }

        options {
        ansiColor('xterm')
    }

    triggers {
        pollSCM('H/2 * * * *')
    }

    stages {
        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh "terraform init -input=false -backend-config=backend/${params.ENVIRONMENT}.hcl"
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
                sh 'terraform fmt -check -recursive || true'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        terraform plan \
                            -input=false \
                            -var-file=environments/${params.ENVIRONMENT}.tfvars \
                            -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        terraform destroy \
                            -input=false \
                            -var-file=environments/${params.ENVIRONMENT}.tfvars \
                            -auto-approve
                    """
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
        failure {
            echo "Terraform ${params.ACTION} FAILED for ${params.ENVIRONMENT}"
        }
        success {
            echo "Terraform ${params.ACTION} succeeded for ${params.ENVIRONMENT}"
        }
    }
}