pipeline {
    agent any

    tools {
        maven 'mvn 3.9.9' // Ensure Maven is installed in Jenkins
    }

    environment {
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'latest'
    }

    stages {

        stage('Build') {
            steps {
                script {
                    // Build the project using Maven
                    sh 'mvn clean install'
                }
            }
        }

        stage('Snyk Scan - Code') {
            steps {
                script {
                    // Run Snyk scan for vulnerabilities in the code
                    withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                        sh 'mvn snyk:test -fn'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Deploy to Staging Environment') {
            steps {
                script {
                    // Deploy to staging environment
                    sh "docker run -d -p 2:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Integration Tests') {
            steps {
                script {
                    // Run integration tests on the deployed container
                    sh '''
                    curl --fail http://localhost:2/|| exit 1
                    '''
                }
            }
        }
    }
}
