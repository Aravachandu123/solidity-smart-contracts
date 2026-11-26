# Solidity Smart Contracts

Foundational Ethereum smart contracts written in Solidity to practice state management, access control, custom errors, events, safe ETH transfers, and the Checks-Effects-Interactions (CEI) pattern.

## Contracts
- **PiggyBank (`contracts/PiggyBank.sol`):** Multi-user ETH vault isolating per-address balances via `mapping(address => uint256)` with `payable` deposits, `withdraw()` following the CEI pattern, low-level `.call`, custom errors, and events.
- **RegistrationPortal (`contracts/RegistrationPortal.sol`):** Fee-gated registration contract using `immutable` owner/fee configuration, `onlyOwner` modifier, duplicate-entry checks, registrant tracking, and owner fee withdrawals.

## Tools
- Solidity (`^0.8.20`), Remix IDE, GitHub
