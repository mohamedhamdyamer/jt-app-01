def my_remote=[:]
my_remote.name = 'docker-host'
my_remote.host = '192.168.8.189'
my_remote.allowAnyHosts = true
my_remote.knownHosts = '/var/jenkins_home/.ssh/known_hosts'

pipeline {
    agent {
        label 'agent-01'
    }
    environment {
        my_creds = credentials('amer-at-docker-host')
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
                    my_remote.user=env.my_creds_USR
                    my_remote.password=env.my_creds_PSW
                }
                sshPut(remote: my_remote, from: 'index.html', into: '/home/amer/tmp/jt-app-01')
            }
        }
        stage('copy-to-tmp-location') {
            agent {
                label 'agent-02'
            }
            steps {
                script {
                    my_remote.user=env.my_creds_USR
                    my_remote.password=env.my_creds_PSW
                }
                sshPut(remote: my_remote, from: 'Dockerfile', into: '/home/amer/tmp/jt-app-01')
                sshPut(remote: my_remote, from: 'stop-container-if-exists.sh', into: '/home/amer/tmp/jt-app-01')
                sshCommand(remote: my_remote, command: "chmod +x /home/amer/tmp/jt-app-01/stop-container-if-exists.sh")
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
