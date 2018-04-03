pragma solidity ^0.4.18;

import './SignableDocument.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './SelfSignatureVerifiable.sol';


contract Document is Ownable, SignableDocument {

    struct Signatory {
        address signer;
        bytes32 hash;
        bytes signature;
    }


    uint256 public id;

    string public docName;

    bytes32 public checksum;

    address[] public signers;

    Signatory[] public signatures;

    event DocumentSigned(address docAddress, address signer, uint totalSigned, uint signersCount);

    event SignerAdded(address docAddress, address owner, address signer, uint signersCount);


    function Document(uint256 _id, string _docName, bytes32 _checksum, address _owner) public {
        id = _id;
        docName = _docName;
        checksum = _checksum;
        owner = _owner;
    }

    function addSigner(address signer) external onlyOwner {
        uint length = signers.push(signer);

        SignerAdded(address(this), msg.sender, signer, length);
    }

    function sign(bytes32 hash, bytes sig) external {
        require(isSigner(msg.sender));
        require(!hasSigned(msg.sender));
        require(SelfSignatureVerifiable(msg.sender).isOwnSignature(hash, sig));

        uint totalSigned = signatures.push(Signatory(msg.sender, hash, sig));

        DocumentSigned(address(this), msg.sender, totalSigned, signatures.length);
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
