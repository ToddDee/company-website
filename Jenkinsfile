pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Replace with your actual credentials ID
        DOCKER_IMAGE_NAME = 'td7165/company-website' // Replace with your Docker Hub username and image name
        DOCKER_IMAGE_TAG = 'v1.0.0' // You can use a dynamic tag, e.g., 'v1.0.${BUILD_NUMBER}'
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

        stage('Install kubectl') {
            steps {
                script {
                    sh """
                        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mv kubectl /usr/local/bin/kubectl
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with specified tag
                    docker.build('td7165/company-website:v1.0.0')
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    sh "docker push ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Deploy the image to Minikube
                    kubectl('set image deployment/your-deployment your-container=td7165/company-website:v1.0.0 --record')
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
