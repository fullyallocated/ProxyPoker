// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract ProxyPoker {

    // Events and errors

    event TableOpened(uint256 tableId_, address host_);
    event TableClosed(uint256 tableId_);

    error UnableToCloseTable();
    error UnableToBuyIn();
    error UnableToCashOut();

    // State variables
    struct Table {
        address host;
        mapping(address => uint256) playerCreditIn;
        mapping(address => uint256) playerCreditOut;
        uint256 netTableCredit;
        bool hasOpened;
        bool isRetired;
    }

    address public gameServer;
    uint256 public totalTableCount;
    mapping(uint256 => Table) public getTableForId;
    ERC20 public USDT; 

    modifier onlyAdmin() {
        require(msg.sender == gameServer, "Only the game server can call this function.");
        _;
    }

    // Constructor
    constructor(ERC20 usdt_) {
        gameServer = msg.sender;
        USDT = usdt_;
    }

    /// @notice set the game server address
    /// @dev TEST PURPOSES ONLY: ALLOW ANYONE TO CALL THIS FUNCTION
    function setGameServer(address gameServer_) public {
        gameServer = gameServer_;
    }

    /// @notice open a new table
    function openTable(address host_) external onlyAdmin {
        // increment the totalTableCount;
        totalTableCount++;

        // create a new table
        Table storage table = getTableForId[totalTableCount];
        table.host = host_;
        table.hasOpened = true;

        // emit event
        emit TableOpened(totalTableCount, host_);
    }

    /// @notice close a table
    function closeTable(uint256 tableId_) external onlyAdmin {
        // get the table
        Table storage table = getTableForId[tableId_];

        // check that the table is not already closed and that it must first be open
        if (!table.hasOpened || table.isRetired) { revert UnableToCloseTable(); }

        // if there is table credit, don't allow the table to close
        if (table.netTableCredit > 0) { revert UnableToCloseTable(); }

        table.isRetired = true;

        emit TableClosed(tableId_);
    }

    /// @notice buy in to a table
    function buyInToTable(uint256 tableId_, uint256 amount_) external {
        // get the table
        Table storage table = getTableForId[tableId_];

        // if the table is unopened or retired, don't allow the buy in
        if (!table.hasOpened || table.isRetired) {
            revert UnableToBuyIn();
        }

        // add the amount to the player's credit in
        table.playerCreditIn[msg.sender] += amount_;

        // add the amount to the net table credit
        table.netTableCredit += amount_;

        // transfer the amount from the player to the contract
        USDT.transferFrom(msg.sender, address(this), amount_);
    }

    /// @notice return player's credit from a table
    function returnPlayerCreditFromTable(uint256 tableId_, uint256 amount_) external onlyAdmin {
        // get the table
        Table storage table = getTableForId[tableId_];

        // if the table is unopened or retired, don't allow the buy out
        if (!table.hasOpened || table.isRetired) {
            revert UnableToCashOut();
        }

        // add the amount to the player's credit out
        table.playerCreditOut[msg.sender] += amount_;

        // subtract the amount from the net table credit
        table.netTableCredit -= amount_;

        // transfer the amount from the contract to the player
        USDT.transfer(msg.sender, amount_);
    }
}


