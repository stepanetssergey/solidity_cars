const BuyCars = artifacts.require("BuyCars");
const BT = artifacts.require("ERC20");

module.exports = async function (deployer) {
  await deployer.deploy(BT, "BonusToken", "BT");
  await deployer.deploy(BuyCars, BT.address);
};