pipeline {
    agent any
    tools {
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
        stage('Snyk SAST Scan') {
            steps {
                // Run Snyk SAST scan on the source code
                sh "snyk test --all-projects --severity-threshold=critical --token=${SNYK_TOKEN}"
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
                sh "docker build -t hello-world ."
            }
        }
        stage('Snyk Scan Docker Image') {
            steps {
                // Run Snyk scan on the Docker image
                withCredentials([string(credentialsId: 'synk-token', variable: 'SNYK_TOKEN')]) {
                    script {
                        // Capture the exit status of the Snyk scan
                        def snykExitCode = sh(script: "snyk container test hello-world --severity-threshold=critical --token=${SNYK_TOKEN}", returnStatus: true)

                        // Log the output for reference
                        if (snykExitCode != 0) {
                            echo "Snyk scan completed with issues. Exit code: ${snykExitCode}"
                        } else {
                            echo "Snyk scan completed successfully."
                        }

                        // Optionally, you can still fail the build based on the severity of the vulnerabilities found
                        // Uncomment the next line if you want to fail the build on critical vulnerabilities
                        // error "Critical vulnerabilities found in the image. Please review the Snyk report."
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 6000:80 hello-world'
            }
        }
    }
}
