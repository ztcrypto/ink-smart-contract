import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/mock/InkTokenMock.sol";
import "../contracts/ThrowProxy.sol";

contract TestInkToken {

  uint256 public initialBalance = 20 wei;

  function testInitialBalance() {
    InkTokenMock ink = InkTokenMock(DeployedAddresses.InkTokenMock());

    uint256 expected = 2**256-1;
    address manageAddress = ink.manager();

    Assert.equal(ink.balanceOf(manageAddress), expected, "Manager should have 2**256 InkCoin initially");
    Assert.equal(ink.totalSupply(), expected, "TotalSupply have to be 2**256 InkCoin initially");
  }

  function testBalanceBuyingTokens() {
    InkTokenMock ink = InkTokenMock(DeployedAddresses.InkTokenMock());

    ink.call.value(5 wei)(bytes4(sha3("buyTokens()")));
    Assert.equal(ink.balanceOf(this), 500000, "Balance have to be 500000 ink");

    ink.call.value(110 wei)(bytes4(sha3("buyTokens()")));
    Assert.equal(ink.balanceOf(this), 500000, "Balance have to be 500000 ink");

    ink.call.value(0 wei)(bytes4(sha3("buyTokens()")));
    Assert.equal(ink.balanceOf(this), 500000, "Balance have to be 500000 ink");

    Assert.equal(this.balance, 15 wei, "should have 5 ether after execute this test");

  }

  function testPledgeVectorBuyingTokens() {
    InkTokenMock ink = new InkTokenMock();

    ink.call.value(4 wei)(bytes4(sha3("buyTokens()")));
    Assert.equal(ink.getLastAmount(), 4, "PledgeAmount have to be 4 ether");

    ink.call.value(150 wei)(bytes4(sha3("buyTokens()")));
    Assert.equal(ink.getLastAmount(), 4, "PledgeAmount have to be 4 ether");

    ink.call.value(0 wei)(bytes4(sha3("buyTokens()")));
    Assert.equal(ink.getLastAmount(), 4, "PledgeAmount have to be 4 ether");

    ink.call.value(1 wei)(bytes4(sha3("buyTokens()")));

    Assert.equal(ink.getLastElementNumber(), 2, "Array should have 2 elements");
    Assert.equal(ink.getPledgeIndex(), 0, "Index should have 0 element");
    Assert.equal(ink.getLastAmount(), 1, "PledgeAmount have to be 1 ether");

  }

  function testChangeManager() {
    InkTokenMock ink = InkTokenMock(DeployedAddresses.InkTokenMock());
    ThrowProxy throwProxy = new ThrowProxy(address(ink));
    address newManager = 0x3535353535353535353535353535353535353535;

    InkTokenMock(address(throwProxy)).changeManager(newManager);
    bool result = throwProxy.execute.gas(200000)();

    Assert.isFalse(result, "Should be false");

    InkTokenMock myInk = new InkTokenMock();
    throwProxy.retarget(address(myInk));

    InkTokenMock(address(throwProxy)).changeManager(0x0000000000000000000000000000000000000000);
    result = throwProxy.execute.gas(200000)();

    Assert.isFalse(result, "Should be false");

    myInk.changeManager(newManager);

    Assert.equal(myInk.balanceOf(newManager), myInk.totalSupply(), "Manager should have 2**256 InkCoin initially");
  }

  function testNonReturnCoin() {
    InkTokenMock ink = new InkTokenMock();

    ink.call.value(4 wei)(bytes4(sha3("buyTokens()")));

    bool result = ink.returnCoins();
    Assert.isFalse(result, "Should be false");
  }

  function testReturnCoin() {
    InkTokenMock ink = InkTokenMock(DeployedAddresses.InkTokenMock());

    ink.newFreezingtime();

    ink.call.value(4 wei)(bytes4(sha3("buyTokens()")));
    ink.call.value(3 wei)(bytes4(sha3("buyTokens()")));
    ink.call.value(1 wei)(bytes4(sha3("buyTokens()")));

    bool result = ink.returnCoins();
    Assert.isTrue(result, "Should be true");
    Assert.equal(ink.getPledgeIndex(), 3, "index should be 2");
    Assert.equal(ink.getLastAmount(), 0, "amount should be 0");

  }
}
