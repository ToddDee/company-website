pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Replace with your actual credentials ID
        DOCKER_IMAGE_NAME = 'td7165/company-website' // Replace with your Docker Hub username and image name
        DOCKER_IMAGE_TAG = 'v1.0.0' // You can use a dynamic tag, e.g., 'v1.0.${BUILD_NUMBER}'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone your Git repository
                git 'https://github.com/ToddDee/company-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG} ."
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
    }

    post {
        always {
            // Clean up the local Docker environment
            script {
                sh "docker rmi ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}"
            }
        }
        success {
            echo 'Docker image successfully pushed to Docker Hub'
        }
        failure {
            echo 'Failed to push Docker image to Docker Hub'
        }
    }
}
