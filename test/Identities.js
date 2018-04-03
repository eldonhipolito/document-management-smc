

var Identities = artifacts.require("./Identities.sol");

var Identity = artifacts.require("./Identity.sol");

var Documents = artifacts.require("./Documents.sol");


var ECRec = artifacts.require("zeppelin-solidity/contracts/ECRecovery.sol");

contract('Identities', async (accounts) => {
    let idn;
    let ecr;
    let idns;
    let docs;

    it("should be able to request Identity verification", async () => {
        ecr = await ECRec.deployed();
        idns = await Identities.new();
        docs = await Documents.new(idns.address);
        Identity.link("ECRecovery", ecr.address);
        idn = await Identity.new("eldon123", "Eldon", docs.address, idns.address);

        await idns.reqIdnVerification(idn.address);

        assert.equal(await idns.unverifiedIdentities(web3.eth.coinbase), idn.address);

    })

    it("should be able to verify an identity", async () => {
      //  console.log(await rb.hasRole(web3.eth.coinbase, "admin"));
        console.log(await web3.eth.coinbase);
        console.log(await idn.owner());
        console.log(await idn.address);
        await idns.verifyIdentity(web3.eth.coinbase, idn.address);

        assert.equal(await idns.identities(web3.eth.coinbase), idn.address);
    })
});