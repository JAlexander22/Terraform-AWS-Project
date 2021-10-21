pipeline {

  environment{
    PROJECT_DIR = "/app"
    REGISTRY = "jalexander22/cal_api" + ":" + "$BUILD_NUMBER"
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
        git branch: 'main',
        url: 'https://github.com/JAlexander22/Terraform-AWS-Project.git'
      }
    }

    stage('Build-Image'){
      steps {
        script {
          DOCKER_IMAGE = docker.build REGISTRY
        }
      }
    }

    // stage('Testing the Code'){
    //   steps {
    //     script {
    //       sh '''docker run -v $PWD/reports:/reports --workdir $PROJECT_DIR $REGISTRY pytest -v --junitxml=/reports/results.xml'''
    //     }
    //   }
    //   post {
    //     always {
    //       junit testResults: '**/reports/*.xml'
    //     }
    //   }
    // }
    stage('Deploy To Docker Hub'){
      steps{
        script{
          docker.withRegistry('', DOCKER_CREDENTIALS){
            DOCKER_IMAGE.push()
          }
        }
      }
    }

    stage('Removing the Docker Image'){
      steps{
        sh "docker rmi $REGISTRY"
      }
    }
  }


}
