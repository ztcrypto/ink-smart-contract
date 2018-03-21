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

	function newFreezingtime(){
		freezingTime = 0;
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