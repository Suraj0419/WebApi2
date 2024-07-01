pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
    }

    environment {
        DB_SERVER = 'localhost'
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
            steps {
                git 'https://github.com/Suraj0419/WebApi2.git'
            }
        }

        stage('Update Config') {
            steps {
                echo 'Updating configuration...'
                script {
                    def appSettingsPath = 'appsettings.json'
                    bat """
                    powershell -NoProfile -ExecutionPolicy Bypass -File update-config.ps1 -appSettingsPath appsettings.json -dbServer '${env.DB_SERVER}' -dbName '${env.DB_NAME}' -dbUser '${env.DB_USER}' -dbPassword '${env.DB_PASSWORD}'
                    """
                }
            }
        }

        stage('Build') {
            steps {
                bat 'dotnet build --configuration Release'
            }
        }

        stage('Publish') {
            steps {
                bat 'dotnet publish --configuration Release --output %WORKSPACE%\\publish'
            }
        }

        stage('Deploy Locally') {
            steps {
                script {
                    def deployDir = "C:\\Users\\dccpl\\source\\repos\\WebApi2" // Change this to your local deployment directory

                    // Clean the deploy directory
                    bat "IF EXIST ${deployDir} (rmdir /S /Q ${deployDir})"
                    bat "mkdir ${deployDir}"

                    // Copy published files to the deploy directory
                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${deployDir}"

                    // Stop any existing instance of the application
                    bat "FOR /F \"tokens=5\" %P IN ('netstat -ano ^| findstr :5000') DO taskkill /F /PID %P"

                    // Start the application
                    bat """
                    cd ${deployDir}
                    start /B dotnet MyWebApi.dll
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Build and local deployment succeeded!'
        }
        failure {
            echo 'Build or local deployment failed.'
        }
    }
}
