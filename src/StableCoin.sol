// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Stable Coin
/// @author Favour Aniogor
/// @notice A stable coin like USDC or USDT
/// @dev This is a contract meant to be governed by SCEngines. This contract is just ERC20 implementation of a stablecoin.
contract StableCoin is ERC20Burnable, Ownable {
    constructor() ERC20("Stable Coin","SC"){}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 _balance = balanceOf(msg.sender);
        if(_amount <= 0) {
            revert StableCoin__MustBeMoreThanZero();
        }
        if(_balance < _amount){
            revert StableCoin__BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns(bool) {
        if(_to == address(0)){
            revert StableCoin__NotZeroAddress();
        }
        if(_amount <= 0) {
            revert StableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}