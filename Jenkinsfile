@Library('shared-library') _

pipeline {
    agent any 

    environment {
        WAR_PATH = "target/*.war"  // dynamically locate the WAR in workspace
        TOMCAT_URL = "http://localhost:8090/manager/text/deploy?path=/maven-web-application&update=true"
    }
    
    stages {
        // stage ("Git Checkout"){
        //     steps {
        //         script  {
        //         notifyBuild("STARTED")
        //         }
        //         echo "git checkout"
                
        //         git branch: '${env.GIT_BRANCH}', url: '${env.GIT_URL}'
                
        //     }
        // }
        
        stage("Code validation"){
            parallel {
                stage("Code Style Check"){
                    steps {
                        echo "Check code style using checkstyle"
                        sh 'mvn clean compile'
                    }
                }
                
                stage("Code Quality Check"){
                    steps {
                        echo "Check code quality using PMD"
                        sh 'mvn pmd:pmd'
                    }
                }

                stage ("SAST"){
                    steps {
                        echo "run SAST report"
                        // sh 'mvn sonar:sonar'
                    }
                }

                stage ("Test"){
                    steps {
                        echo "Run unit testing"
                        sh 'mvn test'
                    }
                }
            }
        }
        
        
        stage ("Build"){
            steps {
                echo "run build and create war"
                sh 'mvn clean package'
            }
        }

        stage("Push Artifacts to Nexus"){
            parallel {
                stage("Push to Nexus Repo"){
                    steps {
                        echo "push war file to nexus repo"
                        sh 'mvn deploy'
                    }
                }
                

                 stage("Deploy to Tomcat Server") {
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

}

    
