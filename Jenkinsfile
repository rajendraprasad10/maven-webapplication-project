pipeline {
    agent any 

    environment {
        WAR_PATH = "target/*.war"  // dynamically locate the WAR in workspace
        TOMCAT_URL = "http://localhost:8090/manager/text/deploy?path=/maven-web-application&update=true"
    }
    
    stages {
        stage ("Git Checkout"){
            steps {
                script  {
                notifyBuild("STARTED")
                }
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

    post {
        success {
            script {
                notifyBuild("SUCCESS")
            }
        }
        failure {
            script {
                notifyBuild("FAILURE")
            }
        }
    }


    script {
        def notifyBuild(String buildStatus = 'STARTED') {
            // build status of null means successful
            buildStatus =  buildStatus ?: 'SUCCESS'

            // Default values
            def colorName = 'RED'
            def colorCode = '#FF0000'
            def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
            def summary = "${subject} (${env.BUILD_URL})"

            // Override default values based on build status
            if (buildStatus == 'STARTED') {
                color = 'YELLOW'
                colorCode = '#FFFF00'
            } else if (buildStatus == 'SUCCESS') {
                color = 'GREEN'
                colorCode = '#00FF00'
            } else {
                color = 'RED'
                colorCode = '#FF0000'
            }

            // Send notifications
            slackSend (color: colorCode, message: summary, channel: '#all-devops')
            }
    }

}
