pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './RBACIntf.sol';

contract Identities is Ownable {

    struct VerificationData {
        address user;
        address identity;
        uint256 blockTimestamp;
    }

    // Mapping of user address to identity
    mapping(address => address) public identities;

    mapping(address => address) public unverifiedIdentities;

    VerificationData[] public requests;



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
    event IdentityVerificationRequested(address sender, address identity);
    event RoleAdded(address admin, address user, string role);
    event RoleRemoved(address admin, address user, string role);

    modifier onlyRole(string _role) {
        checkRole(msg.sender, _role);
        _;
    }

    modifier onlyAdmin() {
        checkRole(msg.sender, ROLE_ADMIN);
        _;
    }

    function verifyIdentity(address user, address identity) public onlyAdmin {
        require(IdentityOwnership(identity).owner() == user);
        require(identities[user] == address(0));

        identities[user] = identity;
        unverifiedIdentities[user] = address(0);
        adminAddRole(user, ROLE_VERIFIED_IDENTITY);
        IdentityVerified(msg.sender, user, identity);
    }

    function reqIdnVerification(address identity) external {
        require(identities[msg.sender] == address(0));
        require(unverifiedIdentities[msg.sender] == address(0));
        require(IdentityOwnership(identity).owner() == msg.sender);

        requests.push(VerificationData(msg.sender, identity, block.timestamp));
        unverifiedIdentities[msg.sender] = identity;

        IdentityVerificationRequested(msg.sender, identity);
    }


    function setRBACAddress(address _rbacAddress) public onlyOwner {
        rbacAddress = RBACIntf(_rbacAddress);
    }

    function checkVerifiedRole(address addr) view public {
        checkRole(addr, ROLE_VERIFIED_IDENTITY);
    }

    function checkSignerRole(address addr) view public {
        checkRole(addr, ROLE_DOCUMENT_SIGNER);
    }

    function checkCreatorRole(address addr) view public {
        checkRole(addr, ROLE_DOCUMENT_CREATOR);
    }


    function hasRole(address addr, string roleName) public view returns (bool) {
        return rbacAddress.hasRole(addr, roleName);
    }

    function checkRole(address addr, string roleName) public view {
        rbacAddress.checkRole(addr, roleName);
    }

    function adminAddRole(address addr, string roleName) public onlyAdmin {
        require(identities[addr] != address(0));

        rbacAddress.adminAddRole(addr, roleName);

        RoleAdded(msg.sender, addr, roleName);

    }

    function adminRemoveRole(address addr, string roleName) public onlyAdmin {
        require(ROLE_VERIFIED_IDENTITY_KCK != keccak256(roleName));
        rbacAddress.adminRemoveRole(addr, roleName);

        RoleRemoved(msg.sender, addr, roleName);
    }


}

interface IdentityOwnership {
    function owner() public view returns (address);
}
