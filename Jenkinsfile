pipeline {
    agent any
    tools {
        // Assuming you are using a custom tool installer for Snyk
        snyk 'snyk' // Replace with the actual name you have configured for the Snyk installation
    }
    environment {
        SNYK_TOKEN = credentials('snyk-token') // Your Snyk API token
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Snyk Scan') {
            steps {                
                // Run the Snyk scan with the provided token
                sh 'snyk-linux test --severity-threshold=critical --all-projects --token=$SNYK_TOKEN'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Check if the Docker image exists and remove it if it does
                    def imageName = 'hello-world'
                    def imageExists = sh(script: "docker images -q ${imageName}", returnStdout: true).trim()
                    if (imageExists) {
                        sh "docker rmi -f ${imageName}"
                    }
                }
                // Pass the SNYK_TOKEN as a build argument
                sh 'docker build --build-arg SNYK_TOKEN=$SNYK_TOKEN -t hello-world .'
            }
        }
        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 6000:80 hello-world'
            }
            }
        }
    }
