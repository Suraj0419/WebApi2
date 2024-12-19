pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
    }

    parameters {
        choice(name: 'ENV', choices: ['Development', 'Production', 'UAT'], description: 'Select the environment')
    }

    environment {
        DOCKER_IMAGE = 'webapi2-image'
        DOCKER_CONTAINER_NAME_DEV = 'webapi2-dev'
        DOCKER_CONTAINER_NAME_PROD = 'webapi2-prod'
        DOCKER_CONTAINER_NAME_UAT = 'webapi2-uat'
        DOCKER_PORT_DEV = '9090'
        DOCKER_PORT_PROD = '9091'
        DOCKER_PORT_UAT = '9092'
        DB_SERVER_DEV = 'localhost'
        DB_SERVER_PROD = 'prodserver'
        DB_SERVER_UAT = 'UATserver'
        DB_NAME_DEV = 'devDB'
        DB_NAME_PROD = 'prodDB'
        DB_NAME_UAT = 'uatDB'
        DB_USER_DEV = 'devUser'
        DB_USER_PROD = 'prodUser'
        DB_USER_UAT = 'uatUser'
        DB_PASSWORD_DEV = 'dev1234'
        DB_PASSWORD_PROD = 'PROD1234'
        DB_PASSWORD_UAT = 'UAT1234'
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
                    if (params.ENV == 'Development') {
                        bat """
                        powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${DB_SERVER_DEV}' -dbName '${DB_NAME_DEV}' -dbUser '${DB_USER_DEV}' -dbPassword '${DB_PASSWORD_DEV}' }"
                        """
                    } else if (params.ENV == 'Production') {
                        bat """
                        powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${DB_SERVER_PROD}' -dbName '${DB_NAME_PROD}' -dbUser '${DB_USER_PROD}' -dbPassword '${DB_PASSWORD_PROD}' }"
                        """
                    } else if (params.ENV == 'UAT') {
                        bat """
                        powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${DB_SERVER_UAT}' -dbName '${DB_NAME_UAT}' -dbUser '${DB_USER_UAT}' -dbPassword '${DB_PASSWORD_UAT}' }"
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat """
                    docker build -t ${DOCKER_IMAGE}:${params.ENV} .
                    """
                }
            }
        }

        stage('Run and Deploy Docker Container') {
            steps {
                script {
                    if (params.ENV == 'Development') {
                        bat """
                        docker run -d --rm --name ${DOCKER_CONTAINER_NAME_DEV} -p ${DOCKER_PORT_DEV}:80 ${DOCKER_IMAGE}:${params.ENV}
                        """
                    } else if (params.ENV == 'Production') {
                        bat """
                        docker run -d --rm --name ${DOCKER_CONTAINER_NAME_PROD} -p ${DOCKER_PORT_PROD}:80 ${DOCKER_IMAGE}:${params.ENV}
                        """
                    } else if (params.ENV == 'UAT') {
                        bat """
                        docker run -d --rm --name ${DOCKER_CONTAINER_NAME_UAT} -p ${DOCKER_PORT_UAT}:80 ${DOCKER_IMAGE}:${params.ENV}
                        """
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
