def remote=[:]
remote.name = 'docker-host'
remote.host = '192.168.8.189'
remote.allowAnyHosts = true

pipeline {
    agent {
        label 'agent-01'
    }
    environment {
        my-creds = credentials('amer-at-docker-host')
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
                script {
                    my-remote.user=env.my-creds_USR
                    my-remote.password=env.my-creds_PSW
                }
                sshCommand(remote: my-remote, command: "ls -ltr")
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
                            configName: 'amer@docker-host',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'Dockerfile, stop-container-if-exists.sh',
                                    keepFilePermissions: true
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
                sh "ssh amer@192.168.8.189 'echo ctcvmware | sudo -S docker build -t my-nginx /home/amer/tmp/jt-app-01'"
                sh "./clean-up-prev-build.sh"
                sh "ssh amer@192.168.8.189 'echo ctcvmware | sudo -S docker run --name my-nginx-container --rm -d -p 8888:80 my-nginx:latest'"
                sh "ssh amer@192.168.8.189 'echo ctcvmware | sudo -S docker image prune --all --force'"
                echo "container deployed! ..."
            }
        }
    }
}
