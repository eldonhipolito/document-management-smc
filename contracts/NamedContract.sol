pragma solidity ^0.4.0;

contract NamedContract {

    string public contractName;

    function NamedContract(string _contractName) public{
        contractName = _contractName;
    }


}
