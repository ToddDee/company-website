pipeline {
    agent any

    environment {
        // Define Docker Hub credentials
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pull code from GitHub branch Todd_David
                git branch: 'Todd_David', url: 'https://github.com/ToddDee/company-website.git'
            }
        }

        stage('Initialize') {
            steps {
                script {
                    // Retrieve Docker tool installation
                    def dockerHome = tool 'myDocker'

                    // Update PATH environment variable
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with specified tag
                    docker.build('company-website:v1.0.0')
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to DockerHub
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKER_HUB_CREDENTIALS') {
                        docker.image('company-website:v1.0.0').push()
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Deploy the image to Minikube
                    kubectl('set image deployment/your-deployment your-container=company-website:v1.0.0 --record')
                }
            }
        }
    }

    post {
        always {
            // Clean workspace after build
            cleanWs()
        }
    }
}

// Helper function to run kubectl commands
def kubectl(cmd) {
    sh "kubectl --kubeconfig=/path/to/your/kubeconfig ${cmd}"
}
