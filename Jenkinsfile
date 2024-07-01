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

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['Development', 'UAT', 'Production'], description: 'Select the environment to deploy')
    }

    stages {
        stage('Clean the workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone the GitHub repo') {
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

        stage('Deploy to IIS') {
            steps {
                script {
                    def deployDir = "C:\\inetpub\\wwwroot\\WebApi2"
                    def siteName = "WebApi2"

                    // Ensure IIS site directory exists
                    bat """
                    IF NOT EXIST "${deployDir}" (
                        mkdir "${deployDir}"
                    )
                    """

                    // Copy published files to the IIS site directory
                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${deployDir}"

                    // Create IIS site if it doesn't exist
                    bat """
                    powershell -Command "
                        if (-not (Get-Website -Name ${siteName} -ErrorAction SilentlyContinue)) {
                            New-Website -Name ${siteName} -PhysicalPath ${deployDir} -Port 5200 -HostHeader localhost
                            Set-ItemProperty IIS:\\Sites\\${siteName} -name applicationPool -value 'WebApi2AppPool'
                        }
                    "
                    """

                    // Restart IIS site
                    bat "iisreset /restart"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment succeeded!'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}
