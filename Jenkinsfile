pipeline {
    agent any
//  parameters {
//   credentials credentialType: 'com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl', defaultValue: 'AWS_CREDS_AUTOMATION_ACCT', name: 'AWS_AUTOMATION_ACCOUNT_CRED', required: false
// }

    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        AMI_ID="stack-ami-${BUILD_NUMBER}"
        VERSION = "1.0.${BUILD_NUMBER}"
    }
    stages{

         stage('Initial Stage') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }

        // stage('Packer AMI Build'){
        //      steps {
        //          //slackSend (color: '#FFFF00', message: "STARTING PACKER IMAGE BUILD: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        //          sh '''
        //          cd images
        //          sed -i "s/ami-stack-'[0-9]*$'/'${AMI_ID}'/" ./image.pkr.hcl 
        //          export PACKER_LOG=1
        //          export PACKER_LOG_PATH=$WORKSPACE/packer.log
        //          /usr/bin/packer build -force image.pkr.hcl 
        //          '''
               
        //  }
        //  }


        stage('Terraform init'){
             steps {
                 slackSend (color: '#ffaa00', message: "STARTING TERRAFORM DEPLOYMENT -RUKAYAT:  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                 sh """
                 terraform init -upgrade 
                 """                  
         }
         }
         

        stage('Terraform Plan'){
             steps {
                 sh """
                 terraform plan -out=tfplan -input=false
                 """                          
         }
         }

        stage('Clixx Code Deploy'){
             steps {
                 slackSend (color: '#FFFF00', message: "STARTING INFRASTRUCTURE BUILD AND VULNERABILITY SCAN - -RUKAYAT:  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                 sh """
                 terraform apply -auto-approve
                 """                          
         }
         }

        //   stage('Build Vulnerability Report'){
        //      steps {
        //          sh """
        //          aws inspector start-assessment-run --assessment-run-name Hardeningrun_'${VERSION}' --assessment-template-arn "arn:aws:inspector:us-east-1:196880981857:target/0-IhIHttwd/template/0-ew1eWaCe" --region us-east-1
        //          """  
        //          slackSend (color: '#FFFF00', message: "ENDING DEPLOYMENT: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")                        
        //  }
        //  }


       
        
    }
}

 def getTerraformPath(){
        def tfHome= tool name: 'terraform-14', type: 'terraform'
        return tfHome
    }

//  def getAnsiblePath(){
//         def AnsibleHome= tool name: 'Ansible', type: 'org.jenkinsci.plugins.ansible.AnsibleInstallation'
//         return AnsibleHome
//     }

// def getPackerPath(){
//        def PackerHome= tool name: 'Packer', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
//     }


