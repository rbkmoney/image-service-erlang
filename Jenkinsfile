#!groovy
// -*- mode: groovy -*-
build('image-service-erlang', 'docker-host') {
  checkoutRepo()
  withPublicRegistry() {
    withPrivateRegistry() {
      runStage('build image') { sh 'make service-erlang' }
    }
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
