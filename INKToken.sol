pragma solidity ^0.4.18;


import "./MintableToken.sol";


contract INKToken is MintableToken {
    
    string public constant name = "INK Token";
    
    string public constant symbol = "INK";
    
    uint32 public constant decimals = 5;
    
    function buyTokens() external payable {
        obtainNewTokens(msg.sender, msg.value*10**decimals);
    }

}