pragma solidity ^0.4.18;

interface DocumentFactoryIntf {
    function createDocument(string _docName, bytes32 _checksum) public returns(uint256, address);

    function documents(uint256 id) view public returns (address);
}
