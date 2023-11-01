# staking
Staking Smart Contract
Introduction
This repository contains a staking smart contract implemented in Solidity. The contract allows users to stake a specific ERC20 token and earn rewards over time. This README provides an explanation of how the Staking smart contract works and how to interact with it.

Table of Contents
Smart Contract Overview
Getting Started
Functions
Usage
License
Smart Contract Overview
The Staking smart contract is designed to facilitate token staking and rewards distribution. Key features of the contract include:

Users can stake a specific ERC20 token to earn rewards.
Rewards are distributed at a fixed rate of 0.01% per hour.
Users can deposit, withdraw, claim, and compound rewards.
Getting Started
To get started with this smart contract, you need to do the following:

Deploy the Staking smart contract, specifying the ERC20 token that users can stake.

Interact with the contract using the provided functions to deposit, withdraw, claim, or compound rewards.

Functions
deposit(uint amount)
Allows users to deposit a specified amount of the chosen ERC20 token into the staking contract.
withdraw(uint amount)
Allows users to withdraw a specified amount of their staked tokens from the contract. Note that users must first compound their rewards before withdrawing.
claim()
Allows users to claim their available rewards. The claimed rewards are transferred to the user's address.
compound()
Allows users to compound their rewards. Compounding adds the available rewards to the user's staked balance.
rewardBalance()
Returns the current rewards available for the sender.
rewards(address user)
Returns the available rewards for a specific user.
Usage
Deploy the Staking smart contract, passing the address of the ERC20 token that will be staked.

Users can interact with the contract by calling the functions mentioned above to deposit, withdraw, claim, or compound their rewards.

Users can check their reward balances and available rewards by calling the rewardBalance() and rewards(address user) functions.
