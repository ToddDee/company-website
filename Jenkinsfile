pipeline {

  environment {
    dockerimagename = "td7165/company-website"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Checkout Source') {
        steps {
            git branch: 'Todd_David', url: 'https://github.com/ToddDee/company-website.git'
        }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'docker-hub-credentials'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("v0.0.2")
          }
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deploymentservice.yaml", kubeconfigId: "kubernetes")
        }
      }
    }

  }

}
