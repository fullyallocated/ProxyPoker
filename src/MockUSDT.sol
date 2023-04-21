// SDPX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MockUSDT is ERC20("(Mock) USDT", "USDT", 6) {
    
    function mint(address to_, uint256 amt_) external {
        _mint(to_, amt_);
    }

    function burn(address from_, uint256 amt_) external {
        _burn(from_, amt_);
    }
}