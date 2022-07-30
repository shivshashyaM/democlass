        AWS_DEFAULT_REGION="us-east-1" 
        IMAGE_REPO_NAME="myrepo"
        IMAGE_TAG="latest:myrepo"
        REPOSITORY_URI = "${239799717936}.dkr.ecr.${us-east-1}.amazonaws.com/${myrepo}"
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${us-east-1} | docker login --username AWS --password-stdin ${239799717936}.dkr.ecr.${us-east-1}.amazonaws.com"
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/sd031/aws_codebuild_codedeploy_nodeJs_demo.git']]])    
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${myrepo}:${latest:myrepo}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${myrepo}:${latest:myrepo} ${REPOSITORY_URI}:$latest:myrepo"
                sh "docker push ${239799717936}.dkr.ecr.${us-east-1}.amazonaws.com/${myrepo}:${latest:myrepo}"
         }
        }
      }
    }
}
