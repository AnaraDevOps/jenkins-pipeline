pipeline {
    agent any
    environment {
        NODE_ENV = 'production'
        PORT = ''
        DOCKER_IMAGE = ''
        LOGO_PATH = ''
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.PORT = '3000'
                        env.DOCKER_IMAGE = 'nodemain:v1.0'
                        env.LOGO_PATH = './src/logo.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.DOCKER_IMAGE = 'nodedev:v1.0'
                        env.LOGO_PATH = './src/logo.svg'
                    }
                    sh "cp ${env.LOGO_PATH} ./public/logo.svg"
                    sh "docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "docker ps -q --filter 'ancestor=${env.DOCKER_IMAGE}' | xargs --no-run-if-empty docker stop"
                    sh "docker ps -a -q --filter 'ancestor=${env.DOCKER_IMAGE}' | xargs --no-run-if-empty docker rm"
                    if (env.BRANCH_NAME == 'main') {
                        sh "docker run -d --expose 3000 -p 3000:3000 ${env.DOCKER_IMAGE}"
                    } else if (env.BRANCH_NAME == 'dev') {
                        sh "docker run -d --expose 3001 -p 3001:3000 ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }
    }
}
