//SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3{
    AggregatorV3Interface internal priceFeed;
    /*
    Network: Kovan Test net-injected Provider picks up testnet used
    Aggregator: ETH/USD
    Address: 1st(ETH/USD):0x9326BFA02ADD2366b30bacB125260Af641031331
             2nd(LINK/USD):0x396c5E36DD0a0F5a5D33dae44368D4193f69a1F0 
    */
    constructor() public {
        priceFeed = AggregatorV3Interface(0x396c5E36DD0a0F5a5D33dae44368D4193f69a1F0);
    }
    /*
    Returns the latest price
    */
    function getLatestPrice() public view returns (int){
        (
        uint80 roundID,
        int price,
        uint startedAt,
        uint timeStamp,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}