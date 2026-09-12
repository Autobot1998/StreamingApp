pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '701043845137'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
        IMAGE_TAG = "1.0.${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('ECR Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'autobot1998-streamingapp-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        aws sts get-caller-identity
                        aws ecr get-login-password --region "$AWS_DEFAULT_REGION" |
                        docker login --username AWS --password-stdin "$ECR_REGISTRY"
                    '''
                }
            }
        }

        stage('Build Images') {
            steps {
                sh '''
                    docker build -t "$ECR_REGISTRY/streaming-auth:$IMAGE_TAG" \
                      ./backend/authService

                    docker build -t "$ECR_REGISTRY/streaming-stream:$IMAGE_TAG" \
                      -f ./backend/streamingService/Dockerfile ./backend

                    docker build -t "$ECR_REGISTRY/streaming-admin:$IMAGE_TAG" \
                      -f ./backend/adminService/Dockerfile ./backend

                    docker build -t "$ECR_REGISTRY/streaming-chat:$IMAGE_TAG" \
                      -f ./backend/chatService/Dockerfile ./backend

                    docker build -t "$ECR_REGISTRY/streaming-frontend:$IMAGE_TAG" \
                      ./frontend
                '''
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'autobot1998-streamingapp-ecr',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        docker push "$ECR_REGISTRY/streaming-auth:$IMAGE_TAG"
                        docker push "$ECR_REGISTRY/streaming-stream:$IMAGE_TAG"
                        docker push "$ECR_REGISTRY/streaming-admin:$IMAGE_TAG"
                        docker push "$ECR_REGISTRY/streaming-chat:$IMAGE_TAG"
                        docker push "$ECR_REGISTRY/streaming-frontend:$IMAGE_TAG"
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout "$ECR_REGISTRY" || true'
        }
        success {
            echo "Five images pushed successfully with tag ${IMAGE_TAG}"
        }
    }
}