pragma solidity ^0.4.18;


import "./StandardToken.sol";
import "./Managed.sol";

contract MintableToken is StandardToken, Managed {
    
  event Mint(address indexed to, uint256 amount, uint256 time);
  
  struct PledgeData{
      uint256 time;
      uint256 amount;
  }
  
  struct PledgeVector{
      uint256 index;
      PledgeData[] vect;
  }
  
  mapping(address => PledgeVector) pledge;
  
  function obtainNewTokens(address _to, uint256 _amount) internal returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    pledge[msg.sender].vect.push(PledgeData({time :now, amount: msg.value}));
    Mint(_to, _amount, now);
    return true;
  }
  
  function returnCore(address _pledgor) public returns (bool) {
    for(uint256 i = pledge[_pledgor].index; i < pledge[_pledgor].vect.length; i++){
        if(pledge[_pledgor].vect[i].time + 172800 < now){
            _pledgor.send(pledge[_pledgor].vect[i].amount);
            delete pledge[_pledgor].vect[i];
            pledge[_pledgor].index = i + 1;
        }
        else {
            break;
        }
    }
    return true;
  }
 
}