# Metacrafters_ETH-AVAX_Types-of-Functions_EcoCoin

EcoToken is a custom ERC20-like token. This smart contract allows the contract owner to mint new tokens, and any user to transfer and burn tokens. It also maintains a transaction history that only the owner can access.

## Description

The EcoToken smart contract includes the following functionalities:

1. Minting tokens (restricted to the contract owner).
2. Transferring tokens between addresses.
3. Burning tokens.
4. Logging all transactions (mints, transfers, burns) in a transaction history accessible only to the contract owner.


### Installing

To Run this Smart Contract use Online Remix IDE.
Follow these steps:

1. Go to the Remix website, https://remix.ethereum.org/ .

2. Create New file and Save it with a .sol extension with any name(eg. EcoCoin.sol) and open it.

3. Copy-paste the provided Solidity code into the file created by you.

4. Click on the "Solidity Compiler" tab then Click on "Compile" to compile.

5. Deploy the contract by clicking on the "Deploy & Run Transactions" tab then and choose Environment "Remix VM (Cancun)", click "Deploy."


### Executing program

Once the contract is deployed, you can interact with it using the provided functions:
    
   (a) Copy the owner's address(first one to deploy the contract) from clicking on "copy address" from Account option.

   (b) Use the mint(owner only) and burn function to mint and burn token.

   (c) Use the Balance function to view the current balance.

   (d) Transfer funtion to send token to another address.
   
   (e) Use TotalSupply function to check total supply of the contract.

You can then switch to another address from Account option on the top. copy the address. and perform the same above actions(except minting and getTransactionHistory)
Note: First transfer some tokens to the other address by the owner address as users who are not owner can't mint their own tokens.
You can create as many different address as you want from the Account option on the top, to use all the same functionality(non-owner ones).

Then at last you can use getTransactionHistory funtion(owner only) to get all the transaction details(address, value, type, timeline) done by different-different addresses.
         

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EcoToken {
    string public TokenName = "EcoToken";
    string public Symbol = "ECO";
    uint256 public TotalSupply;
    address public owner;

    mapping(address => uint256) public Balance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed to, uint256 value);

    struct Transaction {
        address user;   //the address involved in transaction
        uint256 value;
        string action;  // like minting or burning or token 
        uint256 timestamp;
    }

    Transaction[] private transactionHistory;

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "only Owner can access");
        _;
    }

    // Constructor to set the initial owner
    constructor() {
        owner = msg.sender;
    }

    function mint(address _to, uint256 _value) external onlyOwner {
        require(_to != address(0), "Invalid address");
        TotalSupply += _value;
        Balance[_to] += _value;
        emit Mint(_to, _value);
        // Log the mint transaction
        transactionHistory.push(Transaction({
            user: _to,
            value: _value,
            action: "mint",
            timestamp: block.timestamp
        }));
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(Balance[msg.sender] >= _value, "Insufficient balance");
        Balance[msg.sender] -= _value;
        Balance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        // Log the transfer transaction
        transactionHistory.push(Transaction({
            user: msg.sender,
            value: _value,
            action: "transfer",
            timestamp: block.timestamp
        }));
        return true;
    }

    function burn(uint256 _value) external {
        require(Balance[msg.sender] >= _value, "Insufficient balance");
        TotalSupply -= _value;
        Balance[msg.sender] -= _value;
        emit Burn(msg.sender, _value);
        // Log the burn transaction
        transactionHistory.push(Transaction({
            user: msg.sender,
            value: _value,
            action: "burn",
            timestamp: block.timestamp
        }));
    }

    // to get the transaction history
    function getTransactionHistory() external view onlyOwner returns (Transaction[] memory) {
        return transactionHistory;
    }
}
```


## Authors
Kamal Mehta
Itskamlmehta@gmail.com

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
