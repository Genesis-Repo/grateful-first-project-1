// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LoyaltyApp is Ownable {
    ERC20 public loyaltyToken;

    mapping(address => uint256) public loyaltyPoints;

    event LoyaltyPointsEarned(address indexed user, uint256 amount);
    event LoyaltyPointsRedeemed(address indexed user, uint256 amount);

    constructor(address loyaltyTokenAddress) {
        loyaltyToken = ERC20(loyaltyTokenAddress);
    }

    function earnLoyaltyPoints(uint256 amount) external {
        loyaltyPoints[msg.sender] += amount;
        emit LoyaltyPointsEarned(msg.sender, amount);
    }

    function redeemLoyaltyPoints(uint256 amount) external {
        require(loyaltyPoints[msg.sender] >= amount, "Not enough loyalty points");
        loyaltyPoints[msg.sender] -= amount;
        emit LoyaltyPointsRedeemed(msg.sender, amount);
    }

    function checkLoyaltyPoints(address user) external view returns (uint256) {
        return loyaltyPoints[user];
    }

    function withdrawERC20(address tokenAddress, address to, uint256 amount) external onlyOwner {
        ERC20(tokenAddress).transfer(to, amount);
    }
}