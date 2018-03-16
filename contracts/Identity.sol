pragma solidity 0.4.18;

import 'zeppelin-solidity/contracts/ECRecovery.sol';
import './SignableDocument.sol';
import './NamedContract.sol';
import './SelfSignatureVerifiable.sol';
import './DocumentFactoryIntf.sol';
import './TransferableIntf.sol';

contract Identity is NamedContract, SelfSignatureVerifiable {

    string public name;

    address public owner;

    address public docFacAdd;

    mapping (uint256 => address) public ownedContracts;

    uint256 public ownedCount;


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    event DocumentCreated(uint256 id, address document, address creator);

    event DocumentOwnershipTransferred(uint256 documentId, address previousOwner, address newOwner);

    event DocumentSigned();



    function Identity(string _name, address _docFacAdd) NamedContract(keccak256("IDENTITY")) public {
        name = _name;
        owner = msg.sender;
        docFacAdd = _docFacAdd;
    }

    // Acts as the sign-in function for the dapp
    function authenticate(bytes32 hash, bytes sig) public view onlyOwner returns (bool) {
        return ECRecovery.recover(hash, sig) == msg.sender;
    }
    // Function to check whether signature is done by this identity
    function isOwnSignature(bytes32 hash, bytes sig) public view returns (bool) {
        return ECRecovery.recover(hash, sig) == owner;
    }
    // Interface used by user to sign documents
    function signDocument(address docAddress, bytes32 hash, bytes sig) public onlyOwner {
        SignableDocument document = SignableDocument(docAddress);
        document.sign(hash, sig);
    }

    function createDocument(string _docName, bytes32 _checksum) public {
        uint256 id = 0;
        address docAdd = address(0);

        (id, docAdd) = DocumentFactoryIntf(docFacAdd).createDocument(_docName, _checksum);
        ownedContracts[id] = docAdd;
        ownedCount++;
        DocumentCreated(id, docAdd, msg.sender);
    }

    function transferDocumentOwnership(uint256 documentId, address newOwner) public onlyOwner {
        // Ensures that address of new owner is an Identity
        require(NamedContract(newOwner).contractName == contractName);

        address docAdd = ownedContracts[documentId];
        require(docAdd != address(0));

        ownedCount--;
        ownedContracts[documentId] = address(0);
        TransferableIntf(docAdd).transferOwnership(newOwner);
        DocumentOwnershipTransferred(documentId, msg.sender, newOwner);

    }




}

