pragma solidity 0.4.18;

import 'zeppelin-solidity/contracts/ECRecovery.sol';

import './SignableDocument.sol';
import './NamedContract.sol';

import './SelfSignatureVerifiable.sol';

import './DocumentFactoryIntf.sol';

contract Identity is NamedContract, SelfSignatureVerifiable {

    string public name;

    address public owner;

    address public docFacAdd;


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    event DocumentCreated(uint256 id, address document);


    function Identity(string _name, address _docFacAdd) NamedContract(keccak256("IDENTITY")) public {
        name = _name;
        owner = msg.sender;
        docFacAdd = _docFacAdd;
    }

    // Acts as the sign-in function for the dapp
    function authenticate(bytes32 hash, bytes sig) public constant onlyOwner returns (bool) {
        return ECRecovery.recover(hash, sig) == msg.sender;
    }

    function isOwnSignature(bytes32 hash, bytes sig) public constant returns (bool) {
        return ECRecovery.recover(hash, sig) == owner;
    }

    function signDocument(address docAddress, bytes32 hash, bytes sig) public onlyOwner {
        SignableDocument document = SignableDocument(docAddress);
        document.sign(hash, sig);
    }


    function createDocument(string _docName, bytes32 _checksum) public {
        uint256 id = 0;
        address docAdd = address(0);

        (id, docAdd) = DocumentFactoryIntf(docFacAdd).createDocument(_docName, _checksum);

        DocumentCreated(id, docAdd);
    }




}

