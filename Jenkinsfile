pipeline {
    agent {
        label 'agent-01'
    }

    stages {
        stage('append-details') {
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
                            filePath: 'index.html'
                        )
                    ]
                )
            }
        }
        stage('copy-to-tmp-location') {
            agent {
                label 'built-in'
            }
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'amer@192.168.8.187',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index.html',
                                )
                            ]
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
                sh "ssh amer@192.168.8.187 'echo ctcvmware | sudo -S docker build -t my-nginx /home/amer/tmp/jt-app-01'"
                sh "./clean-up-prev-build.sh"
                sh "ssh amer@192.168.8.187 'echo ctcvmware | sudo -S docker run --name my-nginx-container --rm -d -p 8888:80 my-nginx:latest'"
                sh "ssh amer@192.168.8.187 'echo ctcvmware | sudo -S docker image prune --all --force'"
                echo "container deployed! ..."
            }
        }
    }
}
