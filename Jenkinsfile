pipeline {

    stages{
        stage('node-version'){
            agent {
                docker { image 'node:16-alpine' }
            }

            steps {
                sh ' node --version '
            }
        }

        stage('backend'){
            agent {
                docker { image 'maven:3.8.1-adoptopenjdk-11' }
            }

            steps {
                sh ' mvn --version '
            }
        }
        stage('python'){
        agent {
            docker { image 'node:16-alpine' }
        }
        steps{
            sh 'sudo apt install python3 -y'
        }
        }
    }
}