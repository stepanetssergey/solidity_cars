const truffleAssert = require('truffle-assertions');
const CarSalonNFT = artifacts.require("CarSalonNFT");
const BuyCars = artifacts.require("BuyCars");
const BT = artifacts.require("ERC20");

contract("BuyCars", (accounts) => {
  it ("Add minter to token", async () => {
    const bt = await BT.deployed();
    const buyCars = await BuyCars.deployed();
    await bt.addMinter(buyCars.address);
    const minter = await bt.Minters(buyCars.address);

    assert.equal(minter, true, "Not correct minter")
  })

  it ("Add accounter", async () => {
    const buyCars = await BuyCars.deployed();
    await buyCars.addAccounter(accounts[6]);
    const accounter = await buyCars.accounter();

    assert.equal(accounter, accounts[6], "Not correct accounter")
  })

  it("Is bonus token address presented", async () => {
    const buyCars = await BuyCars.deployed();
    const bt = await BT.deployed();

    const bonusTokenAddress = await buyCars.bonusTokenAddress();
    assert.equal(bonusTokenAddress, bt.address, "Address is not correct");
  });

  it("Add cars", async () => {
    const buyCars = await BuyCars.deployed();

    await buyCars.addCar("VW", "Passat", 150000);
    const currCar = await buyCars.Cars(1);
    assert.equal(currCar.brand, "VW", "Brand err");
    assert.equal(currCar.model, "Passat", "Model err");
    assert.equal(currCar.price, 150000, "Price err");
  });

  it("Add cars not owner", async () => {
    const buyCars = await BuyCars.deployed();
    await truffleAssert.reverts(buyCars.addCar("VW", "Passat", 150000, {from: accounts[1]}), "Only owner")
  });

  it("Add user", async () => {
    const buyCars = await BuyCars.deployed();
    await buyCars.addUser("John", accounts[5]);
    const currUser = await buyCars.Users(accounts[5]);

    assert.equal(currUser.name,"John", "Name wrong")
    assert.equal(currUser.tokens, 0, "Tkn wrong")
  });

  it("Add user not owner", async () => {
    const buyCars = await BuyCars.deployed();
    await truffleAssert.reverts(buyCars.addUser("John", accounts[5], {from: accounts[1]}), "Only owner");
  });

  it("Add order", async () => {
    const buyCars = await BuyCars.deployed();
    await buyCars.createOrder(1,1);
    const currOrder = await buyCars.Orders(1);

    assert.equal(currOrder.userID, 1 , "userID err");
    assert.equal(currOrder.carID, 1 , "carID err");
    assert.equal(currOrder.active, true , "active err");
    assert.equal(currOrder.tokens, 1500 , "tkns err");

  });

  it("Check user's BT balance", async () => {
    const bt = await BT.deployed();
    const balance = await bt.balanceOf(accounts[5]);
    let checkBlnc = web3.utils.toBN(1500);
    let checkBlncBN = web3.utils.toWei(checkBlnc)
    assert.equal(BigInt(balance), BigInt(checkBlncBN), "Not correct blnc")
  });

  it("Create service order", async () => {
    const buyCars = await BuyCars.deployed();
    await buyCars.createServiceOrder(accounts[5], 1000);

    const currSO = await buyCars.ServicesOrders(1);
    assert.equal(currSO.userAddress, accounts[5],  "User addr err" );
    assert.equal(currSO.price, 1000,  "Price err" );
  });

  it("Bonus token approve", async () => {
    const bt = await BT.deployed();
    const buyCars = await BuyCars.deployed();
    let sum = web3.utils.toWei(web3.utils.toBN(1000));
    await bt.approve(buyCars.address, sum, {from: accounts[5]});

    const allow = await bt.allowance(accounts[5], buyCars.address);
    assert.equal(BigInt(allow), BigInt(sum), "Sum is not approved");
  });

  it("Init TS", async () => {
    const bt = await BT.deployed();
    let sum = web3.utils.toWei(web3.utils.toBN(1500));
    const totalSupp = await bt.totalSupply();
    assert.equal(BigInt(totalSupp), BigInt(sum), "Not correct init TS");
  })

  it("Service order payment", async () => {
    const bt = await BT.deployed();
    const buyCars = await BuyCars.deployed();

    let sum = web3.utils.toWei(web3.utils.toBN(1000));
   
    await buyCars.payByTokens(1,{from: accounts[5]});
    const accBal = await bt.balanceOf(accounts[6]);
    assert.equal(BigInt(accBal), BigInt(sum), "Service order payment err");
    const user = await buyCars.Users(accounts[5]);
    assert.equal(user.tokens, 500, "Payment err");
  });

  it("Create service order 2", async () => {
    const buyCars = await BuyCars.deployed();
    await buyCars.createServiceOrder(accounts[5], 1000);

    const currSO = await buyCars.ServicesOrders(2);
    assert.equal(currSO.userAddress, accounts[5],  "User addr err" );
    assert.equal(currSO.price, 1000,  "Price err" );
  });

  it("Service order payment err", async () => {
    const bt = await BT.deployed();
    const buyCars = await BuyCars.deployed();

    let sum = web3.utils.toWei(web3.utils.toBN(1000));
    await truffleAssert.reverts(buyCars.payByTokens(2,{from: accounts[5]}));
    
  });

  it("Check deploy collection CarSalonNFT", async () => {
     const carsalonnft = await CarSalonNFT.deployed()
     const nameNFT = await carsalonnft.name()
     const symbol = await  carsalonnft.symbol()
     assert.equal(nameNFT, "CarSalon NFT", "Not correct collection name")
     assert.equal(symbol, "CSNFT")

  })

  it("Check create token (mint add tokenURI", async () => {
    const carsalonnft = await CarSalonNFT.deployed()
    await carsalonnft.createClientCardNFT("https://github.com/stepanetssergey/solidity_cars.git")
    const tokenURI = await carsalonnft.tokenURI(1)
    assert.equal(tokenURI, "https://github.com/stepanetssergey/solidity_cars.git", "notCorrectURI")
  })

  it("Check car list", async() => {
    const buyCars = await BuyCars.deployed();
    const CarList = await buyCars.viewCarsList()
    //console.log(CarList)
  })

  
});
