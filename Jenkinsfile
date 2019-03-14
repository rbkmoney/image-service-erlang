#!groovy
// -*- mode: groovy -*-
build('image-service-erlang', 'docker-host') {
  checkoutRepo()
  withCredentials(
    [[$class: 'FileBinding', credentialsId: 'github-rbkmoney-ci-bot-file', variable: 'GITHUB_PRIVKEY'],
     [$class: 'FileBinding', credentialsId: 'bakka-su-rbkmoney-all', variable: 'BAKKA_SU_PRIVKEY']]) {
    runStage('submodules') {
      sh 'make submodules'
    }
    runStage('shared repositories update') {
      sh 'make -j2 repos'
    }
  }
  withCredentials(
    [[$class: 'FileBinding', credentialsId: 'github-rbkmoney-ci-bot-file', variable: 'GITHUB_PRIVKEY']]) {
    runStage('build image') {
      sh 'make'
    }
  }
  try {
    if (env.BRANCH_NAME == 'master') {
      runStage('push image') {
        sh 'make push'
      }
    }
  } finally {
    runStage('Clean up') {
      sh 'make clean'
    }
  }
}
