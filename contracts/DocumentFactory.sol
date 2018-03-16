pragma solidity ^0.4.0;

import './Document.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './DocumentFactoryIntf.sol';

import './RolesDefintionIntf.sol';

contract DocumentFactory is Ownable, DocumentFactoryIntf {

    mapping(uint256 => address) public documents;

    uint256 public count;

    address public rolesDefAdd;

    string constant ROLE_DOCUMENT_CREATOR = "DOCUMENT_CREATOR";

    function DocumentFactory(address _rolesDefAdd) public {
        rolesDefAdd = _rolesDefAdd;
    }

    function createDocument(string _docName, bytes32 _checksum) public returns(uint256, address) {
        require(RolesDefinitionIntf(rolesDefAdd).hasRole(msg.sender, ROLE_DOCUMENT_CREATOR));
        count++;
        address doc = new Document(count, _docName, _checksum, msg.sender);
        documents[count] = doc;

        return (count, doc);
    }

    function setRolesDefAdd(address _rolesDefAdd) public onlyOwner {
        rolesDefAdd = _rolesDefAdd;
    }




}
