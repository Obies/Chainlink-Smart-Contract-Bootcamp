//SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;

//First smart contract to be deployed
contract MyFirstContract{
    uint256 number;
    string[] names;
    mapping (string => uint) public phoneNumbers;

//Function takes name and mobile number
    function addMobileNumber(string memory _name, uint _mobileNumber) public{
        phoneNumbers[_name] = _mobileNumber;
    }

    function getMobileNumber(string memory _name) public view returns(uint){
        return phoneNumbers[_name];
    }
    
//Functions adds names to Array and second function prints them out according to index
    function addNames(string memory _name) public {
        names.push(_name);
    }

    function getName(uint _index) public view returns(string memory){
        return names[_index];
    }
//Function accepts a number input from user
    function changeNumber(uint256 _num) public{
        number = _num;
    }

//Function returns _num for viewing
    function getNumber() public view returns(uint256){
        return number;
    }

}