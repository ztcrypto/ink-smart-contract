import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/mock/BasicTokenMock.sol";
import "../contracts/ThrowProxy.sol";

contract TestBasicToken {

  function testTransferToAddress() {
    BasicTokenMock base = BasicTokenMock(DeployedAddresses.BasicTokenMock());
    base.AddToken(this,300000);
    address destAddress = 0x3535353535353535353535353535353535353535;
    uint256 expected = 250000;
    base.transfer(destAddress, 250000);

    Assert.equal(base.balanceOf(destAddress), expected, "expected 250000 ink");
    Assert.equal(base.balanceOf(this), 50000, "expected 50000 ink");
  }

  function testTransferToZeroAddress() {
    BasicTokenMock base = BasicTokenMock(DeployedAddresses.BasicTokenMock());
    base.AddToken(this, 300000);
    address destAddress = 0x0000000000000000000000000000000000000000;

    ThrowProxy throwProxy = new ThrowProxy(address(base));
    BasicTokenMock(address(throwProxy)).transfer(destAddress, 250000);

    bool result = throwProxy.execute.gas(200000)();

    Assert.isFalse(result, "Should have threw exception");
  }

  function testTransferOverBalanceToAddress() {
    BasicTokenMock base = BasicTokenMock(DeployedAddresses.BasicTokenMock());
    address destAddress = 0x1111111111133333333311111111111111111111;

    ThrowProxy throwProxy = new ThrowProxy(address(base));
    BasicTokenMock(address(throwProxy)).transfer(destAddress, 750000);

    bool result = throwProxy.execute.gas(200000)();

    Assert.isFalse(result, "Should have threw exception");
  }

  function testTransferNothingToAddress() {
    BasicTokenMock base = BasicTokenMock(DeployedAddresses.BasicTokenMock());
    address destAddress = 0x3535353535353535353535353535353535353535;
    uint256 expected = 250000;
    base.transfer(destAddress, 0);

    Assert.equal(base.balanceOf(destAddress), expected, "expected 250000 ink");
  }

  function testTransferAllAvailableBalanceToAddress() {
    BasicTokenMock base = BasicTokenMock(DeployedAddresses.BasicTokenMock());
    address destAddress = 0x1111111111133333333311111111111111111111;
    uint256 expected = 350000;
    base.transfer(destAddress, base.balanceOf(this));

    Assert.equal(base.balanceOf(destAddress), expected, "expected 350000 ink");
  }

  function testTransferWithZeroBalanceToAddress() {
    BasicTokenMock base = BasicTokenMock(DeployedAddresses.BasicTokenMock());
    address destAddress = 0x1111111111133333333311111111111111111111;
    uint256 expected = 350000;

    ThrowProxy throwProxy = new ThrowProxy(address(base));
    BasicTokenMock(address(throwProxy)).transfer(destAddress, 50000);

    bool result = throwProxy.execute.gas(200000)();

    Assert.isFalse(result, "Should have threw exception");
    Assert.equal(base.balanceOf(destAddress), expected, "expected 350000 ink");
  }

}