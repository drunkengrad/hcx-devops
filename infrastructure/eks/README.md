## HOW TO

EKS cluster is created using an opensource tool called [eksctl](https://eksctl.io), which is from weaveworks and officially supported by AWS.

Download the tool from `https://github.com/weaveworks/eksctl/releases/tag/v0.72.0`

To use the kubeconfig file from aws, you need aws-authenticator.
Download the aws authenticator from `https://github.com/kubernetes-sigs/aws-iam-authenticator/releases`

To Create cluster

```
eksctl create cluster -f eks_cluster_config.yaml --profile `aws-profile-name`
```

## Note:

To get the complete list of options for the config file, run the below command or, [refer](https://eksctl.io/usage/schema/)
```
eksctl create cluster --dry-run > cluster_config.yaml
```
