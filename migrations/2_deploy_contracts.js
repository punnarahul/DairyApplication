const Processes = artifacts.require("./Processes.sol");
const Product_Full_Details = artifacts.require("./Product_Full_Details.sol");
const Stakeholders = artifacts.require("./Stakeholders.sol");

module.exports = function(deployer) {
  deployer.deploy(Processes);
  deployer.deploy(Product_Full_Details);
  deployer.deploy(Stakeholders);
};