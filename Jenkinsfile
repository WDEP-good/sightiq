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
        stage('Build Web') {
            agent {
                label 'web'
                customWorkspace 'web'
                workspace 'web'
                node {
                    label 'web'
                    customWorkspace 'web'
                    workspace 'web'
                }
                docker{
                    image 'node:20'
                    sh 'node -v'
                    args '-v ${workspace}:/app'
                }
            }
            steps {
                sh "cd web"
                sh 'npm install pnpm -g && pnpm install'
                sh 'npx vite build'
            }
        }
        stage('Build Backend') {
            steps {
                sh 'cd backend'
                sh 'cargo build --release'
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
