pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
    }

    parameters {
        choice(name: 'ENV', choices: ['Development', 'Production', 'UAT'], description: 'Select the environment')
    }

    stages {
        stage('Set Environment Variables') {
            steps {
                script {
                    def envVars = []

                    if (params.ENV == 'Development') {
                        envVars = [
                            'DB_SERVER=localhost',
                            'DB_NAME=CTraveller_Dev',
                            'DB_USER=sa',
                            'DB_PASSWORD=dev_password',
                            'DEPLOY_DIR=C:\\Users\\dccpl\\source\\dev'
                        ]
                    } else if (params.ENV == 'Production') {
                        envVars = [
                            'DB_SERVER=prod_server',
                            'DB_NAME=CTraveller_Prod',
                            'DB_USER=sa',
                            'DB_PASSWORD=prod_password',
                            'DEPLOY_DIR=C:\\Users\\dccpl\\source\\prod'
                        ]
                    } else if (params.ENV == 'UAT') {
                        envVars = [
                            'DB_SERVER=uat_server',
                            'DB_NAME=CTraveller_UAT',
                            'DB_USER=sa',
                            'DB_PASSWORD=uat_password',
                            'DEPLOY_DIR=C:\\Users\\dccpl\\source\\uat'
                        ]
                    }

                    withEnv(envVars) {
                        echo "Environment: ${params.ENV}"
                        echo "DB_SERVER: ${env.DB_SERVER}"
                        echo "DB_NAME: ${env.DB_NAME}"
                        echo "DB_USER: ${env.DB_USER}"
                        echo "DB_PASSWORD: ${env.DB_PASSWORD}"
                        echo "DEPLOY_DIR: ${env.DEPLOY_DIR}"

                        // Proceed with other stages
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
                                bat """
                                powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${env.DB_SERVER}' -dbName '${env.DB_NAME}' -dbUser '${env.DB_USER}' -dbPassword '${env.DB_PASSWORD}' }"
                                """
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
                                    bat "echo Deploy Directory: ${env.DEPLOY_DIR}"
                                    bat "echo Database Server: ${env.DB_SERVER}"
                                    bat "echo Database Name: ${env.DB_NAME}"
                                    bat "echo Database User: ${env.DB_USER}"
                                    bat "echo Database Password: ${env.DB_PASSWORD}"

                                    // Ensure IIS site directory exists
                                    bat """
                                    IF NOT EXIST "${env.DEPLOY_DIR}" (
                                        mkdir "${env.DEPLOY_DIR}"
                                    )
                                    """

                                    // Copy published files to the IIS site directory
                                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${env.DEPLOY_DIR}"
                                }
                            }
                        }
                    }
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
