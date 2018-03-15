pragma solidity ^0.4.0;

import './SignableDocument.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './NamedContract.sol';

import './SelfSignatureVerifiable.sol';

contract Document is SignableDocument, Ownable {



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

    function Document(string _docName, bytes32 _checksum) public {
        docName = _docName;
        checksum = _checksum;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event SignerAdded(address signer, uint signersCount);

    event Signed(address signer, uint totalSigned, uint signersCount);

    function addSigner(address signer) public onlyOwner {
        require(keccak256(NamedContract(signer).contractName()) == IDENTITY);

        uint length = signers.push(signer);

        SignerAdded(signer, length);
    }

    function sign(bytes32 hash, bytes sig) public {
        require(isSigner(msg.sender));
        require(!hasSigned(msg.sender));
        require(SelfSignatureVerifiable(msg.sender).isOwnSignature(hash, sig));

        uint totalSigned = signatures.push(Signatory(msg.sender, hash, sig));

        Signed(msg.sender, totalSigned, signers.length);
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
