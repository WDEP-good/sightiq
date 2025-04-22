pipeline {
    agent any

    environment {
        NODE_HOME = '/usr/local/bin'
    }

    stages {
        stage('Clone Core') {
            steps {
                git 'https://gitee.com/wdep/sightiq.git'
            }
        }
        stage('Install Web Dependencies') {
            steps {
                sh 'npm install pnpm -g && pnpm install'
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
