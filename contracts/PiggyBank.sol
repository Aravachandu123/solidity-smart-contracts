// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PiggyBank {
    mapping(address => uint256) private balances;

    error ZeroDeposit();
    error InsufficientBalance(uint256 requested, uint256 available);
    error TransferFailed();

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    function deposit() external payable {
        if (msg.value == 0) revert ZeroDeposit();

        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        uint256 currentBalance = balances[msg.sender];
        if (amount == 0 || amount > currentBalance) {
            revert InsufficientBalance(amount, currentBalance);
        }

        // Checks-Effects-Interactions (CEI): update state before external call
        balances[msg.sender] = currentBalance - amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert TransferFailed();

        emit Withdrawn(msg.sender, amount);
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
