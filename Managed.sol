pragma solidity ^0.4.18;

contract Managed {
  address public manager;
 
  event ManagerChanged(address indexed previousManager, address indexed newManager);
 
  modifier onlyManager() {
    require(msg.sender == manager);
    _;
  }
 
  function changeManager(address newManager) onlyManager public {
    require(newManager != address(0));
    ManagerChanged(manager, newManager);
    manager = newManager;
  }
 
}