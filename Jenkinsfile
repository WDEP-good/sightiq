pipeline {
    agent any

    environment {
        NODE_HOME = '/usr/local/bin'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://your.repo.url/project.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Deploy') {
            steps {
                // 部署到生产环境或测试环境
                sh 'npm run deploy'
            }
        }
    }
}
