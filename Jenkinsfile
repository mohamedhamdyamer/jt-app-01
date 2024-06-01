pipeline {
    agent {
        label 'agent-01'
    }

    stages {
        stage('copy-to-tmp-location') {
            steps {
                fileOperations(
                    [
                        fileCopyOperation(
                            includes: 'index.html',
                            targetLocation: '/tmp/jt-app-01'
                        )
                    ]
                )
            }
        }
        stage('append-details') {
            agent {
                label 'agent-02'
            }
            steps {
                contentReplace(
                    configs: [
                        fileContentReplaceConfig(
                            configs: [
                                fileContentReplaceItemConfig(
                                    search: 'Environment built for',
                                    replace: 'Environment built for: Jenkins Testing ...',
                                    verbose: true,
                                )
                            ],
                            fileEncoding: 'ASCII',
                            lineSeparator: 'Unix',
                            filePath: '/tmp/jt-app-01/index.html'
                        )
                    ]
                )
                sh "sed -i 's/Build Number:/Build Number: $BUILD_NUMBER/g' /tmp/jt-app-01/index.html"
            }
        }
        stage('deploy-container') {
            agent {
                label 'agent-03'
            }
            steps {
                sh 'cp Dockerfile /tmp/jt-app-01'
                sh "ssh amer@192.168.100.69 'echo ctcvmware | sudo -S docker build -t my-nginx /tmp/jt-app-01'"
                sh "ssh amer@192.168.100.69 'echo ctcvmware | sudo -S docker stop my-nginx-container'"
                sh "ssh amer@192.168.100.69 'echo ctcvmware | sudo -S docker run --name my-nginx-container --rm -d -p 8888:80 my-nginx:latest'"
                sh "ssh amer@192.168.100.69 'echo ctcvmware | sudo -S docker image prune --all --force'"
                echo "container deployed! ..."
            }
        }
    }
}
