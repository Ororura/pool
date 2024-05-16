// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./ERC20.sol";

contract LPToken is ERC20("Professional", "PROFI") {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function decimals() public view virtual override returns (uint8) {
        return 12;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        _mint(to, amount);
    }

    function price() public pure returns (uint) {
        return 6 ether;
    }
}

contract GerdaCoin is ERC20("GerdaCoin", "Gerda") {
    address owner;

    constructor() {
        owner = msg.sender;
        _mint(owner, 100_000 * 10 ** decimals());
        _mint(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100_000 * 10 ** decimals());
    }

    function getReward(address _to) public {
        _mint(_to, 100 * 10 ** decimals());
    }

    function decimals() public view virtual override returns (uint8) {
        return 12;
    }

    function price() public pure returns (uint) {
        return 1 ether;
    }
}

contract KrendelCoin is ERC20("KrendelCoin", "KRENDEL") {
    address owner;

    constructor() {
        owner = msg.sender;
        _mint(owner, 150_000 * 10 ** decimals());
        _mint(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100_000 * 10 ** decimals());
    }

    function decimals() public view virtual override returns (uint8) {
        return 12;
    }

    function price() public pure returns (uint) {
        return 1.5 ether;
    }
}

contract RTKCoin is ERC20("RTKCoin", "RTK") {
    address owner;

    constructor() {
        owner = msg.sender;
        _mint(owner, 300_000 * 10 ** decimals());
        _mint(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100_000 * 10 ** decimals());
    }

    function decimals() public view virtual override returns (uint8) {
        return 12;
    }

    function price() public pure returns (uint) {
        return 3 ether;
    }
}
