const CarNFT = artifacts.require("CarSalonNFT.sol")

module.exports = async function (deployer) { 
     deployer.deploy(CarNFT)
}