# Server Initialization Scripts for Nodes

We provide Initialization scripts for Nodes. You can prepare your server while installation from provider.

## Tested systems

- [Ubuntu 20.04 LTS (Focal Fossa)](https://releases.ubuntu.com/20.04/)
- [Ubuntu 18.04 LTS (Bionic Beaver)](https://releases.ubuntu.com/18.04/)

## Execution directly from a URL

```shell
bash <(curl -Ls https://raw.githubusercontent.com/core-coin/server-init/master/scripts/init-node-boid-docker.sh)
```

## Scripts versions

You can use different levels of script files.

<dl>
  <dt>init-node-boid.sh</dt>
  <dd>Basic version without Docker</dd>
  <dt>init-node-boid-strict.sh</dt>
  <dd>Extended security without Docker</dd>
  <dt>init-node-boid-docker.sh</dt>
  <dd>Basic version with Docker</dd>
  <dt>init-node-boid-docker-strict.sh</dt>
  <dd>Extended security with Docker</dd>
  <dt>install-docker.sh</dt>
  <dd>Self-standing Docker installation script</dd>
</dl>
