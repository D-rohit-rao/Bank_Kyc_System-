var kycapp = artifacts.require("BankKYC.sol");

module.exports = function (deployer) 
{
    deployer.deploy(kycapp);
};