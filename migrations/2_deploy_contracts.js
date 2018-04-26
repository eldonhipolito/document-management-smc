var Migrations = artifacts.require("./Migrations.sol");

var Identities = artifacts.require("./Identities.sol");

var Documents = artifacts.require("./Documents.sol");

var ECRecovery = artifacts.require("zeppelin-solidity/contracts/ECRecovery.sol");

var RBAC = artifacts.require("zeppelin-solidity/contracts/ownership/rbac/RBAC.sol");


module.exports = function(deployer, network, accounts) {
  deployer.deploy(Migrations);
  deployer.deploy(ECRecovery);

    deployer.deploy(Identities, {from : accounts[0]}).then(function(){

        deployer.link(ECRecovery, Documents);
        deployer.deploy(Documents, Identities.address, {from : accounts[0]});
    });
};
