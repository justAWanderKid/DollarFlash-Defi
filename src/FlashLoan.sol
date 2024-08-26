
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IVault} from "./interfaces/IVault.sol";
import {IFlashLoanReceiver} from "./interfaces/IFlashLoanReceiver.sol";

contract FlashLoan {

    using SafeERC20 for IERC20;

    error FlashLoan__ExecutionFailed();
    error FlashLoan__AmountToReceiveExceedsVaultBalance();
    error FlashLoan__AmountToReceiveIsLessThanMinimumAmount();

    IERC20 immutable public asset; // USDC
    IVault immutable public vault;

    uint256 private constant FEE = 3000; // 0.3%
    uint256 private constant PRECISION = 1e6; 
    uint256 private constant MIN_FLASHLOAN = 1e6;

    constructor(IVault _vault) {
        vault = _vault;
        asset = IERC20(vault.asset());
    }

    function flashLoan(address _flashLoanReceiver, uint256 _amount) external {

        if (_amount < MIN_FLASHLOAN) {

            revert FlashLoan__AmountToReceiveIsLessThanMinimumAmount();

        }
        
        if ( asset.allowance(address(vault), address(this)) != type(uint256).max ) {

            vault.approveFlashLoan();

        }

        if (_amount > asset.balanceOf(address(vault))) {

            revert FlashLoan__AmountToReceiveExceedsVaultBalance();

        }

        // transferfrom vault to receiver.
        asset.safeTransferFrom(address(vault), _flashLoanReceiver, _amount);

        // callback
        // receiver can take `_amount` and call `getFee()` function to see how much fee he should pay.
        if (IFlashLoanReceiver(_flashLoanReceiver).onFlashLoanReceived(_amount) != true) {

            revert FlashLoan__ExecutionFailed();

        }

        // transferFrom _amount + fee
        uint256 fee = getFee(_amount);
        asset.safeTransferFrom(_flashLoanReceiver, address(vault), _amount + fee);

    }


    function getFee(uint256 _amount) public pure returns(uint256) {

        return (_amount * FEE) / PRECISION;

    }


}