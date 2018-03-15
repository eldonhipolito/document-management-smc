pragma solidity 0.4.18;

import 'zeppelin-solidity/contracts/ECRecovery.sol';

import './SignableDocument.sol';
import './NamedContract.sol';

import './SelfSignatureVerifiable.sol';


contract Identity is NamedContract, SelfSignatureVerifiable {

    string public name;

    address public owner;


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    function Identity(string _name) NamedContract(keccak256("IDENTITY")) public {
        name = _name;
        owner = msg.sender;
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

    //TODO create document
    function createDocument() public {
        
    }




}

