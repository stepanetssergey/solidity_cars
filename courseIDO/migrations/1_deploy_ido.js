const ERC20 = artifacts.require("ERC20");
const CourseIDO = artifacts.require("CourseIDO");
var tokenABI = require('../build/contracts/ERC20.json').abi;

module.exports = async function (deployer,network,addresses) {
  
  await deployer.deploy(ERC20, "COURSEIDO","CidoT");
  //console.log(ERC20.address, addresses)
  await deployer.deploy(CourseIDO, ERC20.address, addresses[0])

  var IDOToken = new web3.eth.Contract(tokenABI, ERC20.address)
  await IDOToken.methods.addMinter(CourseIDO.address)
                         .send({from:addresses[0]})
};