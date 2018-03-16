pragma solidity ^0.4.18;


import "./MintableToken.sol";


contract INKToken is MintableToken {

    string public name;

    string public symbol;

    string public version;

    uint32 public decimals;

/*    bool private wasInitialized = false;

    function initialize() public {
       require(wasInitialized == false);
       name = "INK Token";
       symbol = "INK";
       version = "1.0";
       decimals = 5;
       totalSupply = 2**256 - 1;
       manager = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
       balances[manager] = totalSupply;
       wasInitialized = true;
    }*/

    function INKToken(){
        name = "INK Token";
        symbol = "INK";
        version = "1.0";
        decimals = 5;
        totalSupply = 2**256 - 1;
        manager = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
        balances[manager] = totalSupply;
    }
    
    function buyTokens() external payable {
        obtainNewTokens(msg.sender, msg.value*10**decimals);
    }

}