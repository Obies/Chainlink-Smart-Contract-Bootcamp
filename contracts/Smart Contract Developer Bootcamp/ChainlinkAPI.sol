//SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;

//import Chainlink library
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient{
    uint256 public volume;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    /*
    Network: Kovan test network
    Chainlink oracle- 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
    Chainlink jobId from chainlink market- 29fa9aa13bf1468788b7cc4a500a45b8
    Fee: 0.1 LINK
    */
    constructor() public {
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10 ** 18; //API fee is 0.1 LINK
    }

/**
* Create a Chainlink request to retrieve API response,
find the target
* data, then multiply by 1000000000000000000 (to remove
decimal places from data).
***************************************************************
*********************
* STOP!
*
* THIS FUNCTION WILL FAIL IF THIS CONTRACT DOES
NOT OWN LINK *
*
----------------------------------------------------------
*
* Learn how to obtain testnet LINK and fund this
contract: *
* -------
https://docs.chain.link/docs/acquire-link --------
*
* ----
https://docs.chain.link/docs/fund-your-contract -----
*
*
*
35
***************************************************************
*********************/

//Two functions below: request and fulfill
    function requestVolumeData() public returns (bytes32 requestId){
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

    //Set the URL to perform the GET request on
    request.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");

    //Set the path to find the desired data in the API response, where the response format is:
    //{"RAW":
    //  {"ETH";
    //      {"USD";
    //          {
    //              ...,
    //              "VOLUME24HOURS": xxx.xxx;
    //              ...
    //          }
    //      }
    //  }
    //}

    request.add("path", "RAW.ETH.USD.VOLUME24HOUR");

    //Multiply the result by 100000000 to remove decimals
    int timesAmount = 10 ** 18;
    request.addInt("times", timesAmount);

    //sends the request
    return sendChainlinkRequestTo(oracle, request, fee);          
    }
    /*
    Receive the response in the form of uint256
    */
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId){
        volume = _volume;
    }
    /*
    Withdraw LINK from this contract
    NOTE: DO NOT USE IN PRODUCTION AS ANY ADDRESS CAN CALL IT.
    THIS IS PURELY FOR EXAMPLE PURPOSES ONLY
    */
    function withdrawLink() external{
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer") ;
    }
}