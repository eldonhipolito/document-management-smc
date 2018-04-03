pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ECRecovery.sol';
import './SignableDocument.sol';
import './SelfSignatureVerifiable.sol';
import './Documents.sol';
import './OwnableIntf.sol';
import './IdentitiesIntf.sol';

contract Identity is SelfSignatureVerifiable {

    string public userId;

    string public name;

    address public owner;

    Documents public docsAdd;

    IdentitiesIntf public identitiesAdd;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Identity(string _userId, string _name, address _docsAdd, address _identitiesAdd) public {
        userId = _userId;
        name = _name;
        owner = msg.sender;
        docsAdd = Documents(_docsAdd);
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


}

