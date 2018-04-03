var Migrations = artifacts.require("./Migrations.sol");

var Identities = artifacts.require("./Identities.sol");

var Documents = artifacts.require("./Documents.sol");

var ECRecovery = artifacts.require("zeppelin-solidity/contracts/ECRecovery.sol");

var RBAC = artifacts.require("zeppelin-solidity/contracts/ownership/rbac/RBAC.sol");


module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(ECRecovery);

  deployer.deploy(RBAC).then(function() {
    deployer.deploy(Identities, RBAC.address).then(function(){
        deployer.deploy(Documents, Identities.address);
    });
  });

};
