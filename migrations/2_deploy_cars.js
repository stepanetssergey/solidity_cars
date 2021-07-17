const BuyCars = artifacts.require("BuyCars");
const BT = artifacts.require("ERC20");
const BuyCarABI = require('../scripts/BuyCar.json')
const ERC20ABI = require('../scripts/ERC20.json')

module.exports = async function (deployer, network, addresses) {
  await deployer.deploy(BT, "BonusToken", "BT");
  await deployer.deploy(BuyCars, BT.address);

  //var BuyCarContract = new web3.eth.Contract(BuyCarABI, BuyCars.address)
  var ERC20Contract = new web3.eth.Contract(ERC20ABI, BT.address)
  await ERC20Contract.methods
                         .addMinter(BuyCars.address)
                         .send({from:addresses[0]})

};