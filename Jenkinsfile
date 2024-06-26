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
               def appSettingsPath = 'path/to/your/appsettings.json'
                    def jsonContent = readFile(file: appSettingsPath)
                    def json = new groovy.json.JsonSlurper().parseText(jsonContent)

                    // Convert LazyMap to HashMap
                    json = json.collectEntries { k, v -> [(k): v instanceof Map ? v.collectEntries { k2, v2 -> [(k2): v2] } : v] }

                    // Adding new key-value pairs
                    if (!json.ConnectionStrings) {
                        json.ConnectionStrings = [:]
                    }
                    json.ConnectionStrings.DefaultConnection = "Server=${env.DB_SERVER};Database=${env.DB_NAME};User Id=${env.DB_USER};Password=${env.DB_PASSWORD};"

                    def jsonOutput = groovy.json.JsonOutput.toJson(json)
                    writeFile(file: appSettingsPath, text: groovy.json.JsonOutput.prettyPrint(jsonOutput))
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
