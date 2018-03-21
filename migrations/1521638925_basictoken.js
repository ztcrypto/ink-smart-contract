var BasicTokenMock = artifacts.require("./BasicTokenMock.sol");

module.exports = function(deployer) {
  deployer.deploy(BasicTokenMock);
};
