def withPod(body) {
  podTemplate(label: 'pod', serviceAccount: 'jenkins', containers: [
      containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
      containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
      containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl', command: 'cat', ttyEnabled: true)
    ],
    volumes: [
      hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    ]
 ) { body() }
}

withPod {
  node('pod') {
    def tag = "${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    def service = "dummy-service:${tag}"

    checkout scm


    container('docker') {
      stage('Package') {
        sh("ls && echo jenkinsss")
        sh("pwd && echo jenkinsss")

//         sh("./mvnw clean") <--- this doesn't work, it looks for /root/.m2
//         sh("ls /usr/bin/")
//         sh("ls /usr/bin/java/")
//         sh("mvn package")
      }

      stage('Docker build') {
        sh("docker build -t ${service} .")
      }
    }
  }
}

// TODO !!!!! --> just implement this as a normal pipeline rather than this shitty
// jenkins plugin https://plugins.jenkins.io/kubernetes/
