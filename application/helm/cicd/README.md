## Jenkins in Kubernetes

Installation is done with helm
```
helm upgrade --install jenkins --namespace cicd ./jenkins -f ./jenkins/values-custom.yaml --create-namespace
```

## Notes

1. All jobs will run inside pods, which is selected with labels
2. All Such pods are called agents and is defined with `podTemplates`
3. Sample code 
   ```
   ## Pod template.yaml ( in jenkins/values.yaml )
     podTemplates:
       deploymentPod: | # Simple name for identification, no realy use.
         - name: ansible
           label: ansible # !!! Important part.
           serviceAccount: jenkins
           - envVar:
               key: "ANSIBLE_HOST_KEY_CHECKING"
               value: "False"
           volumes:
           - secretVolume:
               # Note that the JSON spec doesn't support octal notation, so use the value 256 for 0400 permissions.
               # If you use YAML instead of JSON for the Pod, you can use octal notation to specify permissions in a more natural way.
               # Ref: https://kubernetes.io/docs/concepts/configuration/secret/#projection-of-secret-keys-to-specific-paths
               defaultMode: "256"
               mountPath: /var/lib/jenkins/secrets/
               secretName: ssh-key
           containers:
             - name: ansible
               image: quay.io/ansible/ansible-runner:stable-2.10-devel
               # !!Important, Make sure youre container will sleep long enough for 
               # the tasks to run
               command: "/bin/sh -c" 
               args: "cat"
               ttyEnabled: true
               privileged: true
               resourceRequestCpu: "400m"
               resourceRequestMemory: "512Mi"
               resourceLimitCpu: "1"
               resourceLimitMemory: "1024Mi"
   ```
   ```
   # Sample Jenkinsfile
   pipeline {
        agent {
            label "ansible" // Comes from the pod label
        }
        stages {
        stage('Run ansible') {
          steps {
            container('ansible') {
              sh 'ansible --version'
            }
          }
        }
      }
    }

   ```


