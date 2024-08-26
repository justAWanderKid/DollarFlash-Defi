
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseTest, console2} from "./BaseTest.t.sol";

contract VaultTest is BaseTest {

    // add Liquidity tests
    function test_addLiquidity() external _addPoolDeposit {
        
    }

    function test_MultipleLPsAddLiquidity() external _MultipleLPsDepositTothePool {

    }

    // add and remove Liquidity tests
    function test_addAndRemoveLiquidity() external _addPoolDeposit _removeLiquidity {

    }

    function test_MultipleLPsAddLiquidityAndRemoveLiquidity() external _MultipleLPsDepositTothePool _MultipleLPsRemoveLiquidityFromthePool {

    }

    // fuzz add Liquidity test

    function testFuzz_AddLiquidity(address _user, uint256 _amount) external {
        vm.assume(_amount > 0);
        vm.assume(_user != address(0));

        vm.startPrank(_user);

                deal(address(USDC), _user, _amount);

                USDC.approve(address(vault), _amount);
                uint256 sharesReceived = vault.deposit(_amount);

                assertEq(vault.balanceOf(_user), sharesReceived);

        vm.stopPrank();
    }

    // fuzz add and remove liquidity
    function testFuzz_addAndRemoveLiquidity(address _user, uint256 _amount) external {
        vm.assume(_amount > 0);
        vm.assume(_amount < type(uint256).max);

        vm.assume(_user != address(0));
        vm.assume(_user != address(vault));

        vm.startPrank(_user);

                deal(address(USDC), _user, _amount);

                USDC.approve(address(vault), _amount);
                uint256 sharesReceived = vault.deposit(_amount);

                assertEq(vault.balanceOf(_user), sharesReceived);

                vault.approve(address(vault), sharesReceived);
                uint256 assetsReceived = vault.withdraw(sharesReceived);

                assertEq(USDC.balanceOf(_user), assetsReceived);

        vm.stopPrank();
    }



}


