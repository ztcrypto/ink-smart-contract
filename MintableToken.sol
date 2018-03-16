pragma solidity ^0.4.18;


import "./StandardToken.sol";
import "./Managed.sol";

contract MintableToken is StandardToken, Managed {
    
  event Mint(address indexed to, uint256 amount, uint256 time);
  
  struct TimeValue{
      uint256 time;
      uint256 amount;
  }
  
  struct timeVector{
      uint256 index;
      TimeValue[] vect;
  }
  
  mapping(address => timeVector) pledge;
  
  function mint(address _to, uint256 _amount) private returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount, now);
    return true;
  }
  
  function buyTokens() external payable {
    require(mint(msg.sender, msg.value) == true);
    pledge[msg.sender].vect.push(TimeValue({time :now, amount: msg.value}));
  }
  
  function transferBackTokens(address _to, uint256 _amount) private{
    _to.send(_amount);
  }
  
  function returnTokens(address _owner) returns (bool){
    for(uint256 i = pledge[_owner].index; i < pledge[_owner].vect.length; i++){
        if(pledge[_owner].vect[i].time + 172800 < now){
            transferBackTokens(_owner, pledge[_owner].vect[i].amount);
            delete pledge[_owner].vect[i];
            pledge[_owner].index = i + 1;
        }
        else {
            break;
        }
    }
    return true;
  }
 
}