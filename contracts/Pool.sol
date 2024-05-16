// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "contracts/ERC20.sol";
import "contracts/Tokens.sol";

contract Pool {
    address public owner;
    address public tokenA;
    address public tokenB;
    address public tokenC;
    uint256 public reserveA;
    uint256 public reserveB;
    uint256 public priceA;
    uint256 public priceB;
    uint256 public totalSupply;

    constructor(address _owner, address _tokenA, address _tokenB, address _tokenC, uint256 _initialBalanceTokenA, uint256 _initialBalanceTokenB, uint256 _priceA, uint256 _priceB) {
        owner = _owner;
        tokenA = _tokenA;
        tokenB = _tokenB;
        tokenC = _tokenC;
        reserveA = _initialBalanceTokenA;
        reserveB = _initialBalanceTokenB;
        priceA = _priceA;
        priceB = _priceB;
    }

    function swap(uint256 amountIn, address _from, address[] memory path, bool _revertExchange) public {
        require(path.length == 2, unicode"Кол-во адресов должно быть равно двум!");
        require(path[0] == tokenA && path[1] == tokenB, unicode"Неверные адреса!");
        if (!_revertExchange) {
            uint256 amountOut = (amountIn * reserveB) / reserveA;
            ERC20(tokenA).sendTokens(_from, address(this), amountIn);
            ERC20(tokenB).sendTokens(address(this), _from, amountOut);
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            uint256 amountOut = (amountIn * reserveA) / reserveB;
            ERC20(tokenB).sendTokens(_from, address(this), amountIn);
            ERC20(tokenA).sendTokens(address(this), _from, amountOut);
            reserveB += amountIn;
            reserveA -= amountOut;
        }
    }

    function provideLiquidity(uint256 amount, address token) public {
        uint256 liquidity;
        if (token == tokenA) {
            reserveA += amount;
            liquidity = (amount) / (priceA * 6);
        } else if (token == tokenB) {
            reserveB += amount;
            liquidity = (amount) / (priceB * 6);
        } else {
            revert("Invalid token");
        }

        LPToken(tokenC).mint(msg.sender, liquidity * 10 ** LPToken(tokenC).decimals());
        ERC20(token).sendTokens(msg.sender, address(this), amount);
    }

    function getPoolData() public view returns (string memory, string memory, uint, uint) {
        return (ERC20(tokenA).name(), ERC20(tokenB).name(), priceA, priceB);
    }
}
