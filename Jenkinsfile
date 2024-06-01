pipeline {
    agent {
        label 'agent-01'
    }

    stages {
        stage('copy-to-tmp-location') {
            steps {
                sh 'cp index.html /tmp/jt-app-01/index.html'
            }
        }
        stage('append-details') {
            agent {
                label 'agent-02'
            }
            steps {
                sh "sed -i 's/Environment built for:/Environment built for: Jenkins Testing .../g' /tmp/jt-app-01/index.html"
                sh "sed -i 's/Build Number:/Build Number: $BUILD_NUMBER/g' /tmp/jt-app-01/index.html"
            }
        }
        stage('deploy-container') {
            agent {
                label 'agent-03'
            }
            steps {
                sh 'cp default.conf nginx.conf Dockerfile /tmp/jt-app-01'
                sh "ssh amer@192.168.100.69 'echo ctcvmware | sudo -S docker build -t my-nginx /tmp/jt-app-01'"
                sh "ssh amer@192.168.100.69 'echo ctcvmware | sudo -S docker run --rm -d -p 8888:8888 my-nginx:latest'"
                echo "container deployed! ..."
            }
        }
    }
}
