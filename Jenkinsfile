pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
    }

     environment {
        DB_SERVER = '192.168.1.101'
        DB_NAME = 'CTraveller'
        DB_USER = 'sa'
        DB_PASSWORD = 'dts@123'

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

        stage('Update Config') {
            steps {
                echo 'Updating configuration...'
               script {
  def appSettingsPath = 'appsettings.json'
  bat """
  powershell -Command "(Get-Content ${appSettingsPath}) -replace '\\\$\\{DB_SERVER\\}', '${env.DB_SERVER}' -replace '\\\$\\{DB_NAME\\}', '${env.DB_NAME}' -replace '\\\$\\{DB_USER\\}', '${env.DB_USER}' -replace '\\\$\\{DB_PASSWORD\\}', '${env.DB_PASSWORD}' | Set-Content ${appSettingsPath}"
  """
}

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
        success {
            
            echo 'Build and server startup succeeded!'
            
        }
        failure {
            echo 'Build or server startup failed.'
        }
    }
}
