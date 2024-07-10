// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EC20 is ERC20 {
    uint public maxTransactionLimit = 800;
    address private contractOwner;

    mapping(address => uint256) public balances;

    constructor() ERC20("My Token", "MYT") {
        contractOwner = msg.sender;
        _mint(msg.sender, 10 * 10 ** decimals());
    }

    modifier onlyContractOwner {
        require(msg.sender == contractOwner, "Only contract owner can use this");
        _;
    }
    
    function mintTokens(address recipient, uint256 amount) public onlyContractOwner {
        require(amount > 0, "Amount must be greater than 0");
        _mint(recipient, amount);
        balances[recipient] += amount;
    }

    function burnTokens(address recipient, uint256 amount) public {
        require(balances[recipient] >= amount, "Insufficient balance");

        if (amount > maxTransactionLimit) {
            revert("Transaction amount exceeds maximum allowed");
        }

        _burn(recipient, amount);
        balances[recipient] -= amount;
    }

    function setMaxTransaction(uint256 newMax) public onlyContractOwner {
        maxTransactionLimit = newMax;
    }

    function getContractOwner() public view returns (address) {
        return contractOwner;
    }
}
