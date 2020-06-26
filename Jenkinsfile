def withPod(body) {
  podTemplate(label: 'pod', serviceAccount: 'jenkins', containers: [
      containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
      containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
      containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl', command: 'cat', ttyEnabled: true)
    ],
    volumes: [
      hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
      persistentVolumeClaim(mountPath: '/root/.m2/repository', claimName: 'maven-repo', readOnly: false)
    ]
 ) { body() }
}

withPod {
  node('pod') {
    def tag = "${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    def service = "dummy-service:${tag}"

    checkout scm

    container('maven') {
       stage('Package') {
          sh('mvn clean package')
       }

       stage('Test') {
        sh("mvn test")
       }
    }

    container('docker') {
      stage('Docker build') {
        sh("ls && echo DOCKER CONTAINER")
        sh("docker build -t ${service} .")
        sh("ls && echo DOCKER CONTAINER")
      }

      def tagToDeploy = "jackdavies606/${service}"

      stage('Publish') {
       withDockerRegistry(registry: [credentialsId: 'dockerhub']) {
          sh("docker tag ${service} ${tagToDeploy}")
          sh("docker push ${tagToDeploy}")
        }
      }

      stage('Deploy') {
        sh("sed -i.bak 's#BUILD_TAG#${tagToDeploy}#' ./deploy/staging/*.yml")

        container('kubectl') {
          sh("kubectl --namespace=staging apply -f deploy/staging/")
          sh("kubectl rollout status -n staging deployment/dummy-service")
        }
      }
    }
  }
}

// jenkins plugin https://plugins.jenkins.io/kubernetes/
