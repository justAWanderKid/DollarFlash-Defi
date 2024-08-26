
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseTest, console2} from "./BaseTest.t.sol";

contract FlashLoanTest is BaseTest {

    function test_takeFlashLoan() external _addPoolDeposit {
        uint256 amountToBorrow = vm.randomUint(1e6 , USDC.balanceOf(address(vault)));
        uint256 fee = flashLoan.getFee(amountToBorrow);
        deal(address(USDC), address(flashLoanBorrower), fee);

        flashLoan.flashLoan(address(flashLoanBorrower), amountToBorrow);
    }

    function testFuzz_takeFlashLoan(uint256 _amount) external _addPoolDeposit {
        vm.assume(_amount >= 1e6);
        vm.assume(_amount <= USDC.balanceOf(address(vault)));

        uint256 fee = flashLoan.getFee(_amount);
        deal(address(USDC), address(flashLoanBorrower), fee);

        flashLoan.flashLoan(address(flashLoanBorrower), _amount);
    }

}

