# maven-web-app-project-kk-funda

Hello Rajendra

This commit is for jenkins pipeline gitweb hook test commit 

https://dev.to/prodevopsguytech/cicd-devops-pipeline-project-deployment-of-java-application-on-kubernetes-4fi2


### CICD pipeline approach with normal flow 

pipeline states 
add shared library 
git checkout 
||
Code Compile
||
Unit Testing 
||
SAST
||
Snyk
||
Dependency Check 
||
Build 
|| 
Docker Image build 
||
Docker Image Scanning
||
Deployemnt Approal for UAT and Production envs 
||
Push to REgistry 
||
Deploy in TOMCAT or Docker in target machine 
==
post actions 
sucess 
send slack notification/mail
==
failled
    send slack notification/ mail
==
always 

