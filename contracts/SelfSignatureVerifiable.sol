pragma solidity ^0.4.0;

interface SelfSignatureVerifiable {

    function isOwnSignature(bytes32 hash, bytes sig) public constant returns (bool);

}
