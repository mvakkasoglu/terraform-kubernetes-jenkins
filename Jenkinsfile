pipeline {
    agent {
        node {
            label "master"
        } 
    }

    stages {
        stage('Clean up') {
			steps {
				script {
					sh 'rm -rf terraform-kubernetes-jenkins'
				}
			}
		}
        stage('fetch_latest_code') {
            steps {
                script{
                    sh 'git clone https://github.com/mvakkasoglu/terraform-kubernetes-jenkins.git'
                }
            }
        }

        stage('TF Init&Plan') {
            steps {
                script {
                    sh '/usr/local/bin/terraform init'
               //   sh '/usr/local/bin/terraform plan'
                }             
            }      
        }

        stage('TF Apply') {
            steps {
                script {
                    sh '/usr/local/bin/terraform apply -input=false -auto-approve'
                }
            }
        }
        
        stage('Show namespaces') {
            steps {
                script {
                    sh '/usr/local/bin/kubectl get all --all-namespaces'
                }
            }
        }
    } 
}