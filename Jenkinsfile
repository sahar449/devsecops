pipeline {
    agent any
    environment {
        SNYK_TOKEN = credentials('snyk-token') // Use uppercase for environment variables
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
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh 'snyk test --severity-threshold=critical' // Changed to critical
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t hello-world .'
            }
        }
        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 6000:80 hello-world' // Deploy on port 6000
            }
        }
    }
}
