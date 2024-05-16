// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "contracts/Tokens.sol";

contract Staking {
    address public lpToken;
    uint256 public rewardPerSecond = 1576800;

    constructor(address _lpToken) {
        lpToken = _lpToken;
    }

    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public lastRewardTime;

    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        LPToken(lpToken).transferFrom(msg.sender, address(this), amount);
        stakedBalances[msg.sender] += amount;
        lastRewardTime[msg.sender] = block.timestamp;
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, unicode"Кол-во должно быть больше 0");
        require(stakedBalances[msg.sender] >= amount, unicode"Недостаточно баланса!");
        stakedBalances[msg.sender] -= amount;
        LPToken(lpToken).transfer(msg.sender, amount);
    }

    function calculateReward(address user) public view returns (uint256) {
        uint256 countLP = stakedBalances[user];
        uint256 allLp = LPToken(lpToken).totalSupply();
        uint256 lastUserRewardTime = lastRewardTime[user];
        return (((countLP * (block.timestamp - lastUserRewardTime)) / rewardPerSecond) * (countLP / (allLp + 1)) * ((((block.timestamp - lastUserRewardTime) / 30 days) * 1) / 20)) / 100 + 1;
    }

    function claimReward() public {
        uint256 reward = calculateReward(msg.sender);
        require(reward > 0, unicode"награда недоступна!");
        lastRewardTime[msg.sender] = block.timestamp;
        LPToken(lpToken).mint(msg.sender, reward);
    }
}
