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
               // Read, parse, modify, and write JSON in one block to avoid serialization issues
                    def jsonContent = readFile(file: appSettingsPath)
                    def json = new groovy.json.JsonSlurper().parseText(jsonContent) as Map

                    // Add or update the connection string
                    json.ConnectionStrings = json.ConnectionStrings ?: [:]
                    json.ConnectionStrings.DefaultConnection = "Server=${env.DB_SERVER};Database=${env.DB_NAME};User Id=${env.DB_USER};Password=${env.DB_PASSWORD};"

                    // Convert the JSON object back to a string
                    def jsonOutput = groovy.json.JsonOutput.prettyPrint(groovy.json.JsonOutput.toJson(json))

                    // Write the updated JSON back to the file
                    writeFile(file: appSettingsPath, text: jsonOutput)
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
