pragma solidity ^0.4.18;


import "./MintableToken.sol";


contract InkToken is MintableToken {

    string public name;

    string public symbol;

    string public version;

    uint32 public decimals;

    function InkToken() public{
        name = "INK Token";
        symbol = "INK";
        version = "1.0";
        decimals = 5;
        totalSupply = 2**256 - 1;
        manager = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
        freezingTime = 172800;
        balances[manager] = totalSupply;
    }
    
    function buyTokens() external payable {
        obtainNewTokens(msg.sender, msg.value*10**decimals);
    }

    function returnCoins() public returns (bool){
        return returnCore(msg.sender);
    }

    function changeManager(address newManager) onlyManager public {
      require(newManager != address(0));
      transfer(newManager, balances[manager]);
      ManagerChanged(manager, newManager);
      manager = newManager;
    }

}