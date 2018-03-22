import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/mock/StandardTokenMock.sol";
import "../contracts/ThrowProxy.sol";

contract TestStandardToken{

	function testApprove(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		address newAddress = 0x3535353535353535353535353535353535353535;
		uint256 expected = 50000000;

		std.approve(newAddress, 50000000);
		Assert.equal(std.allowance(this, newAddress), expected, "Wrong allowed balance.");
	}

	function testIncreaseApprove(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		address newAddress = 0x2525252525252525252525252525252525252525;
		uint256 expected = 100000000;

		std.approve(newAddress, 50000000);
		std.increaseApproval(newAddress, 50000000);
		Assert.equal(std.allowance(this, newAddress), expected, "Wrong allowed balance.");
	}

	function testDecreaseApprove(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		address newAddress = 0x1515151515151515151515511515151515151551;
		uint256 expected = 30000000;

		std.approve(newAddress, 50000000);
		std.decreaseApproval(newAddress, 20000000);
		Assert.equal(std.allowance(this, newAddress), expected, "Wrong allowed balance.");
	}

	function testOverDecreaseApprove(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		address newAddress = 0x1313131313131313131313131313131131311313;
		uint256 expected = 0;

		std.approve(newAddress, 50000000);
		std.decreaseApproval(newAddress, 70000000);
		Assert.equal(std.allowance(this, newAddress), expected, "Wrong allowed balance.");
	}

	function testTransferFrom(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		address newAddress = 0x1111111111111111111111111111111111111111;
		uint256 expected = 20000000;

		std.addTokenandApprove(newAddress, 100000000, 50000000);
		std.transferFrom(newAddress,this, 20000000);

		Assert.equal(std.balanceOf(this), expected, "Wrong allowed balance.");

	}

	function testTransferFromWithBadApprove(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		ThrowProxy throwProxy = new ThrowProxy(address(std));
		address newAddress = 0x1111111111111111111111111111111111111111;

		std.addTokenandApprove(newAddress, 100000000, 50000000);

		StandardTokenMock(throwProxy).transferFrom(newAddress,this, 70000000);

		bool result = throwProxy.execute.gas(200000)();

		Assert.isFalse(result, "Should be false");
	}

	function testTransferFromWithBadBalance(){
		StandardTokenMock std = StandardTokenMock(DeployedAddresses.StandardTokenMock());
		ThrowProxy throwProxy = new ThrowProxy(address(std));
		address newAddress = 0x1111111111111111111111111111111111111111;

		std.addTokenandApprove(newAddress, 100000000, 200000000);

		StandardTokenMock(throwProxy).transferFrom(newAddress,this, 150000000);

		bool result = throwProxy.execute.gas(200000)();

		Assert.isFalse(result, "Should be false");
	}
}