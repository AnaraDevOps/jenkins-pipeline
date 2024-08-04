pipeline {
    agent any

    stages {
        // Uncomment the "Hello" stage if needed
        // stage('Hello') {
        //    steps {
        //        echo "Create 2Gb file for build ${currentBuild.number}:"
        //        sh 'dd if=/dev/urandom of="block_${BUILD_NUMBER}" bs=1M count=1024'
        //        echo "Exit"
        //    }
        //}
        stage('Build & Check') {
            steps {
                bat 'echo "hello world" >> logs.txt'
                bat 'tar cvzf archive.tar logs.txt'
                // Uncomment the following line if you want to create a zip archive as well
                // bat 'powershell Compress-Archive -Path logs.txt -DestinationPath archive.zip'
            }
        }
    }

    post {
        // Clean after build
        always {
            // Archive the logs.txt file
            archiveArtifacts artifacts: 'logs.txt', fingerprint: false, allowEmptyArchive: true

            // Archive any files with names starting with "archive."
            archiveArtifacts artifacts: 'archive.*', fingerprint: false, allowEmptyArchive: true

            // Use relative path for deleteDir() to avoid unintended directory deletions
            dir("${env.WORKSPACE}") {
                deleteDir()
            }
        }
    }
}
