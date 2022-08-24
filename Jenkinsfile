pipeline {
    agent any
    
    tools {
        nodejs "nodejs"
    }
    
    environment {
        registry = "668027814271.dkr.ecr.ap-southeast-1.amazonaws.com/express"
        serviceName = "${JOB_NAME}"
        gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        shortCommitHash = gitCommitHash.take(7)
        gitCommitId = sh(script: 'git rev-parse HEAD|cut -c1-7', returnStdout: true).trim()
        taggedImage = "${registry}:${gitCommitId}"
    }

    stages {
        stage('Install Depedencies') {
            steps {
                sh "npm install"
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    "docker build -t ${registry} -t ${taggedImage} ."
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh "aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 668027814271.dkr.ecr.ap-southeast-1.amazonaws.com"
                sh "docker push ${taggedImage}"
            }
        }
        
        stage("Deploy to EKS") {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-aws', namespace: '', serverUrl: '') {
                    sh "kubectl set image deployment.apps/expressk8s expressk8s=${taggedImage}"
                    sh "kubectl rollout restart deployment.apps"
                }
            }
        }
    }
}
