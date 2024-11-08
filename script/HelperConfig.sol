// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console2} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

abstract contract CodeConstants {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    uint256 public constant LOCAL_CHAIN_ID = 31337;
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
}

contract HelperConfig is Script, CodeConstants {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address dataFeed;
    }

    NetworkConfig public localNetworkConfig;

    function getConfigByChainId(uint256 chainId) external returns (NetworkConfig memory) {
        if (chainId == ETH_SEPOLIA_CHAIN_ID) {
            return getEthSepoliaConfig();
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateEthAnvilConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getEthSepoliaConfig() private pure returns (NetworkConfig memory) {
        return NetworkConfig({
            dataFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Ethereum Sepolia ETH/USD
        });
    }

    function getOrCreateEthAnvilConfig() private returns (NetworkConfig memory) {
        if (localNetworkConfig.dataFeed != address(0)) {
            return localNetworkConfig;
        }

        console2.log("You have deployed a mock contract!");
        console2.log("Make sure this was intentional");

        vm.startBroadcast();
        MockV3Aggregator mockDataFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig({dataFeed: address(mockDataFeed)});
        return localNetworkConfig;
    }
}
