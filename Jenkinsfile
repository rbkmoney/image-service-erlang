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
      withPublicRegistry() {
        runStage('build image') { sh 'REGISTRY=dr2.rbkmoney.com make build_image' }
      }
        if (env.BRANCH_NAME == 'master') {
          withPrivateRegistry() {
          runStage('push image') { sh 'make push_image' }
          }
        }
    }
  finally {
    runStage('Clean up') { sh 'make rm_local_image' }
  }
}
