pragma solidity 0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './RBACIntf.sol';

import './NamedContract.sol';

contract Identities is Ownable {


    address public rolesDefAdd;

    struct VerifiedIdentity {
        address identity;
    }
    // Mapping of user address to identity
    mapping(address => address) public identities;

    string constant ROLE_VERIFIED_IDENTITY = "VERIFIED_IDENTITY";

    string constant ROLE_DOCUMENT_SIGNER = "DOCUMENT_SIGNER";

    string constant ROLE_DOCUMENT_CREATOR = "DOCUMENT_CREATOR";

    RBACIntf public rbacAddress;

    bytes32 public constant IDENTITY = 0x377799b22fba826cf24c3f07e6731c67676765addcee33415a2c80d453d4ed6e;

    function Identities(address _rbacAddress){
        rbacAddress = RBACIntf(_rbacAddress);
    }

    event IdentityVerified();
    event RoleAdded();
    event RoleRemoved();

    function verifyIdentity(address identity) public {
        require(NamedContract(identity).contractName() == IDENTITY);
        require(IdentityOwnership(identity).owner() == msg.sender);
        require(identities[msg.sender] == address(0));

    }


    function setRBACAddress(address _rbacAddress) public onlyOwner {
        rbacAddress = RBACIntf(_rbacAddress);
    }


    function hasRole(address addr, string roleName) view public returns (bool) {
        return rbacAddress.hasRole(addr, roleName);
    }

    function checkRole(address addr, string roleName) view public {
        rbacAddress.checkRole(addr, roleName);
    }

    function adminAddRole(address addr, string roleName) public {

        rbacAddress.adminAddRole(addr, roleName);
    }

    function adminRemoveRole(address addr, string roleName) public;

}

interface IdentityOwnership {
    function owner() public view returns (address);
}
