// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

// This file is strictly used to generate a bytes32 private key from a mnemonic that you can use for your .env
// Run locally, so that the key does not leak onto the web.
// To use, run "forge test -vvv" and copy the string in the logs. Paste it into your .env file.
// Remember not to upload it online.


contract GeneratePrivateKeyTest is Test {

    function setUp() public {}

    // 
    function test() public {
        string memory mnemonic = "YOUR MNEMONIC HERE";
        uint256 key = vm.deriveKey(mnemonic, 0);
        console2.logBytes32(bytes32(key));
    }
}
