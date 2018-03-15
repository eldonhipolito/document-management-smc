pragma solidity ^0.4.0;

interface SignableDocument {

    function sign(bytes32 hash, bytes sig) public;


}
