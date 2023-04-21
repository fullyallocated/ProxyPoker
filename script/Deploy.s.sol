// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/ProxyPoker.sol";
import "../src/MockUSDT.sol";

contract DeployProxy is Script {

    function run() external {
        vm.startBroadcast();

        MockUSDT usdt = new MockUSDT();
        console2.log("Mock usdt deployed to", address(usdt));

        ProxyPoker proxyPoker = new ProxyPoker(usdt);
        console2.log("ProxyPoker deployed to", address(proxyPoker));

        vm.stopBroadcast();
    }
}

