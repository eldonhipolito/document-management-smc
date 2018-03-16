pragma solidity ^0.4.18;

contract NamedContract {

    bytes32 public contractName;

    function NamedContract(bytes32 _contractName) public{
        contractName = _contractName;
    }


}
