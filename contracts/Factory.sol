// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Pool.sol";

contract Factory {
    Pool[] public pools;
    GerdaCoin public gerdaCoin;
    KrendelCoin public krendelCoin;
    RTKCoin public rtkCoin;
    LPToken public lpToken;

    struct PoolData {
        string tokenA;
        string tokenB;
        uint totalTokensPrice;
        uint tokenRatios;
        uint absolueValues;
    }

    constructor() {
        gerdaCoin = new GerdaCoin();
        krendelCoin = new KrendelCoin();
        rtkCoin = new RTKCoin();
        lpToken = new LPToken();

        createPool(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, address(gerdaCoin), address(krendelCoin), 1500, 1000, gerdaCoin.price(), krendelCoin.price());
        gerdaCoin.sendTokens(address(this), address(pools[pools.length - 1]), 1500 * 10 ** gerdaCoin.decimals());
        krendelCoin.sendTokens(address(this), address(pools[pools.length - 1]), 1000 * 10 ** gerdaCoin.decimals());

        createPool(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, address(krendelCoin), address(rtkCoin), 2000, 1000, krendelCoin.price(), rtkCoin.price());
        krendelCoin.sendTokens(address(this), address(pools[pools.length - 1]), 2000 * 10 ** krendelCoin.decimals());
        rtkCoin.sendTokens(address(this), address(pools[pools.length - 1]), 1000 * 10 ** rtkCoin.decimals());
    }

    function createPool(address _owner, address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB, uint256 _priceA, uint256 _priceB) public {
        pools.push(new Pool(_owner, _tokenA, _tokenB, address (lpToken), _amountA, _amountB, _priceA, _priceB));
    }
    
    function getPoolData() public view returns (PoolData[] memory) {
    PoolData[] memory returnPoolData = new PoolData[](pools.length);

    for (uint256 i = 0; i < pools.length; i++) {
        uint tokenRatios;
        (string memory tokenAName, string memory tokenBName, uint256 tokenPriceA, uint256 tokenPriceB) = Pool(pools[i]).getPoolData();

        // Check for division by zero
        if (tokenPriceB != 0) {
            tokenRatios = tokenPriceA * (10**18) / tokenPriceB;
        } else {
            tokenRatios = 0;
        }

        returnPoolData[i] = PoolData(tokenAName, tokenBName, tokenPriceA + tokenPriceB, tokenRatios, tokenPriceA + tokenPriceB);
    }

    return (returnPoolData);
}

    function getPools() public view returns (Pool[] memory) {
        return pools;
    }
}
