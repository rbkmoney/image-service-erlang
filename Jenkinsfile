#!groovy
// -*- mode: groovy -*-
build('image-service-erlang', 'docker-host') {
  checkoutRepo()
  withGithubSshCredentials {
    runStage('submodules') {
      sh 'make submodules'
    }
  }
  withPublicRegistry() {
    runStage('build image') { sh 'make service-erlang' }
  }
  try {
    if (env.BRANCH_NAME == 'master') {
      withPrivateRegistry() {
        runStage('push image') { sh 'make push' }
      }
    }
  } finally {
    runStage('Clean up') { sh 'make clean' }
  }
}
