pipeline {
    agent any

    tools {
        maven 'mvn 3.9.9' // Ensure Maven is installed in Jenkins
    }

    environment {
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'latest'
        CONTAINER_NAME = 'my-java-app-container'
        SNYK_TOKEN = credentials('snyk-token') // Jenkins secret
    }

    stages {
        stage('Snyk Security Scan') {
            steps {
                script {
                        {
                        sh 'mvn snyk:test -fn'
                    }
                }
            }
        }

        stage('Build and Verify') {
            steps {
                script {
                    sh 'mvn clean verify'
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

        stage('Deploy and Run Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh "docker rm -f ${CONTAINER_NAME} || true"

                    // Run the new container on port 8080
                    sh """
                        docker run -d --name ${CONTAINER_NAME} -p 3:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Integration Test') {
            steps {
                script {
                    echo "Waiting for container to start..."
                    sleep(5) // Give the container time to boot up

                    echo "Running integration test with curl..."
                    sh 'curl -f http://localhost:3 || (echo "Container did not start properly!" && exit 1)'

                    echo "Integration test passed!"
                }
            }
        }
    }
}
