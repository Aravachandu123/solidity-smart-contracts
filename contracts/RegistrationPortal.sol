// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RegistrationPortal {
    address public immutable owner;
    uint256 public immutable registrationFee;

    mapping(address => bool) public isRegistered;
    address[] private registrants;

    error NotOwner();
    error IncorrectFee(uint256 sent, uint256 required);
    error AlreadyRegistered(address user);
    error NoFundsToWithdraw();
    error TransferFailed();

    event Registered(address indexed user, uint256 feePaid);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(uint256 _registrationFee) {
        owner = msg.sender;
        registrationFee = _registrationFee;
    }

    function register() external payable {
        if (msg.value != registrationFee) {
            revert IncorrectFee(msg.value, registrationFee);
        }
        if (isRegistered[msg.sender]) {
            revert AlreadyRegistered(msg.sender);
        }

        isRegistered[msg.sender] = true;
        registrants.push(msg.sender);

        emit Registered(msg.sender, msg.value);
    }

    function withdrawFees() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoFundsToWithdraw();

        (bool success, ) = payable(owner).call{value: balance}("");
        if (!success) revert TransferFailed();

        emit FundsWithdrawn(owner, balance);
    }

    function getRegistrantCount() external view returns (uint256) {
        return registrants.length;
    }
}
