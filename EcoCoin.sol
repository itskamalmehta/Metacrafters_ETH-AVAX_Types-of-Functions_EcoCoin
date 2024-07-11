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
