pipeline{
    agent any
    stages{
        stage('Git Checkout'){
            steps{
                script{
                    git branch: 'main', url: 'https://github.com/99North/Counter-App-Using-Jen-Mvn-Sonar-Nexus-Doc.git'
                }
            }
        }
        
        stage('Unit Testing Using Maven'){
            steps{
                script{
                    sh 'mvn test'
                }
            }
        }
        
        stage('Intigration Testing Using Maven'){
            steps{
                script{
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        
        stage('Build Using Maven'){
            steps{
                script{
                    sh 'mvn clean install'
                }
            }
        }
        
        stage('Static Code Analysis Using SonarQube'){
            steps{
                script{
                    // install these plugins first sonarqube scanner, sonar gerrit, sonarqube generic coverage, quality gates
                    // now go to manage jenkins>configuration>under sonarqube choes credential as secret test
                    // now go to sonarqube>administration>security>user>click here to generate a token
                    // copy that token and paste in in <secret box> and save
                    // under pipeline chose <withSonarQUbeEnv> and chose credential
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                                sh 'mvn clean package sonar:sonar'
                            }
                }
            }
        }
        
        stage('Quality Gate Status'){
            steps{
                script{
                    // first go to sonarqube and create a webhook using jenkins url like this:: http://44.192.82.240:8080/sonarqube-webhook/
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'  
                }
            }
        }
        
        
        // click on Setting Logo >selecet Repository>create a repository>select Maven2hosted>named example DemoReleaseApp>from version policy choose Release
        // donwload plugin::  nexus artifact uploder
        // go to pipleine synatx and chose NexusUploader and here give these like this:
        // NexusUrl: 3.80.6.13:8081  click on add credential and chose ussername & passwd:: give username and password then id then give a descript sp it looks like this(admin/*****(nexus-auth))
        // open you pom.xml file and fill the required fields un pipeline syntax like group id etc and under repository give the repository name that you have created i.e DemoReleaseApp
        // under artifact gave ArtifactId from pom.xml, Type: jar,  File: target/Uber.jar
        
        // now install a plugin named Pipeline Utility Steps so it will automatically update the version of jar file when ever new version is pushed to github
        stage('Upload War File Into Nexus Repository'){
            steps{
                script{
                    // def readPomVersion = read readMavenPom file: 'pom.xml'
                    // def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT")
                    nexusArtifactUploader artifacts: [
                        [
                            artifactId: 'springboot', 
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: 'jar'
                            ]
                            ], 
                            credentialsId: 'nexus-uname-pwd', 
                            groupId: 'com.example', 
                            nexusUrl: '3.80.6.13:8081', 
                            nexusVersion: 'nexus3', 
                            protocol: 'http', 
                            repository: 'DemoReleaseApp',  //if you choose SNAPSHOT version then 1st create a repo as DemoSNAPSHOT in nexus and here give this name
                            version: '1.0.0' // "${readPomVersion.version}"
                }
            }
        }

        

        stage('Docker Image Build'){
            steps{
                script{
                    sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID debiprasad007/$JOB_NAME:v1.$BUILD_ID'
                    sh 'dcoker image tag $JOB_NAME:v1.$BUILD_ID debiprasad007/$JOB_NAME:latest'
                }
            }
        }
        
        
        
        
        
        
    }
}