pragma solidity 0.4.18;



interface RolesDefinitionIntf {

    function checkRole(address addr, string roleName) view public;

    function hasRole(address addr, string roleName) view public returns (bool);

    function adminAddRole(address addr, string roleName) public;

    function adminRemoveRole(address addr, string roleName) public;
}
