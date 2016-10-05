#!groovy

build('image-service-erlang', 'docker-host') {
  checkoutRepo()
  loadBuildUtils()

  def pipeDefault
  runStage('load pipeline') {
    env.JENKINS_LIB = "build_utils/jenkins_lib"
    pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
  }

  pipeDefault() {
    runStage('build service_erlang image') {
      sh "make build_image"
    }
    try {
      if (env.BRANCH_NAME == 'master') {
        runStage('push service_erlang image') {
          sh "make push_image"
        }
      }
    } finally {
      runStage('rm local image') {
        sh 'make rm_local_image'
      }
    }
  }
}

