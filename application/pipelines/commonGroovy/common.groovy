// Defining common variables and functions
commonVariables = {
    completeJobName = sh(returnStdout: true, script: "echo $JOB_NAME")
    jobName = completeJobName.split('/')[-1].trim().toLowerCase()
    appName = params.application ?: jobName
    envName = completeJobName.split('/')[-2].trim().toLowerCase()
    chartPath = "${env.WORKSPACE}/application/helm/core/$jobName"
}

checkoutPrivate = {
          checkout(
            [$class: 'GitSCM', branches: [[name: '*/main']],
            extensions: [
                [$class: 'RelativeTargetDirectory', relativeTargetDir: 'private'],
                [$class: 'CloneOption', noTags: true, reference: '', shallow: true]
            ],
            userRemoteConfigs: [[
                  credentialsId: "${env.GH_REPO_CRED}",
                  url: "${env.GH_PRIVATE_REPO}"
          ]]])
}

// Groovy closure
// Ref: https://groovy-lang.org/closures.html
deployHelm = {
    // Variable declaration
    appName ->

    copyArtifacts filter: 'metadata.json', fingerprintArtifacts: true, projectName: "build/$appName"
    imageName = sh(returnStdout: true, script: 'jq -r .image_name metadata.json').trim()
    imageTag = params.image_tag ?: sh(returnStdout: true, script: 'jq -r .image_tag metadata.json').trim()
    sh """
      echo ${appName}
      cd application/ansible
      ansible-playbook -i ../../private/hcx/ansible/inventory/${envName}/hosts helm.yaml -e application=$appName -e image_tag=$imageTag -e namespace=${envName} -e chart_path=${chartPath} -v
    """
}

deployAnsible = {
    // Variable declaration
    ansibleCommands ->
    sh """
      echo ${appName}
      cd application/ansible
      ansible-playbook -i ../../private/hcx/ansible/inventory/${envName}/hosts ${ansibleCommands}
    """
}
// Ref: https://stackoverflow.com/questions/37800195/how-do-you-load-a-groovy-file-and-execute-it
return this
