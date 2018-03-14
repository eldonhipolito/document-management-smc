pragma solidity 0.4.19;

import 'zeppelin-solidity/contracts/ECRecovery.sol';

import './Document.sol';

contract Identity {

    string public name;

    address public owner;


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    function Identity(string _name) public {
        name = _name;
        owner = msg.sender;
    }

    // Acts as the sign-in function for the dapp
    function authenticate(bytes32 hash, bytes sig) public constant onlyOwner returns (bool) {
        return ECRecovery.recover(hash, sig) == msg.sender;
    }

    function verifySig(bytes32 hash, bytes sig) public constant returns (bool) {
        return ECRecovery.recover(hash, sig) == owner;
    }

    function signDocument(address docAddress, bytes32 hash, bytes sig) public onlyOwner {
        Document document = Document(docAddress);


    }



}
