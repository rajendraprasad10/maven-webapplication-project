pipeline {
    agent any 
    
    stages {
        stage ("Git Checkout"){
            steps {
                echo "git checkout"
                git branch: 'dev', url: 'https://github.com/rajendraprasad10/maven-webapplication-project.git'
            }
        }
        
        stage ("Code Compile"){
            steps {
                echo "Code compilation check"
                sh 'mvn clean compile'
            }
        }
        
        stage ("Test"){
            steps {
                echo "Run unit testing"
                sh 'mvn test'
            }
        }
        
        stage ("SAST"){
            steps {
                echo "run SAST report"
                // sh 'mvn sonar:sonar'
            }
        }
        
        stage ("Build"){
            steps {
                echo "run build and create war"
                sh 'mvn clean package'
            }
        }
        
        stage ("Push Repo"){
            steps {
                echo "push war file to repo"
                sh 'mvn deploy'
            }
        }
        
        stage("deploy") {
            steps {
                echo "Deploying WAR file to Tomcat..."

                sh """
                curl --fail -s -o - -u example:example \
                "http://localhost:8090/manager/text/deploy?path=/maven-web-application&update=true" \
                --upload-file /var/lib/jenkins/workspace/scripted-pipeline/target/maven-web-application.war
                """
            }

        }
    }
}
