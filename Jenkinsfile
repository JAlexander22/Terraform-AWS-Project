pipeline {

  environment{
    PROJECT_DIR = "/app"
    REGISTRY = "jalexander22/cal_api"
    DOCKER_CREDENTIALS = "Docker_Credentials"
    DOCKER_IMAGE = ""
  }

  agent any

  options {
    skipStagesAfterUnstable()
  }

  stages {

    stage ('Cloning The Code from GIT') {
      steps {
        git 'https://github.com/JAlexander22/Terraform-AWS-Project.git'
      }
    }

    stage('Build-Image')
      steps {
        script {
          DOCKER_IMAGE = docker.build REGISTRY
        }
      }
  }
}
