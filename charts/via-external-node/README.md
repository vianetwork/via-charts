# VIA Network External Node Chart

The VIA Network node is a read-replica of the main node that can be run by external parties.


## Prerequisites

- Kubernetes 1.19+
- Helm 3+

## Usage

The chart is distributed as an [OCI Artifact](https://helm.sh/docs/topics/registries/) as well as via a traditional [Helm Repository](https://helm.sh/docs/topics/chart_repository/).

- OCI Artifact: `oci://ghcr.io/vianetwork/charts/via-external-node`
- Helm Repository: `https://vianetwork.github.io/via-charts` with chart `via-external-node`

The installation instructions use the OCI registry. Refer to the [`helm repo`]([`helm repo`](https://helm.sh/docs/helm/helm_repo/)) command documentation for information on installing charts via the traditional repository.

### Install Helm Chart

```console
helm install [RELEASE_NAME] oci://ghcr.io/vianetwork/charts/via-external-node
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

### Dependencies

By default this chart requires additional, dependent charts:

- [vianetwork/common](https://github.com/vianetwork/via-charts/tree/main/charts/common)


_See [helm dependency](https://helm.sh/docs/helm/helm_dependency/) for command documentation._


### Uninstall Helm Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

### Upgrading Chart

```console
helm upgrade [RELEASE_NAME] [CHART]
```

## Configuration

### Prerequisites

The node requires the following versions:

- PostgreSQL: 16.11
- Bitcoin Core: v29.1

### Database setup

During startup, the node automatically executes schema migrations. By default, the node will attempt to create the database if it does not exist.
This requires the database user to have broad "Create Database" permissions.

To avoid privilege, we recommend creating the database manually beforehand. 
This allows you to grant the node full permissions only for that specific database, avoiding the need for elevated administrative privileges.

### Bitcoin Node Synchronization

The Bitcoin node must be fully synchronized with the network (testnet4 or mainnet) for the VIA external node to function correctly. 
Initial synchronization may take a significant amount of time (2 hours).

Once the Bitcoin node is synced, set the `VIA_BTC_CLIENT_RPC_URL` variable to its address. 
Below is an example configuration for connecting to a Bitcoin node running within the same cluster in the bitcoin namespace on the testnet4 network:

```yaml
configmap:
  config:
    enabled: true
    nameOverride: "config"
    data: # testnet configuration
      ...
      VIA_BTC_CLIENT_NETWORK: "testnet4"
      VIA_BTC_CLIENT_RPC_URL: "http://bitcoin-internal.bitcoin.svc.cluster.local:48332"
```

### Secret Configuration

Sensitive credentials must be stored in a Kubernetes Secret. Below is an example using placeholder values:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: via-external-node
type: Opaque
stringData:
  DATABASE_URL: "postgres://postgres:notsecurepassword@postgres:5432/via_ext_node_testnet" 
  VIA_BTC_CLIENT_RPC_USER: "rpcuser"  # The RPC username for the Bitcoin node  
  VIA_BTC_CLIENT_RPC_PASSWORD: "rpcpassword" # The RPC password for the Bitcoin node
```

Reference the created Secret in your Helm chart values as follows:

```yaml
envFrom:
  - secretRef:
      name: via-external-node
```