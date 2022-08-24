pipeline {
    agent any
    
    tools {
        nodejs "nodejs"
    }
    
    environment {
        registry = "668027814271.dkr.ecr.ap-southeast-1.amazonaws.com/express"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/k8s']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/pimenvibritania/dockerize-kubernitize']]])
            }
        }
        stage('Install Depedencies') {
            steps {
                sh "npm install"
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    docker.build registry
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh "aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 668027814271.dkr.ecr.ap-southeast-1.amazonaws.com"
                sh "docker push 668027814271.dkr.ecr.ap-southeast-1.amazonaws.com/express:latest"
            }
        }
        
        stage("Deploy to EKS") {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-aws', namespace: '', serverUrl: '') {
                    sh "kubectl apply -f k8s.yaml"
                }
            }
        }
    }
}
