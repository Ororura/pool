// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Pool.sol";

contract Factory {
    Pool[] public pools;
    GerdaCoin public gerdaCoin;
    KrendelCoin public krendelCoin;
    RTKCoin public rtkCoin;
    LPToken public lpToken;

    constructor() {
        gerdaCoin = new GerdaCoin();
        krendelCoin = new KrendelCoin();
        rtkCoin = new RTKCoin();
        lpToken = new LPToken();

        createPool(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, address(gerdaCoin), address(krendelCoin), address(lpToken), 1500, 1000, gerdaCoin.price(), krendelCoin.price());
        gerdaCoin.sendTokens(address(this), address(pools[pools.length - 1]), 1500 * 10 ** gerdaCoin.decimals());
        krendelCoin.sendTokens(address(this), address(pools[pools.length - 1]), 1000 * 10 ** gerdaCoin.decimals());

        createPool(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, address(krendelCoin), address(rtkCoin), address(lpToken), 2000, 1000, krendelCoin.price(), rtkCoin.price());
        krendelCoin.sendTokens(address(this), address(pools[pools.length - 1]), 2000 * 10 ** krendelCoin.decimals());
        rtkCoin.sendTokens(address(this), address(pools[pools.length - 1]), 1000 * 10 ** rtkCoin.decimals());
    }

    function createPool(address _owner, address _tokenA, address _tokenB, address _tokenC, uint256 _amountA, uint256 _amountB, uint256 _priceA, uint256 _priceB) public {
        pools.push(new Pool(_owner, _tokenA, _tokenB, _tokenC, _amountA, _amountB, _priceA, _priceB));
    }

    function getPriceToken() public view returns (uint) {
        return gerdaCoin.price();
    }

    function getPoolData() public view returns (string[] memory, uint256[] memory, uint256[] memory, uint256[] memory) {
        string[] memory tokensNames = new string[](pools.length * 2);
        uint256[] memory totalTokenPrices = new uint256[](pools.length);
        uint256[] memory tokenRatios = new uint256[](pools.length);
        uint256[] memory absoluteValues = new uint256[](pools.length);

        for (uint256 i = 0; i < pools.length; i++) {
            (string memory tokenAName, string memory tokenBName, uint256 tokenPriceA, uint256 tokenPriceB) = Pool(pools[i]).getPoolData();
            tokensNames[i * 2] = tokenAName;
            tokensNames[i * 2 + 1] = tokenBName;

            totalTokenPrices[i] = tokenPriceA + tokenPriceB;

            tokenRatios[i] = tokenPriceA / tokenPriceB;

            absoluteValues[i] = totalTokenPrices[i];
        }

        return (tokensNames, totalTokenPrices, tokenRatios, absoluteValues);
    }

    function getTokensAddress() public view returns (address[] memory) {
        address[] memory returnData = new address[](4);
        returnData[0] = address(gerdaCoin);
        returnData[1] = address(krendelCoin);
        returnData[2] = address(rtkCoin);
        returnData[3] = address(lpToken);
        return returnData;
    }

    function getPools() public view returns (Pool[] memory) {
        return pools;
    }
}
