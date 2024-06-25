pipeline {
    agent any
    environment {
        HOST_IP = sh(script: 'ip route show default | awk \'/default/ {print $3}\'', returnStdout: true).trim()
        DB_CREDENTIALS=credentials('db-credentials')
        CONFIG_PATH='public/config.json'
    }
    stages {
       
       stage('Clean the workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone the github repo') {
            
        }

        stage('Install Dependecies') {
            steps {
                
            }
        }
          

       

       

        stage('Deploy to Development') {
            steps {
               sh 'npm run dev-build'
               sh 'cp -r dev-build /usr/src/app'

            }
        }

         stage('Deploy to Production') {
            steps {
              
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

