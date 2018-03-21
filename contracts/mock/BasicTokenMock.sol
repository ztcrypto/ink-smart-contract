pragma solidity ^0.4.18;


import "../token/BasicToken.sol";


contract BasicTokenMock is BasicToken {
    
  function AddToken(address _initaddress, uint256 _initamount) public {
    balances[_initaddress] += _initamount;
    totalSupply += _initamount;
  }
}
