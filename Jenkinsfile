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
                    echo "Environment: ${params.ENV}"
                    echo "DB_SERVER: ${env.DB_SERVER}"
                    echo "DB_NAME: ${env.DB_NAME}"
                    echo "DB_USER: ${env.DB_USER}"
                    echo "DB_PASSWORD: ${env.DB_PASSWORD}"
                    echo "DEPLOY_DIR: ${env.DEPLOY_DIR}"
                    echo "SITE_NAME: ${env.SITE_NAME}"
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
                    bat """
                    powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${env.DB_SERVER}' -dbName '${env.DB_NAME}' -dbUser '${env.DB_USER}' -dbPassword '${env.DB_PASSWORD}' }"
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
                    def deployDir = env.DEPLOY_DIR
                    def dbServer = env.DB_SERVER
                    def dbName = env.DB_NAME
                    def dbUser = env.DB_USER
                    def dbPassword = env.DB_PASSWORD

                    bat "echo Deploy Directory: %deployDir%"
                    bat "echo Database Server: ${dbServer}"
                    bat "echo Database Name: ${dbName}"
                    bat "echo Database User: ${dbUser}"
                    bat "echo Database Password: ${dbPassword}"

                    // Ensure IIS site directory exists
                    bat """
                    IF NOT EXIST "${deployDir}" (
                        mkdir "${deployDir}"
                    )
                    """

                    // Copy published files to the IIS site directory
                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${deployDir}"
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
