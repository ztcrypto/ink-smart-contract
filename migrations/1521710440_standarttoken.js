var StandardTokenMock = artifacts.require("../mock/StandardTokenMock.sol");

module.exports = function(deployer) {
  deployer.deploy(StandardTokenMock);
};
