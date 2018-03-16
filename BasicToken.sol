pragma solidity ^0.4.18;


import "./ERC20.sol";
import "./SafeMath.sol";


contract BasicToken is ERC20Basic {
  using SafeMath for uint256;
 
  mapping(address => uint256) balances;
 

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]); 
    balances[msg.sender] = balances[msg.sender].sub(_value); 
    balances[_to] = balances[_to].add(_value); 
    Transfer(msg.sender, _to, _value); 
    return true; 
  } 
 

  function balanceOf(address _owner) public constant returns (uint256) { 
    return balances[_owner]; 
  } 
} 