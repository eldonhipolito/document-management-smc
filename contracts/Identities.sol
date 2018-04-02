pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './RBACIntf.sol';

contract Identities is Ownable {


    // Mapping of user address to identity
    mapping(address => address) public identities;

    string constant ROLE_VERIFIED_IDENTITY = "verified";

    bytes32 constant ROLE_VERIFIED_IDENTITY_KCK = 0x24fb3e7553f72d287bbe4f5c584938a00a2f63bf3d7aa032d67d57f2d556a84d;

    string constant ROLE_DOCUMENT_SIGNER = "signer";

    string constant ROLE_DOCUMENT_CREATOR = "creator";

    string constant ROLE_ADMIN = "admin";

    bytes32 constant ROLE_ADMIN_KCK = 0xf23ec0bb4210edd5cba85afd05127efcd2fc6a781bfed49188da1081670b22d8;

    RBACIntf public rbacAddress;

    bytes32 constant IDENTITY = 0x377799b22fba826cf24c3f07e6731c67676765addcee33415a2c80d453d4ed6e;

    function Identities(address _rbacAddress) public {
        rbacAddress = RBACIntf(_rbacAddress);
    }

    event IdentityVerified(address verifier, address user, address identity);
    event RoleAdded(address adder);
    event RoleRemoved();

    modifier onlyRole(string _role) {
        checkRole(msg.sender, _role);
        _;
    }

    modifier onlyAdmin() {
        checkRole(msg.sender, ROLE_ADMIN);
        _;
    }

    function verifyIdentity(address user, address identity) public onlyAdmin {
        require(NamedContract(identity).contractName() == IDENTITY);
        require(IdentityOwnership(identity).owner() == user);
        require(identities[user] == address(0));

        identities[user] = identity;
        IdentityVerified(msg.sender, user, identity);
    }


    function setRBACAddress(address _rbacAddress) public onlyOwner {
        rbacAddress = RBACIntf(_rbacAddress);
    }

    function checkVerifiedRole(address _identity) view public {
        checkRole(_identity, ROLE_VERIFIED_IDENTITY);
    }

    function checkSignerRole(address _identity) view public {
        checkRole(_identity, ROLE_DOCUMENT_SIGNER);
    }

    function checkCreatorRole(address _identity) view public {
        checkRole(_identity, ROLE_DOCUMENT_CREATOR);
    }


    function hasRole(address addr, string roleName) public view returns (bool) {
        return rbacAddress.hasRole(addr, roleName);
    }

    function checkRole(address addr, string roleName) public view {
        rbacAddress.checkRole(addr, roleName);
    }

    function adminAddRole(address addr, string roleName) external onlyAdmin {
        checkRole(addr, ROLE_VERIFIED_IDENTITY);

        rbacAddress.adminAddRole(addr, roleName);
    }

    function adminRemoveRole(address addr, string roleName) external onlyAdmin {
        require(ROLE_VERIFIED_IDENTITY_KCK != keccak256(roleName));
        rbacAddress.adminRemoveRole(addr, roleName);
    }


}

interface IdentityOwnership {
    function owner() public view returns (address);
}
