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
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.PORT = '3000'
                        env.DOCKER_IMAGE = 'nodemain:v1.0'
                        env.LOGO_PATH = 'src\\logo.svg'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.DOCKER_IMAGE = 'nodedev:v1.0'
                        env.LOGO_PATH = 'src\\logo.svg'
                    }
                    echo "LOGO_PATH: ${env.LOGO_PATH}"
                    echo "Checking if the logo file exists..."
                    bat "if exist ${env.LOGO_PATH} (echo File exists) else (echo File not found && exit 1)"
                    bat "copy ${env.LOGO_PATH} public\\logo.svg"
                    echo "Checking Docker status..."
                    bat "docker --version"
                    bat "docker info"
                    echo "Building Docker image..."
                    bat "docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Stopping and removing any existing containers..."
                    bat """
                    for /F "tokens=*" %%i in ('docker ps -q --filter "ancestor=${env.DOCKER_IMAGE}"') do (
                        docker stop %%i
                    )
                    for /F "tokens=*" %%i in ('docker ps -a -q --filter "ancestor=${env.DOCKER_IMAGE}"') do (
                        docker rm %%i
                    )
                    """
                    echo "Running the Docker container..."
                    if (env.BRANCH_NAME == 'main') {
                        bat "docker run -d --expose 3000 -p 3000:3000 ${env.DOCKER_IMAGE}"
                    } else if (env.BRANCH_NAME == 'dev') {
                        bat "docker run -d --expose 3001 -p 3001:3000 ${env.DOCKER_IMAGE}"
                    }
                    bat "docker ps -a"
                }
            }
        }
    }
}
