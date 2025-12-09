pipeline {
    agent any 

    environment {
        WAR_PATH = "target/*.war"  // dynamically locate the WAR in workspace
        TOMCAT_URL = "http://localhost:8090/manager/text/deploy?path=/maven-web-application&update=true"
    }
    
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
        
        // stage ("Push Repo"){
        //     steps {
        //         echo "push war file to repo"
        //         sh 'mvn deploy'
        //     }
        // }
        
        stage("deploy") {
            steps {
                echo "Deploying WAR file to Tomcat..."

                script {
                    // Find the WAR file dynamically
                    WAR_FILE = sh(script: "ls ${env.WAR_PATH} | head -n 1", returnStdout: true).trim()

                    if (!WAR_FILE) {
                        error "❌ WAR file not found!"
                    }

                    echo "WAR File Found: ${WAR_FILE}"
                }

                withCredentials([usernamePassword(credentialsId: 'tomcat-creds', 
                                                  usernameVariable: 'TOMCAT_USER', 
                                                  passwordVariable: 'TOMCAT_PASS')]) {
                    
                    
                    echo "Deploying WAR to Tomcat..."

                    sh """
                    curl --fail -s -o - -u "$TOMCAT_USER:$TOMCAT_PASS" \
                    "${TOMCAT_URL}" \
                    --upload-file ${WAR_FILE}
                    """
                }
            }

        }
    }
}
