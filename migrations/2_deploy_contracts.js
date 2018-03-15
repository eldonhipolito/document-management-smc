var Migrations = artifacts.require("./Migrations.sol");

var DocumentFactory = artifacts.require("./DocumentFactory.sol");

var Identity = artifacts.require("./Identity.sol");

var Document = artifacts.require("./Document.sol");

var ECRecovery = artifacts.require("zeppelin-solidity/contracts/ECRecovery.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(ECRecovery);
  deployer.link(ECRecovery, Identity);

  deployer.deploy(DocumentFactory).then(function() {
    deployer.deploy(Identity, "Eldon", DocumentFactory.address);
  });

};
