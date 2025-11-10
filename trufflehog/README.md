# TruffleHog Enterprise Helm Chart

This Helm chart deploys TruffleHog Enterprise Scanner, a tool for detecting secrets, credentials, and other sensitive data in your codebase.

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

## Configuration

The [`values.yaml`](values.yaml) file provides configuration options for the Trufflehog Helm chart. This allows you to customize the deployment according to your environment and requirements.

### Installation Methods

#### 1. Using Default Values:

```bash
helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog
```

#### 2. Using `--set` Flag:

```bash
helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog --set replicaCount=2
```

This command overrides the `replicaCount` value, setting it to 2 instead of the default.

#### 3. Using a Custom `values.yaml`:

Modify your local copy of `values.yaml`. Then:

```bash
helm install trufflehog trufflesecurity/trufflehog --namespace trufflehog -f /path/to/your/values.yaml
```

#### 4. Upgrading an Existing Release:

If you've already installed the Helm release and want to modify the values:

```bash
helm upgrade trufflehog trufflesecurity/trufflehog --namespace trufflehog --set replicaCount=3
```

Or using a custom values file:

```bash
helm upgrade trufflehog trufflesecurity/trufflehog --namespace trufflehog -f /path/to/your/values.yaml
```

## Configuration Reference

### Image Configuration

```yaml
image:
  repository: us-docker.pkg.dev/thog-artifacts/public/scanner
  tag: latest
  pullPolicy: Always
```

- `repository`: Docker image repository
- `tag`: Image tag to use
- `pullPolicy`: Image pull policy (Always, IfNotPresent, Never)

### Replica Count

```yaml
replicaCount: 1
```

Sets the number of pod replicas to run.

### Resources

```yaml
resources:
  requests:
    memory: "16Gi"
    cpu: "4000m"
    ephemeralStorage: "10Gi"
  limits:
    enabled: true
    memory: "48Gi"
    cpu: "12000m"
    ephemeralStorage: "30Gi"
```

Configure resource requests and limits for the container. Set `limits.enabled: false` to disable resource limits.

### Vertical Pod Autoscaler (VPA)

```yaml
vpa:
  enabled: true
  minAllowed:
    cpu: "4000m"
    memory: "16Gi"
  maxAllowed:
    enabled: true
    memory: "48Gi"
    cpu: "12000m"
```

Configure VPA to automatically adjust resource requests based on observed usage.

### Configuration Secret

```yaml
config:
  secretName: config
```

Specifies the name of the Kubernetes secret containing the application configuration (`config.yaml`).

### Persistence

Configure persistent storage for the TruffleHog scanner. Supports multiple volume types including PersistentVolumeClaim, emptyDir, hostPath, and custom volumes.

```yaml
persistence:
  enabled: false
  mountPath: /data
  type: pvc  # Options: pvc, emptyDir, hostPath, custom
  pvc:
    existingClaim: ""        # Use existing PVC (if empty, creates new)
    storageClass: ""         # Storage class for dynamic provisioning (empty = default)
    size: 10Gi               # Size for dynamically provisioned PVC
    accessMode: ReadWriteOnce
    labels: {}
    annotations: {}
  emptyDir: {}
  hostPath:
    path: ""
    type: ""
  custom: {}
```

#### Using an Existing PersistentVolumeClaim

To use an existing PersistentVolumeClaim:

```yaml
persistence:
  enabled: true
  type: pvc
  mountPath: /data
  pvc:
    existingClaim: my-existing-pvc
```

#### Auto-provisioning a PersistentVolumeClaim

To automatically create and use a new PersistentVolumeClaim:

```yaml
persistence:
  enabled: true
  type: pvc
  mountPath: /data
  pvc:
    storageClass: fast-ssd
    size: 50Gi
    accessMode: ReadWriteOnce
```

#### Using emptyDir (Ephemeral Storage)

For temporary storage that persists only for the pod's lifetime:

```yaml
persistence:
  enabled: true
  type: emptyDir
  mountPath: /data
```

You can optionally set a size limit (requires SizeMemoryBackedVolumes feature gate):

```yaml
persistence:
  enabled: true
  type: emptyDir
  mountPath: /data
  emptyDir:
    sizeLimit: 10Gi
```

#### Using hostPath

To mount a directory from the host node:

```yaml
persistence:
  enabled: true
  type: hostPath
  mountPath: /data
  hostPath:
    path: /mnt/data
    type: Directory  # Options: Directory, DirectoryOrCreate, File, FileOrCreate
```

#### Using Custom Volumes

For advanced use cases (NFS, CephFS, etc.):

```yaml
persistence:
  enabled: true
  type: custom
  mountPath: /data
  custom:
    nfs:
      server: nfs.example.com
      path: /exported/path
```

Note: When using `custom` type, you must provide the complete volume specification.

### CLI Options

```yaml
cli:
  debug: false
  quiet: false
  trace: false
  json: false
```

Configure command-line flags for the scanner.

### Environment Variables

The chart provides flexible options for adding environment variables to pod containers:

#### Using `extraEnvVars`

Add individual environment variables with direct values or references to ConfigMaps and Secrets:

```yaml
extraEnvVars:
  # Direct value
  - name: LOG_LEVEL
    value: "debug"
  
  # From ConfigMap key
  - name: CONFIG_VALUE
    valueFrom:
      configMapKeyRef:
        name: my-configmap
        key: config-key
        optional: false  # Optional: whether the ConfigMap/key must exist
  
  # From Secret key
  - name: API_KEY
    valueFrom:
      secretKeyRef:
        name: my-secret
        key: api-key
        optional: false  # Optional: whether the Secret/key must exist
```

#### Using `extraEnvVarsCM`

Load all key-value pairs from a ConfigMap as environment variables:

```yaml
extraEnvVarsCM: "my-configmap"
```

#### Using `extraEnvVarsSecret`

Load all key-value pairs from a Secret as environment variables:

```yaml
extraEnvVarsSecret: "my-secret"
```

**Note:** You can use both `extraEnvVars` (for individual variables) and `extraEnvVarsCM`/`extraEnvVarsSecret` (for bulk loading) together.

### Health Probes

```yaml
probe:
  initialDelaySeconds: 3
  periodSeconds: 3
```

Configure the liveness probe timing.

### Name Overrides

```yaml
nameOverride: ""
fullnameOverride: ""
```

Override the default naming convention for resources.

### Labels and Annotations

```yaml
# Common labels to add to all resources
commonLabels: {}
  # environment: production
  # team: security

# Common annotations to add to all resources
commonAnnotations: {}
  # prometheus.io/scrape: "true"
  # prometheus.io/port: "8080"

# Additional labels to add to pods
podLabels: {}
  # security-scan: enabled
  # pod-type: scanner

# Additional annotations to add to pods
podAnnotations: {}
  # prometheus.io/scrape: "true"
  # prometheus.io/port: "8080"
  # prometheus.io/path: "/metrics"
  # vault.hashicorp.com/agent-inject: "true"
  # vault.hashicorp.com/role: "trufflehog"
```

Add custom labels and annotations to resources or pods.

### Priority Class

```yaml
priorityClass:
  create: true
  name: ""                # Existing priority class to use if create is false
  value: 1000             # Priority value, only used if create is true
```

Configure pod priority. Set `create: false` and specify `name` to use an existing priority class.

### Taint Tolerations

```yaml
tolerations: []
```

Configure taint tolerations to allow pods to be scheduled on nodes with matching taints. This is useful for scheduling pods on dedicated nodes or nodes with specific taints.

Example:

```yaml
tolerations:
  - key: "key"
    operator: "Equal"
    value: "value"
    effect: "NoSchedule"
  - key: "dedicated"
    operator: "Exists"
    effect: "NoSchedule"
```

For more information on tolerations, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

### Security Context

```yaml
securityContext:
  # Pod-level security context
  pod:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
    fsGroup: 1000
  # Container-level security context
  container:
    runAsNonRoot: true
    runAsUser: 1000
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL
```

Configure pod and container security contexts for enhanced security.

## Examples

### Basic Installation with Custom Environment Variables

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: "info"
  - name: API_ENDPOINT
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: api-endpoint
```

### Using Secrets for Sensitive Data

```yaml
extraEnvVars:
  - name: DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: password
        optional: false
```

### Loading Multiple Variables from ConfigMap

```yaml
extraEnvVarsCM: "application-config"
```

This will load all key-value pairs from the `application-config` ConfigMap as environment variables.

## Troubleshooting

### Verify the Deployment

```bash
kubectl get pods -n trufflehog
kubectl logs -n trufflehog <pod-name>
```

### Check Configuration Secret

```bash
kubectl get secret config -n trufflehog -o yaml
```

### Verify Environment Variables

```bash
kubectl exec -n trufflehog <pod-name> -- env
```

## Uninstallation

To uninstall the Helm release:

```bash
helm uninstall trufflehog --namespace trufflehog
```

**Note:** This will not delete the namespace or the configuration secret. You may need to clean those up manually if desired.
