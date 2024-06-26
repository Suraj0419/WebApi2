pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
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
                bat 'dotnet restore'
                bat 'dotnet build --configuration Release'
            }
        }
        stage('Publish') {
            steps {
                // Publish the project
                bat 'dotnet publish --configuration Release --output %WORKSPACE%\\publish'
            }
        }
        
    }

    post {
        always {
            cleanWs()
        }
    }
}
