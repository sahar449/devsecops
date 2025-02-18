pipeline {
    agent any

    tools {
        maven 'mvn 3.9.9' // Ensure Maven is installed in Jenkins
    }

    environment {
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'latest'
        SNYK_TOKEN = credentials('snyk-token') // Assuming the Snyk token is stored as a Jenkins secret
    }

    stages {
        stage('Snyk Security Scan') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                        sh 'mvn snyk:test -DfailOnError=false'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Run Integration Tests') {
            steps {
                script {
                    // Run your integration tests here
                    sh 'mvn test'
                }
            }
        }

        stage('Deploy to Stage') {
            steps {
                script {
                    // Deploy the docker image to staging using Docker CLI
                    sh 'docker tag ${IMAGE_NAME}:${IMAGE_TAG} my-registry/${IMAGE_NAME}:${IMAGE_TAG}'
                    sh 'docker push my-registry/${IMAGE_NAME}:${IMAGE_TAG}'
                }
            }
        }
    }
}
