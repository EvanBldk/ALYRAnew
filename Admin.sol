// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Admin is Ownable{
    
    
    mapping(address => bool)whitelisted;
    mapping(address => bool)blacklisted;
    
    event Whitelisted(address indexed _address);
    event Blacklisted(address indexed _address);
    

    
    function whitelist(address _address)public onlyOwner{
        whitelisted[_address] = true;
        blacklisted[_address] = false;
        emit Whitelisted(_address);


    }
    
    function blacklist(address _address)public onlyOwner{        
        blacklisted[_address] = true;
        whitelisted[_address] = false;
        emit Blacklisted(_address);

    }
    
    function isWhitelisted(address _address)public view returns (bool){
    return whitelisted[_address];
    }
    
     function isBlacklisted(address _address)public view returns (bool){
    return blacklisted[_address];
    }
}    