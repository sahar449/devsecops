pipeline {
    agent any
    environment {
        snyk-token = credentials('snyk-token')
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
                withCredentials([string(credentialsId: 'snyk-token', variable: 'snyk-token')]) {
                    sh 'snyk test --severity-threshold=high'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t hello-world .'
            }
        }
    }
}