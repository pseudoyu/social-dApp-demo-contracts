# foundry-starter-kit

## Usage

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Deploy

```bash
# delloy local anvil
# change CHAIN_ID in .env to 31337
# change RPC_URL in .env to http://localhost:8545
make deploy-anvil

# deploy sepolia
# change CHAIN_ID in .env to 11155111
# config all other env variables
make deploy-sepolia
make deploy-sepolia-no-verify
```
