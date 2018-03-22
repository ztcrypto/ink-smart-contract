pragma solidity ^0.4.18;


import "../token/InkToken.sol";


contract InkTokenMock is InkToken {

	function InkTokenMock() public {
		freezingTime = 172800;
		manager = msg.sender;
    decimals = 5;
    totalSupply = 2**256 - 1;
    balances[manager] = totalSupply;
	}

	function newFreezingtime() public {
		freezingTime = 0;
	}

  function obtainNewTokens(address _to, uint256 _amount, uint256 _time) internal returns (bool) {
    require(_amount != 0);
    balances[manager] = balances[manager].sub(_amount);
    balances[_to] = balances[_to].add(_amount);
    pledge[msg.sender].vect.push(PledgeData({time :_time, amount: msg.value}));
    Obtain(_to, _amount, _time);
    return true;
  }
  
  function returnCore(address _pledgor, uint256 _time) internal returns (bool) {
    bool result = false;
    for(uint256 i = pledge[_pledgor].index; i < pledge[_pledgor].vect.length; i++){
        if(pledge[_pledgor].vect[i].time + freezingTime <= _time){
            _pledgor.send(pledge[_pledgor].vect[i].amount);
            result = true;
            Return(_pledgor,pledge[_pledgor].vect[i].amount);
            delete pledge[_pledgor].vect[i];
            pledge[_pledgor].index = i + 1;
        }
        else {
            break;
        }
    }
    return result;
  }

  function buyTokens(uint256 _time) external payable {
      obtainNewTokens(msg.sender, msg.value*10**decimals, _time);
  }

  function returnCoins(uint256 _time) public returns (bool){
      return returnCore(msg.sender, _time);
  }
    
  function getPledgeIndex() public constant returns (uint256) {
    return pledge[msg.sender].index;
  }

  function getLastAmount() public constant returns (uint256) {
    return pledge[msg.sender].vect[pledge[msg.sender].vect.length-1].amount;
  }

  function getLastElementNumber() public constant returns (uint256) {
    return pledge[msg.sender].vect.length;
  }

}