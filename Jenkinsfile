#!groovy
// -*- mode: groovy -*-
build('image-service-erlang', 'docker-host') {
  checkoutRepo()
  withGithubSshCredentials {
    runStage('submodules') {
      sh 'make submodules'
    }
  }
  try {
    withPrivateRegistry() {
      runStage('build image') { sh 'make' }
      if (env.BRANCH_NAME == 'master') {
        runStage('push image') { sh 'make push' }
      }
    }
  } finally {
    runStage('Clean up') { sh 'make clean' }
  }
}
