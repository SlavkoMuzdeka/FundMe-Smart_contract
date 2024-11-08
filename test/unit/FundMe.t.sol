// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundMeScript} from "../../script/FundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.sol";

contract FundMeTest is Test {
    uint256 public constant SEND_VALUE = 0.0025 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    address public FUNDER = makeAddr("funder");

    FundMe private fundMe;
    HelperConfig private helperConfig;

    modifier funded() {
        vm.prank(FUNDER);
        fundMe.fund{value: SEND_VALUE}();
        assert(address(fundMe).balance > 0);
        _;
    }

    function setUp() external {
        FundMeScript fundMeScript = new FundMeScript();
        (fundMe, helperConfig) = fundMeScript.deployFundMe();

        vm.deal(FUNDER, STARTING_USER_BALANCE);
    }

    function testDataFeedSetCorrectly() external {
        address realDataFeed = address(fundMe.getDataFeed());
        address expectedDataFeed = helperConfig
            .getConfigByChainId(block.chainid)
            .dataFeed;
        assert(realDataFeed == expectedDataFeed);
    }

    function testFundFailsWithoutEnoughEth() external {
        vm.expectRevert(FundMe.FundMe__NotEnoughETH.selector);
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() external funded {
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(FUNDER);
        assert(fundedAmount == SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() external funded {
        address funder = fundMe.getFunder(0);
        assert(FUNDER == funder);
    }

    function testOnlyOwnerCanWithdraw() external {
        vm.expectRevert(FundMe.FundMe__NotOwner.selector);
        vm.prank(makeAddr("new player"));
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() external funded {
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assert(endingFundMeBalance == 0);
        assert(
            endingOwnerBalance == (startingOwnerBalance + startingFundMeBalance)
        );
    }

    function testWithdrawFromAMultipleFunders() external {
        uint160 numOfFunders = 10;
        for (uint160 index = 1; index <= numOfFunders; index++) {
            hoax(address(index), STARTING_USER_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }
}
