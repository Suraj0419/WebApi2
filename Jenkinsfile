pipeline {
    agent any
    environment {
        dotnet = 'C:\\Program Files\\dotnet\\dotnet.exe'
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
         stage('Build Stage') {
            steps {
                bat 'C:\\ProgramData\\Jenkins\\.jenkins\\workspace\\webApi\\WebApi2.sln --configuration Release'
            }
        }
        stage("Release Stage") {
            steps {
                bat 'dotnet build %WORKSPACE%\\WebApi2.sln /p:PublishProfile=" %WORKSPACE%\\Properties\\PublishProfiles\\FolderProfile.pubxml" /p:Platform="Any CPU" /p:DeployOnBuild=true /m'
            }
        }
        stage('Deploy Stage') {
            steps {

               
                bat 'net stop "w3svc"'
                 bat 'net start "w3svc"'
                bat '"C:\\Program Files (x86)\\IIS\\Microsoft Web Deploy V3\\msdeploy.exe" -verb:sync -source:package="%WORKSPACE%\\bin\\Debug\\net8.0\\webApi2.zip" -dest:auto -setParam:"IIS Web Application Name"="Demo.Web" -skip:objectName=filePath,absolutePath=".\\\\PackagDemoeTmp\\\\Web.config$" -enableRule:DoNotDelete -allowUntrusted=true'
               
            }
        }
    }
}