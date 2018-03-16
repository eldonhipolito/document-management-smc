pragma solidity ^0.4.18;

interface SignableDocument {

    function sign(bytes32 hash, bytes sig) external returns (address signer, uint totalSigned, uint signersCount);

    function addSigner(address signer) external;


}
