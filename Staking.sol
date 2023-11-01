// SPDX-License-Identifier: UNLICENSED
// Declare the license under which the code is released and specify the Solidity compiler version to use.
pragma solidity ^0.8.20;

// Import the SafeERC20 library from the OpenZeppelin library, which is used for handling ERC20 tokens securely.
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// Define the Staking contract.
contract Staking {
    using SafeERC20 for IERC20; // Use SafeERC20 for secure ERC20 token interactions.

    // Declare public state variables.
    IERC20 public immutable token; // An ERC20 token contract used for staking and rewards.
    uint public immutable rewardsPerHour = 1000; // 0.01% of rewards per hour.

    uint public stakeBalance = 0; // Total staked balance.

    // Declare events to log important contract actions.
    event Deposit(address sender, uint amount); // Event when a user deposits tokens.
    event Withdraw(address sender, uint amount); // Event when a user withdraws tokens.
    event Claim(address sender, uint amount); // Event when a user claims rewards.
    event Compound(address sender, uint amount); // Event when a user compounds rewards.

    // Declare mappings to store user-specific data.
    mapping(address => uint) public balanceOf; // Mapping of user addresses to their staked token balances.
    mapping(address => uint) public lastUpdated; // Mapping of user addresses to the last time they interacted with the contract.
    mapping(address => uint) public claimed; // Mapping of user addresses to the total claimed rewards.

    // Constructor to initialize the contract with an ERC20 token.
    constructor(IERC20 token_) {
        token = token_;
    }

    // External function to check the current rewards available for the sender.
    function rewardBalance() external view returns (uint) {
        return _rewardBalance();
    }

    // Internal function to calculate the current rewards available for the sender.
    function _rewardBalance() internal view returns (uint) {
        return token.balanceOf(address(this)) - stakeBalance;
    }

    // External function to allow a user to deposit tokens into the staking contract.
    function deposit(uint amount_) external {
        _deposit(amount_);
    }

    // Internal function to handle the deposit of tokens.
    function _deposit(uint amount_) internal {
        // Safely transfer tokens from the sender to the contract.
        token.safeTransferFrom(msg.sender, address(this), amount_); 
        balanceOf[msg.sender] += amount_; // Update the user's staked balance.
        lastUpdated[msg.sender] = block.timestamp; // Update the last interaction time for the user.
        stakeBalance += amount_; // Update the total staked balance.
        emit Deposit(msg.sender, amount_); // Log the deposit event.
    }

    // External function to check the available rewards for a specific user.
    function rewards(address address_) external view returns (uint) {
        return _rewards(address_);
    }

    // Internal function to calculate rewards for a specific user.
    function _rewards(address address_) internal view returns (uint) {
        return (block.timestamp - lastUpdated[address_]) * balanceOf[address_] / (rewardsPerHour * 1 hours);
    }

    // External function to allow a user to claim their rewards.
    function claim() external {
        uint amount = _rewards(msg.sender); // Calculate the available rewards for the sender.
        token.safeTransfer(msg.sender, amount); // Safely transfer the rewards to the sender.
        _update(amount); // Update user-specific data.
        emit Claim(msg.sender, amount); // Log the claim event.
    }

    // Internal function to update user-specific data after a claim.
    function _update(uint amount_) internal {
        claimed[msg.sender] += amount_; // Update the total claimed rewards for the sender.
        lastUpdated[msg.sender] = block.timestamp; // Update the last interaction time for the sender.
    }
    // External function to allow a user to compound their rewards.
    function compound() external {
        _compound();
    }

    // Internal function to handle the compounding of rewards.
    function _compound() internal {
        uint amount = _rewards(msg.sender); // Calculate the available rewards for the sender.
        balanceOf[msg.sender] += amount; // Add the rewards to the user's staked balance.
        stakeBalance += amount; // Update the total staked balance.
        _update(amount); // Update user-specific data.
        emit Compound(msg.sender, amount); // Log the compound event.
    }

    // External function to allow a user to withdraw tokens.
    function withdraw(uint amount_) external {
        // Check if the user has sufficient staked balance.
        require(balanceOf[msg.sender] >= amount_, "Insufficient funds"); 
        _compound(); // Compound the rewards before withdrawing.
        balanceOf[msg.sender] -= amount_; // Update the user's staked balance.
        stakeBalance -= amount_; // Update the total staked balance.
        token.safeTransfer(msg.sender, amount_); // Safely transfer the requested amount to the sender.
        emit Withdraw(msg.sender, amount_); // Log the withdraw event.
    }
}