properties([
    parameters(
        [
            choice(
                choices: ['no', 'yes'], 
                description: 'SYSTEM ONLY - reloads the pipeline without running any steps so that new pipeline changes can be shown', 
                name: 'RELOAD_PIPELINE'
            ),
            choice(choices: ['---', 'service1', 'service2'], description: 'MS version to build', name: 'PROJECT1'),
            [
                        $class: 'CascadeChoiceParameter',
                        choiceType: 'PT_SINGLE_SELECT',
                        description: '',
                        filterLength: 1,
                        filterable: true,
                        name: 'GIT_TAG1',
                        randomName: 'choice-parameter-10644504575940977',
                        referencedParameters: 'PROJECT1',
                        script: [
                                $class: 'GroovyScript',
                                fallbackScript: [classpath: [], sandbox: false, script: ''],
                                script: [
                                        classpath: [],
                                        sandbox: false,
                                        script: '''
                        def proc;
                        if (PROJECT1.equals("service1")) {
                            proc = "git ls-remote --tags --refs https://github.com/jtodic/service1.git".execute()
                        } else if (PROJECT1.equals("service2")) {
                            proc = "git ls-remote --tags --refs https://github.com/jtodic/service2.git".execute()
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
            choice(choices: ['---', 'service1', 'service2'], description: 'Second MS version to build', name: 'PROJECT2'),
            [
                        $class: 'CascadeChoiceParameter',
                        choiceType: 'PT_SINGLE_SELECT',
                        description: '',
                        filterLength: 1,
                        filterable: true,
                        name: 'GIT_TAG2',
                        randomName: 'choice-parameter-10644504575940112',
                        referencedParameters: 'PROJECT2',
                        script: [
                                $class: 'GroovyScript',
                                fallbackScript: [classpath: [], sandbox: false, script: ''],
                                script: [
                                        classpath: [],
                                        sandbox: false,
                                        script: '''
                        def proc;
                        if (PROJECT2.equals("service1")) {
                            proc = "git ls-remote --tags --refs https://github.com/jtodic/service1.git".execute()
                        } else if (PROJECT2.equals("service2")) {
                            proc = "git ls-remote --tags --refs https://github.com/jtodic/service2.git".execute()
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
                dir("${PROJECT1}-repo") {
                checkout([
                $class: 'GitSCM', 
                branches: [[name: 'refs/tags/v${GIT_TAG1}']], 
                extensions: [], 
                userRemoteConfigs: [[credentialsId: '', url: "https://github.com/jtodic/${PROJECT1}.git"]]]) 
                }
                dir("${PROJECT2}-repo") {
                checkout([
                $class: 'GitSCM', 
                branches: [[name: 'refs/tags/v${GIT_TAG2}']], 
                extensions: [], 
                userRemoteConfigs: [[credentialsId: '', url: "https://github.com/jtodic/${PROJECT2}.git"]]]) 
                }

            }
        }

        stage('Build docker images') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin; \
                        cd "${WORKSPACE}"/"${PROJECT1}"-repo ; \
                        docker build . -t jtodic/"${PROJECT1}" ; \
                        cd "${WORKSPACE}"/"${PROJECT2}"-repo ; \
                        docker build . -t jtodic/"${PROJECT2}"'
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
                    sh 'docker image push jtodic/"${PROJECT1}":latest; \
                        docker image tag jtodic/"${PROJECT1}":latest jtodic/"${PROJECT1}":"${GIT_TAG1}"; \
                        docker image push jtodic/"${PROJECT1}":"${GIT_TAG1}"; \
                        docker image rm jtodic/"${PROJECT1}":latest; \
                        docker image rm jtodic/"${PROJECT1}":"${GIT_TAG1}"'

                    sh 'docker image push jtodic/"${PROJECT2}":latest; \
                        docker image tag jtodic/"${PROJECT2}":latest jtodic/"${PROJECT2}":"${GIT_TAG2}"; \
                        docker image push jtodic/"${PROJECT2}":"${GIT_TAG2}"; \
                        docker image rm jtodic/"${PROJECT2}":latest; \
                        docker image rm jtodic/"${PROJECT2}":"${GIT_TAG2}"'
                    
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

