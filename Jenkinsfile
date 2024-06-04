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
                                    search: 'Environment built for:',
                                    replace: 'Environment built for: Jenkins Testing ...',
                                    verbose: true
                                ),
                                fileContentReplaceItemConfig(
                                    search: 'Build Number:',
                                    replace: 'Build Number: $BUILD_NUMBER',
                                    verbose: true
                                ),
                                fileContentReplaceItemConfig(
                                    search: '(Full Version: )([0-9].[0-9].[0-9])',
                                    replace: '$13.3.$BUILD_ID',
                                    verbose: true
                                )
                            ],
                            fileEncoding: 'ASCII',
                            lineSeparator: 'Unix',
                            filePath: '/tmp/jt-app-01/index.html'
                        )
                    ]
                )
            }
        }
        stage('deploy-container') {
            agent {
                label 'agent-03'
            }
            steps {
                fileOperations(
                    [
                        fileCopyOperation(
                            includes: 'stop-container-if-exists.sh, Dockerfile',
                            targetLocation: '/tmp/jt-app-01'
                        )
                    ]
                )
                sh "echo ctcvmware | sudo -S docker build -t my-nginx /tmp/jt-app-01"
                sh "./clean-up-prev-build.sh"
                sh "ssh amer@192.168.8.187 'echo ctcvmware | sudo -S docker run --name my-nginx-container --rm -d -p 8888:80 my-nginx:latest'"
                sh "ssh amer@192.168.8.187 'echo ctcvmware | sudo -S docker image prune --all --force'"
                echo "container deployed! ..."
            }
        }
    }
}
