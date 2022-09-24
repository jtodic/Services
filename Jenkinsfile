properties([
    parameters(
        [
            choice(
                choices: ['no', 'yes'], 
                description: 'SYSTEM ONLY - reloads the pipeline without running any steps so that new pipeline changes can be shown', 
                name: 'RELOAD_PIPELINE'
            ),
            choice(choices: ['---', 'Services'], description: 'Project to deploy', name: 'PROJECT'),
            [
                        $class: 'CascadeChoiceParameter',
                        choiceType: 'PT_SINGLE_SELECT',
                        description: '',
                        filterLength: 1,
                        filterable: true,
                        name: 'GIT_TAG',
                        randomName: 'choice-parameter-10644504575940977',
                        referencedParameters: 'PROJECT',
                        script: [
                                $class: 'GroovyScript',
                                fallbackScript: [classpath: [], sandbox: false, script: ''],
                                script: [
                                        classpath: [],
                                        sandbox: false,
                                        script: '''
                        def proc;
                        if (PROJECT.equals("Services")) {
                            proc = "git ls-remote --tags --refs https://github.com/jtodic/Services.git".execute()
                        } else {
                            return ["---"]
                        }
                        
                        def errorStream = new StringBuffer()
                        proc.consumeProcessErrorStream(errorStream)
                        println(errorStream)
                        
                        return proc.text.split("\\\\n").collect{ it -> it.split("\\\\t")[1].replaceAll('refs/tags/v', '') }
                    '''
                                ]
                        ]
            ],
        ]

    )
])


pipeline {
    agent {
        label 'docker-ssh-slave'
    }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('77a742d1-f8f5-42de-89b1-7d10c2981928')
    }
    options {
        disableConcurrentBuilds()
    }
    stages {
        stage('Reload pipeline') {
            when {
                anyOf {
                    environment name: 'RELOAD_PIPELINE', value: 'yes'
                    environment name: 'RELOAD_PIPELINE', value: ''
                }
            }
            steps {
                script {
                    println "RELOADING PIPELINE FINISHED"
                    currentBuild.getRawBuild().getExecutor().interrupt(Result.SUCCESS)
                    sleep(5) 
                }
            }
        }

        stage('Checkout') {
            steps {
                dir('Services-repo') {
                checkout([
                $class: 'GitSCM', 
                branches: [[name: '*/main']], 
                extensions: [], 
                userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/jtodic/Services.git']]]) 
                }
            }
        }

        stage('Build docker images') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin; \
                        cd "${WORKSPACE}"/Services-repo/service1 ; \
                        docker build . -t jtodic/service1 ; \
                        cd "${WORKSPACE}"/Services-repo/service2 ; \
                        docker build . -t jtodic/service2'
                }
            }
        }

        stage('Unit Test') {
            steps {
                script {
                    println "Running Unit Test"
                    results = ""
                    if (results == "fail") {
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Integration Test') {
            steps {
                script {
                    println "Running Integration Test"
                    results = ""
                    if (results == "fail") {
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Publish docker images') {
            steps {
                script {
                    sh 'docker image push jtodic/service1:latest; \
                        docker image tag jtodic/service1:latest jtodic/service1:"${GIT_TAG}"; \
                        docker image push jtodic/service1:"${GIT_TAG}"; \
                        docker image rm jtodic/service1:latest; \
                        docker image rm jtodic/service1:"${GIT_TAG}"'

                    sh 'docker image push jtodic/service2:latest; \
                        docker image tag jtodic/service2:latest jtodic/service2:"${GIT_TAG}"; \
                        docker image push jtodic/service2:"${GIT_TAG}"; \
                        docker image rm jtodic/service2:latest; \
                        docker image rm jtodic/service2:"${GIT_TAG}"'
                    
                }
            }
        }
    }

    post {
        always {
            emailext (recipientProviders: [requestor()],
                subject:"${currentBuild.currentResult}: ${currentBuild.projectName} ${currentBuild.displayName}",
                body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} \nBuild ${env.BUILD_NUMBER} \nMore info at: ${env.BUILD_URL}"
                )
        }
    }

}

