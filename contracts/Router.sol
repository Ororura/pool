// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Factory.sol";
import "./Pool.sol";

contract Router {
    Factory public factory;

    constructor(address _factory) {
        factory = Factory(_factory);
    }

    function swapExactTokens(uint256 amountIn, address[] memory path, bool _revertExchange) public {
        address pool = findPool(path[0], path[1]);
        Pool(pool).swap(amountIn, msg.sender, path, _revertExchange);
    }

    function findPool(address tokenA, address tokenB) public view returns (address) {
        Pool[] memory pools = factory.getPools();
        for (uint256 i = 0; i < pools.length; i++) {
            Pool pool = pools[i];
            if ((address(pool.tokenA()) == tokenA && address(pool.tokenB()) == tokenB) || (address(pool.tokenA()) == tokenB && address(pool.tokenB()) == tokenA)) {
                return address(pool);
            }
        }
        revert("Pool not found");
    }
}
