var InkTokenMock = artifacts.require("./mock/InkTokenMock.sol");

module.exports = function(deployer) {
  deployer.deploy(InkTokenMock);
};
