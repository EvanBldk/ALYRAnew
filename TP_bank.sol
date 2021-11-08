// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Bank{
    
    mapping (address => uint) _balances ;

    function deposit (uint _amount) public { 
    
        uint amount = _amount;
        _balances[msg.sender] += amount;
    
    }
    
    function transfer (address _recipient, uint _amount) payable external{
                
        uint amount = _amount;
        require(_balances[msg.sender] >= amount, "transfer not possible, insufficient funds on your balance");
         _balances[msg.sender] -= amount;
         _balances[_recipient] += amount;
    }
    
    function balanceOf (address _address) public view returns (uint) {
        return _balances[_address];
    }
    
}