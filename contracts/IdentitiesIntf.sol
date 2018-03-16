pragma solidity ^0.4.18;


//Interfaces used by contracts depending on Identities contract
interface IdentitiesIntf {

    function identities(address _address) public view returns (address);

    function verifyIdentity(address user, address identity) public;

    function setRBACAddress(address _rbacAddress) public;

    function hasRole(address _identity, string roleName) view public returns (bool);

    function checkRole(address _identity, string roleName) view public;

    function checkVerifiedRole(address _identity) view public;

    function checkSignerRole(address _identity) view public;

    function checkCreatorRole(address _identity) view public;

}
