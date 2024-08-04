pipeline {
    agent any
    environment {
        NODE_ENV = 'production'
        PORT = ''
        DOCKER_IMAGE = ''
        LOGO_PATH = ''
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }
        stage('Test') {
            steps {
                bat 'npm test'
            }
        }
        stage('Change Logo and Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.PORT = '3000'
                        env.DOCKER_IMAGE = 'nodemain:v1.0'
                        env.LOGO_PATH = 'src/main/logo.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.DOCKER_IMAGE = 'nodedev:v1.0'
                        env.LOGO_PATH = 'src/dev/logo.svg'
                    }
                
                    bat "copy ${env.LOGO_PATH} public\\logo.svg"
                    bat "docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing containers
                    bat "docker ps -q --filter 'ancestor=${env.DOCKER_IMAGE}' | xargs --no-run-if-empty docker stop"
                    bat "docker ps -a -q --filter 'ancestor=${env.DOCKER_IMAGE}' | xargs --no-run-if-empty docker rm"
                    // Run the container with the appropriate port
                    if (env.BRANCH_NAME == 'main') {
                        bat "docker run -d --expose 3000 -p 3000:3000 ${env.DOCKER_IMAGE}"
                    } else if (env.BRANCH_NAME == 'dev') {
                        bat "docker run -d --expose 3001 -p 3001:3000 ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }
    }
}

