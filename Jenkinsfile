pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
    }

    parameters {
        choice(name: 'ENV', choices: ['Development', 'Production', 'UAT'], description: 'Select the environment')
    }

    environment {
        DB_SERVER = ''
        DB_NAME = ''
        DB_USER = ''
        DB_PASSWORD = ''
        DEPLOY_DIR = ''
        SITE_NAME = ''
    }

    stages {
        stage('Set Environment Variables') {
            steps {
                script {
                    if (params.ENV == 'Development') {
                        env.DB_SERVER = 'localhost'
                        env.DB_NAME = 'CTraveller_Dev'
                        env.DB_USER = 'sa'
                        env.DB_PASSWORD = 'dev_password'
                        env.DEPLOY_DIR = "C:\\Users\\dccpl\\source\\dev"
                    } else if (params.ENV == 'Production') {
                        env.DB_SERVER = 'prod_server'
                        env.DB_NAME = 'CTraveller_Prod'
                        env.DB_USER = 'sa'
                        env.DB_PASSWORD = 'prod_password'
                        env.DEPLOY_DIR = "C:\\Users\\dccpl\\source\\prod"
                    } else if (params.ENV == 'UAT') {
                        env.DB_SERVER = 'uat_server'
                        env.DB_NAME = 'CTraveller_UAT'
                        env.DB_USER = 'sa'
                        env.DB_PASSWORD = 'uat_password'
                        env.DEPLOY_DIR =  "C:\\Users\\dccpl\\source\\uat"
                       
                    }
                }
            }
        }

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
                    powershell -NoProfile -ExecutionPolicy Bypass -File update-config.ps1 -appSettingsPath appsettings.json -dbServer %DB_SERVER% -dbName %DB_NAME% -dbUser %DB_USER% -dbPassword %DB_PASSWORD%'
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
                   bat "echo %DEPLOY_DIR%"
                   bat "echo %DB_SERVER%"

                    // Ensure IIS site directory exists
                    bat """
                    IF NOT EXIST %DEPLOY_DIR% (
                        mkdir %DEPLOY_DIR%
                    )
                    """

                    bat "xcopy /E /I /Y %WORKSPACE%\\publish %DEPLOY_DIR%"
                    
                   
                   
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
