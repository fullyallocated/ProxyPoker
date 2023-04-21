### Deployment Details

#### Base Goerli

Explorer: https://goerli-explorer.base.org
Public RPC: https://goerli.base.org
Chain ID: 84531
Faucets: https://docs.base.org/tools/network-faucets

(I used both QuickNode and Coinbase Wallet faucet for a total of .125Eth, which should be enough)

---

### Contract Overview

ProxyPoker.sol: 

https://goerli.basescan.org/address/0xa52b846f419244fa200efa2ce8b28d068d36d592#code

The ProxyPoker.sol contract is the "main contract" that the game server & players will interact with.

In particular, there are a few functions:

1. setGameServer(): This function is public on testnet for convenience only; on live deployment it will be permissioned properly. It sets the game server address to the provided address.

2. openTable(): This function can only be called by the game server to open a new table. It takes an address parameter representing the address of the table host. Currently the "host" property is not used for anything in the contract, but in the future may be important. We will discuss later.

3. closeTable(): This function can only be called by the game server to close an existing table. It takes a uint256 parameter representing the table ID to be closed.

4. buyInToTable(): This function is used by a player to buy-in to a table. It takes two parameters: a uint256 representing the table ID and a uint256 representing the amount of USDT to buy-in with.

REMINDER: A player must approve this contract to transfer their USDT prior to calling this function! Failure to approve the contract address will result in vague errors that are hard to debug.

5. returnPlayerCreditFromTable(): This function is used by the game server to cash-out a player's credit from a table. It takes two parameters: a uint256 representing the table ID and a uint256 representing the amount of USDT to cash-out.


MockUSDT.sol:

https://goerli.basescan.org/address/0x8f7ab0701f4f2a7e2a73642c3c6920263b17a6b1#code

The MockUSDT.sol contract is a fake "USDT" contract that has built in public mint() and burn() functions to allow for easy testing without the use of a faucet (huge headache). In the production version we will obviously be using real USDT contract.