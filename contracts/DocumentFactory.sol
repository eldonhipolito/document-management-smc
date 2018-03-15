pragma solidity ^0.4.0;

import './Document.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './DocumentFactoryIntf.sol';

contract DocumentFactory is Ownable, DocumentFactoryIntf {

    mapping(uint256 => address) public documents;

    uint256 public count;


    function DocumentFactory() public {

    }

    function createDocument(string _docName, bytes32 _checksum) public returns(uint256, address) {
        count++;
        address doc = new Document(count, _docName, _checksum, msg.sender);

        return (count, doc);
    }




}
