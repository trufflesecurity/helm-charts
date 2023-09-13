# Trufflehog Helm Chart

Description of what the chart deploys and its purpose.

## Prerequisites

Before installing the Helm chart, you need to prepare your Kubernetes cluster with some additional resources:

### Create the Namespace:

```bash
kubectl create namespace trufflehog
```

### Create the Configuration Secret:

Ensure you have the config.yaml file prepared with the appropriate configuration. Then, create the secret in the trufflehog namespace:
```bash
kubectl create secret generic config --namespace trufflehog --from-file=config.yaml=config.yaml
```

### Installing the Chart:

Once the prerequisites are satisfied, you can deploy Trufflehog using the following command:
```bash
helm repo add trufflescurity https://trufflescurity.github.io/helm-charts
helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog
```

### Configuration

The `values.yaml` file provides configuration options for the Trufflehog Helm chart. This allows you to customize the deployment according to your environment and requirements.

#### Key Configurations:

- **replicaCount**: Sets the number of pod replicas.
- **image**: Defines the Docker image repository and tag.
- **config**: Configures the Kubernetes secret that provides the application's configuration data.
- **probe**: Specifies the health probe settings for the pod, including initial delay and check frequency.
- **nameOverride** and **fullnameOverride**: Allow for overriding the default naming of the deployment.

To adjust these configurations:

1. Modify the `values.yaml` file directly, or
2. Provide overrides during the Helm install command.

Example:
```bash
helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog --set replicaCount=2
```

This command overrides the `replicaCount` value, setting it to 2 instead of the default.
