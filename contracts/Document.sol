pragma solidity ^0.4.18;

import './SignableDocument.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './NamedContract.sol';

import './SelfSignatureVerifiable.sol';


contract Document is SignableDocument, Ownable {


    uint256 public id;

    string public docName;

    bytes32 public checksum;



    struct Signatory {
        address signer;
        bytes32 hash;
        bytes signature;
    }

    address[] public signers;

    Signatory[] public signatures;

    bytes32 public constant IDENTITY = 0x377799b22fba826cf24c3f07e6731c67676765addcee33415a2c80d453d4ed6e;

    function Document(uint256 _id, string _docName, bytes32 _checksum, address _owner) public {
        docName = _docName;
        checksum = _checksum;
        owner = _owner;
    }

    event SignerAdded(address owner, address signer, uint signersCount);

    function addSigner(address signer) public onlyOwner {
        require(NamedContract(signer).contractName() == IDENTITY);

        uint length = signers.push(signer);

        SignerAdded(signer, length);
    }

    function sign(bytes32 hash, bytes sig) public returns (address signer, uint totalSigned, uint signersCount) {
        require(isSigner(msg.sender));
        require(!hasSigned(msg.sender));
        require(SelfSignatureVerifiable(msg.sender).isOwnSignature(hash, sig));

        uint totalSigned = signatures.push(Signatory(msg.sender, hash, sig));

        return (msg.sender, totalSigned, signers.length);
    }


    function isSigner(address signerAddress) internal view returns (bool){
        for (uint i = 0; i < signers.length; i++) {
            if (signers[i] == signerAddress) {
                return true;
            }
        }

        return false;
    }

    function hasSigned(address signerAddress) internal view returns (bool) {
        for (uint i = 0; i < signatures.length; i++) {
            if (signatures[i].signer == signerAddress) {
                return true;
            }
        }

        return false;
    }


}
