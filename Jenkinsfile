pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Jenkins ID for Docker Hub credentials
        DOCKER_IMAGE = 'td7165/company-website:v0.0.1'
        GIT_REPO = 'https://github.com/ToddDee/company-website.git'
        GIT_BRANCH = 'Todd_David'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Build') {
            steps {
                // Build the Docker image
                script {
                    def customImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Push the Docker image to Docker Hub
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        def customImage = docker.image("${DOCKER_IMAGE}")
                        customImage.push()
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                // Set up kubectl to use Minikube context
                sh 'kubectl config use-context minikube'

                // Pull the Docker image on Minikube and deploy it
                sh """
                kubectl run company-website --image=${DOCKER_IMAGE} --port=80 --restart=Never
                kubectl expose pod company-website --type=NodePort --port=80
                """
            }
        }
    }

    post {
        success {
            echo 'Deployment to Minikube successful!'
        }
        failure {
            echo 'Deployment to Minikube failed.'
        }
    }
}
