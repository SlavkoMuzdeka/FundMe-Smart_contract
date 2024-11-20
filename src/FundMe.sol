// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    error FundMe__NotOwner();
    error FundMe__NotEnoughETH();

    AggregatorV3Interface private dataFeed;

    address[] private s_funders;
    address private immutable i_owner;
    uint256 private constant MINIMUM_USD = 5;
    mapping(address => uint256) private s_addressToAmountFunded;

    constructor(address _dataFeed) {
        i_owner = msg.sender;
        dataFeed = AggregatorV3Interface(_dataFeed);
    }

    function fund() external payable {
        require(convertFundedValueToDollar(msg.value) >= MINIMUM_USD, FundMe__NotEnoughETH());
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(msg.sender == i_owner, FundMe__NotOwner());
        address[] memory funders = s_funders;
        for (uint256 index = 0; index < funders.length; index++) {
            address funder = funders[index];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address payable[](0);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    function getPrice() private view returns (uint256) {
        (, int256 answer,,,) = dataFeed.latestRoundData();
        return uint256(answer);
    }

    function convertFundedValueToDollar(uint256 ethValue) private view returns (uint256) {
        uint256 ethPriceInUsd = getPrice() / 10 ** dataFeed.decimals();
        return (ethValue * ethPriceInUsd) / 10 ** 18;
    }

    function getDataFeed() external view returns (AggregatorV3Interface) {
        return dataFeed;
    }

    function getAddressToAmountFunded(address addr) external view returns (uint256) {
        return s_addressToAmountFunded[addr];
    }

    function getFunder(uint256 indexOfFunder) external view returns (address) {
        return s_funders[indexOfFunder];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
