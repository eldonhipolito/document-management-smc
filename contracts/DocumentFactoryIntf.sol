pragma solidity ^0.4.0;

interface DocumentFactoryIntf {
    function createDocument(string _docName, bytes32 _checksum) public returns(uint256, address);
}
