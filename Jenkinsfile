pipeline{
    agent any{
        stages{
            stage('Git Checkout'){
                steps{
                    script{
                        git branch: 'main', url: 'https://github.com/99North/Counter-App-Using-Jen-Mvn-Sonar-Nexus-Doc.git'
                    }
                }
            }
        }
    }
}