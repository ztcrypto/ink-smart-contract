var BasicTokenMock = artifacts.require("../mock/BasicTokenMock.sol");

module.exports = function(deployer) {
  deployer.deploy(BasicTokenMock);
};
