pipeline {
    agent any
    
    tools {
        dotnet 'dotNet'
    }
    stages {
       
       stage('Clean the workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone the github repo') {
        steps{
          git 'https://github.com/Suraj0419/WebApi2.git'
        }
           
        }

        stage('Build') {
            steps {
                sh 'dotnet build --configuration Release'
            }
        }
        stage('Publish') {
             steps {
                sh 'dotnet publish --configuration Release --output ./publish'
            }
        }
       
    }

     post {
        success {
            
            echo 'Build and server startup succeeded!'
            
        }
        failure {
            echo 'Build or server startup failed.'
        }
    }
}

