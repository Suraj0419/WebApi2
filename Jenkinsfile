pipeline {
    agent any

    tools {
        dotnetsdk 'dotnet-8.0'
    }

    parameters {
        choice(name: 'ENV', choices: ['Development', 'Production', 'UAT'], description: 'Select the environment')
    }

    environment {
        DB_SERVER_DEV = 'localhost'
        DB_SERVER_PROD='prodserver'
         DB_SERVER_UAT='UATserver'
        DB_NAME_DEV = 'devDB'
         DB_NAME_PROD = 'prodDB'
          DB_NAME_UAT = 'uatDB'
        DB_USER_DEV = 'devUser'
        DB_USER_PROD = 'devProd'
        DB_USER_UAT = 'devUser'
        DB_PASSWORD_DEV = 'dev1234'
         DB_PASSWORD_PROD = 'PROD1234'
          DB_PASSWORD_UAT = 'UAT1234'
        DEPLOY_DIR_DEV = 'dev'
         DEPLOY_DIR_PROD = 'prod'
          DEPLOY_DIR_UAT = 'uat'
        
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
                    powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${DB_SERVER_DEV}' -dbName '${DB_NAME_DEV}' -dbUser '${DB_USER_DEV}' -dbPassword '${env.DB_PASSWORD_DEV}' }"
                    """
                      
                    } else if (params.ENV == 'Production') {'

                     bat """
                    powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${env.DB_SERVER_PROD}' -dbName '${env.DB_NAME_PROD}' -dbUser '${env.DB_USER_PROD}' -dbPassword '${env.DB_PASSWORD_PROD}' }"
                    """
                       
                    } else if (params.ENV == 'UAT') {
                        bat """
                    powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\\update-config.ps1 -appSettingsPath 'appsettings.json' -dbServer '${env.DB_SERVER_UAT}' -dbName '${env.DB_NAME_UAT}' -dbUser '${env.DB_USER_UAT}' -dbPassword '${env.DB_PASSWORD_UAT}' }"
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

                    if (params.ENV == 'Development') {

                   bat """
                    IF NOT EXIST "${DEPLOY_DIR_DEV}" (
                        mkdir "${deployDir}"
                    )
                    """

                    // Copy published files to the IIS site directory
                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${DEPLOY_DIR_DEV}"
                      
                    } else if (params.ENV == 'Production') {

                   bat """
                    IF NOT EXIST "${DEPLOY_DIR_PROD}" (
                        mkdir "${DEPLOY_DIR_PROD}"
                    )
                    """

                    // Copy published files to the IIS site directory
                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${DEPLOY_DIR_PROD}"
                       
                    } else if (params.ENV == 'UAT') {
                       bat """
                    IF NOT EXIST "${deployDir}" (
                        mkdir "${DEPLOY_DIR_UAT}"
                    )
                    """

                    // Copy published files to the IIS site directory
                    bat "xcopy /E /I /Y %WORKSPACE%\\publish ${DEPLOY_DIR_UAT}"
                   
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