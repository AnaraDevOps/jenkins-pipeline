pipeline {
    agent any
    stages {
        // stage('Hello') {
        //    steps {
        //        echo "Create 2Gb file for build ${currentBuild.number}:"
        //        sh 'dd if=/dev/urandom of="block_${BUILD_NUMBER}" bs=1M count=1024'
        //        echo "Exit"
        //    }
        //}
        stage('Build & Check') {
            steps {
                sh 'echo "hello world" >> logs.txt'
                sh 'tar cvzf archive.tar logs.txt'
                // sh 'zip archive.zip log.txt'
            }
        }
    }
    post {
        // Clean after build
        always {
            archiveArtifacts artifacts: 'logs.txt', fingerprint:false, allowEmptyArchive: 'true'
            archiveArtifacts artifacts: 'archive.*', fingerprint:false, allowEmptyArchive: 'true'
            dir("../") {
                deleteDir()
            }
        }
    }
}
 