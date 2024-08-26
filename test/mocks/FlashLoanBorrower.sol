
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IFlashLoanReceiver} from "../../src/interfaces/IFlashLoanReceiver.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IFlashLoan} from "../../src/interfaces/IFlashLoan.sol";


contract FlashLoanBorrower is IFlashLoanReceiver {

    IERC20 Usdc;
    IFlashLoan flashLoan;

    constructor(IERC20 _usdc, address _flashLoan) {
        Usdc = _usdc;
        flashLoan = IFlashLoan(_flashLoan);
    }

    function onFlashLoanReceived(uint256 _amount) external virtual returns(bool) {
        uint256 fee = flashLoan.getFee(_amount);
        uint256 amountToRepay = _amount + fee;

        Usdc.approve(address(flashLoan), amountToRepay);

        return true;
    }

}