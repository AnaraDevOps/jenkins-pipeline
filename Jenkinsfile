pipeline {
    agent any
    environment {
        NODE_ENV = 'production'
        PORT = ''
        DOCKER_IMAGE = ''
        LOGO_PATH = ''
    }

    tools {
        git 'Default'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                bat 'npm install'
            }
        }
        stage('Test') {
            steps {
                bat 'npm test'
            }
        }
        stage('Docker Build') {
            environment {
                PORT = ''
                DOCKER_IMAGE = ''
                LOGO_PATH = ''
            }
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        PORT = '3000'
                        DOCKER_IMAGE = 'nodemain:v1.0'
                        LOGO_PATH = 'src\\logo.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        PORT = '3001'
                        DOCKER_IMAGE = 'nodedev:v1.0'
                        LOGO_PATH = 'src\\logo.svg'
                    }
                    echo "LOGO_PATH: ${LOGO_PATH}"
                    echo "Checking if the logo file exists..."
                    bat "if exist ${LOGO_PATH} (echo File exists) else (echo File not found && exit 1)"
                    bat "copy ${LOGO_PATH} public\\logo.svg"
                    bat "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    bat """
                    for /F "tokens=*" %%i in ('docker ps -q --filter "ancestor=${DOCKER_IMAGE}"') do docker stop %%i
                    for /F "tokens=*" %%i in ('docker ps -a -q --filter "ancestor=${DOCKER_IMAGE}"') do docker rm %%i
                    """
                    if (env.BRANCH_NAME == 'main') {
                        bat "docker run -d --expose 3000 -p 3000:3000 ${DOCKER_IMAGE}"
                    } else if (env.BRANCH_NAME == 'dev') {
                        bat "docker run -d --expose 3001 -p 3001:3000 ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }
}
