pragma solidity ^0.4.18;


import "../token/StandardToken.sol";

contract StandardTokenMock is StandardToken {
	function addTokenandApprove(address _initaddress, uint256 _initamount, uint256 _value) public{
		balances[_initaddress] += _initamount;
		totalSupply += _initamount;
		allowed[_initaddress][msg.sender] = _value; 
		Approval(_initaddress, msg.sender, _value);
	}
}
