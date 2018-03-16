pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ECRecovery.sol';
import './SignableDocument.sol';
import './NamedContract.sol';
import './SelfSignatureVerifiable.sol';
import './DocumentFactoryIntf.sol';
import './OwnableIntf.sol';
import './IdentitiesIntf.sol';

contract Identity is NamedContract, SelfSignatureVerifiable {

    string public name;

    address public owner;

    DocumentFactoryIntf public docFacAdd;

    IdentitiesIntf public identitiesAdd;

    mapping (uint256 => address) public ownedContracts;

    uint256 public ownedCount;


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    event DocumentCreated(uint256 id, address document, address creator);

    event DocumentOwnershipTransferred(uint256 documentId, address previousOwner, address newOwner);

    event DocumentOwnershipReceived(uint256 documentId, address owner, address previousOwner);

    event DocumentSigned();


    function Identity(string _name, address _docFacAdd, address _identitiesAdd) NamedContract(keccak256("IDENTITY")) public {
        name = _name;
        owner = msg.sender;
        docFacAdd = DocumentFactoryIntf(_docFacAdd);
        identitiesAdd = IdentitiesIntf(_identitiesAdd);
    }

    // Acts as the sign-in function for the dapp
    function authenticate(bytes32 hash, bytes sig) external view onlyOwner returns (bool) {
        return ECRecovery.recover(hash, sig) == msg.sender;
    }
    // Function to check whether signature is done by this identity
    function isOwnSignature(bytes32 hash, bytes sig) external view returns (bool) {
        return ECRecovery.recover(hash, sig) == owner;
    }
    // Interface used by user to sign documents
    function signDocument(address docAddress, bytes32 hash, bytes sig) external onlyOwner {
        SignableDocument document = SignableDocument(docAddress);
        document.sign(hash, sig);

        DocumentSigned();
    }

    function createDocument(string _docName, bytes32 _checksum) external {
        uint256 id = 0;
        address docAdd = address(0);

        (id, docAdd) = docFacAdd.createDocument(_docName, _checksum);
        ownedContracts[id] = docAdd;
        ownedCount++;
        DocumentCreated(id, docAdd, msg.sender);
    }

    function receiveDocumentOwnership(uint256 id, address docAddress, address previousOwner) external {
        address retrievedDocAdd = docFacAdd.documents(id);
        //Used assert since this should never happen!
        assert(retrievedDocAdd == docAddress);
        assert(OwnableIntf(retrievedDocAdd).owner() == owner);
        assert(ownedContracts[id] == address(0));

        ownedContracts[id] = retrievedDocAdd;
        ownedCount++;
        DocumentOwnershipReceived(id, owner, previousOwner);
    }

    function transferDocumentOwnership(uint256 documentId, address newOwner) external onlyOwner {
        // Ensures that address of new owner has the rights to own the document
        identitiesAdd.checkVerifiedRole(newOwner);
        identitiesAdd.checkCreatorRole(newOwner);

        address docAdd = ownedContracts[documentId];
        require(docAdd != address(0));

        ownedCount--;
        ownedContracts[documentId] = address(0);
        OwnableIntf(docAdd).transferOwnership(newOwner);
        DocumentOwnershipTransferred(documentId, msg.sender, newOwner);

    }




}

