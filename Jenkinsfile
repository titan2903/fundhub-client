pipeline {
    agent {
        label 'sandbox'
    }

    environment {
        WEBHOOK_URL_DISCORD = credentials('WEBHOOK_URL_DISCORD')
        DOCKER_USERNAME = credentials('DOCKER_USERNAME')
        DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
    }

    stages {
        stage('Unit Test'){
            agent {
                docker {
                    image 'node:16-alpine'
                    label 'sandbox'
                }
            }

            steps {
                echo "Testing Fundhub client"
            }   
        }

        stage('Build') {
            steps {
                echo "Building Apps"
                sh "docker build -t $DOCKER_USERNAME/fundhub-client-dev:${BUILD_NUMBER} ."
            }
        }

        stage('Push to DockerHub') {
             steps {
                echo "Pushing to DockerHub"
                sh "docker login -u $DOCKER_USERNAME -p ${DOCKER_PASSWORD}"
                sh "docker push $DOCKER_USERNAME/fundhub-client-dev:${BUILD_NUMBER}"
            }

            post {
                aborted {
                    echo "Post Aborted"
                    discordSend description: "Push Docker Image", footer: "Push image fundhub-client-dev:${BUILD_NUMBER} to DockerHub Status: Aborted", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$WEBHOOK_URL_DISCORD"
                }
                success {
                    echo "Post Success"
                    discordSend description: "Push Docker Image", footer: "Push image fundhub-client-dev:${BUILD_NUMBER} to DockerHub Status: Success", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$WEBHOOK_URL_DISCORD"
                }
                failure {
                    echo "Post Failure"
                    discordSend description: "Push Docker Image", footer: "Push image fundhub-client-dev:${BUILD_NUMBER} to DockerHub Status: Failure", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$WEBHOOK_URL_DISCORD"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Service"
                // Delete all docker images after push to DockerHub
                sh 'docker rmi $(docker images -q)'
            }
        }

    }
    
    post {
        aborted {
            echo "Post Aborted"
            discordSend description: "Fundhub Client Deployment", footer: "Fundhub Client Staging Deployment Status: Aborted", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$WEBHOOK_URL_DISCORD"
        }

        success {
            echo "Post Success"
            discordSend description: "Fundhub Client Deployment", footer: "Fundhub Client Staging Deployment Status: Success", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$WEBHOOK_URL_DISCORD"
        }
        
        failure {
            echo "Post Failure"
            discordSend description: "Fundhub Client Deployment", footer: "Fundhub Client Staging Deployment Status: Failure", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$WEBHOOK_URL_DISCORD"
        }
    }
}