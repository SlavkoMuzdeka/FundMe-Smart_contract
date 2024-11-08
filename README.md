# FundMe

The **FundMe** smart contract is a decentralized crowdfunding application built on Ethereum. This project includes the smart contract code, deployment script, helper configuration, and test suite.

## Project Structure

- **`FundMe.sol`**: Core contract implementing funding and withdrawal functions. It verifies the minimum funding threshold based on real-time ETH/USD prices fetched from Chainlink's price feed.

- **`FundMe.s.sol`**: Deployment script for the `FundMe` contract, utilizing `HelperConfig` to select the appropriate price feed address.
  
- **`HelperConfig.sol`**: Configures data feeds for different networks and deploys a mock aggregator for local testing.
  
- **`FundMe.t.sol`**: Test suite containing unit tests to validate contract functionalities.

## Requirements

- Solidity `0.8.28`
- Chainlink price feed
- [Foundry](https://book.getfoundry.sh/) for compiling and testing
- [Chainlink](https://docs.chain.link/) for price feed integration

## Setup

1. Clone the repository and install dependencies.
2. Set up Foundry (if not already installed):

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```


## Makefile

A `Makefile` is included to streamline commands for cleaning, building, testing, updating, formatting, deployment, and more. You can use it to execute tasks without needing to remember specific commands. Just run the command you need like this:

```bash
make <command>
```

The `Makefile` defines the following commands for quick project management:

- **`all`**: Runs **`clean`**, **`remove`**, **`install`**, **`update`**, and **`build`** in sequence.

- **`clean`**: Cleans up build artifacts.

- **`remove`**: Clears Git submodules and libraries, then commits the changes.

- **`install`**: Installs required packages without committing.
  
- **`update`**: Updates dependencies.

- **`build`**: Compiles the contracts.
  
- **`test-anvil`**: Runs tests in a local Anvil environment.

- **`test-sepolia`**: Runs tests on Sepolia fork using `SEPOLIA_RPC_URL`.

- **`snapshot`**: Generates a snapshot of contract states.

- **`format`**: Formats code according to standards.

- **`coverage`**: Runs code coverage.

- **`deploy-anvil`**: Deploys contract locally using Anvil.

- **`deploy-sepolia`**: Deploys contract to Sepolia network with verification on Etherscan.

## Notes
This project was developed as part of the `Cyfrin Updraft` course, focusing on `Solidity` and `Ethereum` smart contracts.