// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {HelperConfig} from "./HelperConfig.sol";

contract FundMeScript is Script {
    function run() external {
        deployFundMe();
    }

    function deployFundMe() public returns (FundMe, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        address dataFeed = helperConfig
            .getConfigByChainId(block.chainid)
            .dataFeed;

        vm.startBroadcast();
        FundMe fundMe = new FundMe(dataFeed);
        vm.stopBroadcast();

        return (fundMe, helperConfig);
    }
}
