import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/mock/InkTokenMock.sol";
import "../contracts/ThrowProxy.sol";

contract TestStructureInkToken {

  uint256 public initialBalance = 20 wei;


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

  function testRefreezingAllCoins() {
    InkTokenMock ink = new InkTokenMock();

    ink.newFreezingtime();

    ink.call.value(4 wei)(bytes4(sha3("buyTokens()")));
    ink.call.value(3 wei)(bytes4(sha3("buyTokens()")));
    ink.call.value(1 wei)(bytes4(sha3("buyTokens()")));

    bool result = ink.returnCoins();
    Assert.isTrue(result, "Should be true");

    Assert.equal(ink.getPledgeIndex(), 3, "index should be 3");
    Assert.equal(ink.getLastAmount(), 0, "amount should be 0");

    ink.call.value(3 wei)(bytes4(sha3("buyTokens()")));
    ink.call.value(1 wei)(bytes4(sha3("buyTokens()")));

    result = ink.returnCoins();
    Assert.isTrue(result, "Should be true");
    
    Assert.equal(ink.getPledgeIndex(), 5, "Wrong index in array. Index should be 5");
    Assert.equal(ink.getLastAmount(), 0, "amount should be 0");

  }

  function testRefreezingHalfCoins() {
    InkTokenMock ink = new InkTokenMock();
    uint256 twoDaysLater = 172800;

    ink.call.value(4 wei)(bytes4(sha3("buyTokens(uint256)")), now);
    ink.call.value(3 wei)(bytes4(sha3("buyTokens(uint256)")), now + 30);
    ink.call.value(1 wei)(bytes4(sha3("buyTokens(uint256)")), now + 100);
    ink.call.value(2 wei)(bytes4(sha3("buyTokens(uint256)")), now + 150);

    bool result = ink.returnCoins(now + 30 + twoDaysLater);
    Assert.isTrue(result, "Should be true");

    Assert.equal(ink.getPledgeIndex(), 2, "Wrong index in array. Index should be 2");
    Assert.equal(ink.getLastAmount(), 2, "Wrong array amount. Should be 2");
    Assert.equal(this.balance, 12, "Wrong balance. Balance should be 17 wei");

    ink.call.value(2 wei)(bytes4(sha3("buyTokens(uint256)")), now + 270);
    ink.call.value(6 wei)(bytes4(sha3("buyTokens(uint256)")), now + 330);

    result = ink.returnCoins(now + 300 + twoDaysLater);
    Assert.isTrue(result, "Should be true");

    Assert.equal(ink.getPledgeIndex(), 5, "Wrong index in array. Index should be 5");
    Assert.equal(ink.getLastAmount(), 6, "Wrong array amount. Should be 6");
    Assert.equal(this.balance, 9, "Wrong balance. Balance should be 6 wei");
  }

  function () payable {

  }
}