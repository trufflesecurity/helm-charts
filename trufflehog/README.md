# TruffleHog Enterprise Helm Chart

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
kubectl create secret generic config --namespace trufflehog --from-file=config.yaml=/path/to/config.yaml
```

### Installing the Chart:

Once the prerequisites are satisfied, you can deploy Trufflehog using the following command:

```bash
helm repo add trufflesecurity https://trufflesecurity.github.io/helm-charts
helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog
```

### Configuration

The [`values.yaml`](values.yaml) file provides configuration options for the Trufflehog Helm chart. This allows you to customize the deployment according to your environment and requirements.

## Configuration

### 1. Before Installing:

Modify the `values.yaml` file directly in the chart directory to adjust the default values.

### 2. During Installation:

- **Using `--set` Flag**:

  ```bash
  helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog --set replicaCount=2
  ```

  This command overrides the `replicaCount` value, setting it to 2 instead of the default.

- **Using a Custom `values.yaml`**:

  Modify your local copy of `values.yaml`. Then:

  ```bash
  helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog -f /path/to/your/values.yaml
  ```

### 3. After Installation:

If you've already installed the Helm release and want to modify the values:

- **Using `--set` Flag**:

  ```bash
  helm upgrade trufflehog trufflesecurity/trufflehog --namespace trufflehog --set replicaCount=3
  ```

  This command upgrades the existing release with the new value.

- **Using a Custom `values.yaml`**:

  Modify your local copy of `values.yaml` as needed. Then:

  ```bash
  helm upgrade trufflehog trufflesecurity/trufflehog --namespace trufflehog -f /path/to/your/values.yaml
  ```

  This command upgrades the existing release using the modified `values.yaml` file.
