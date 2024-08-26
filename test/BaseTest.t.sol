
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {FlashLoan} from "../src/FlashLoan.sol";
import {Vault} from "../src/Vault.sol";
import {UsdcToken} from "./mocks/UsdcToken.sol";
import {IVault} from "../src/interfaces/IVault.sol";
import {FlashLoanBorrower} from "./mocks/FlashLoanBorrower.sol";

contract BaseTest is Test {

    FlashLoan flashLoan;
    Vault vault;
    UsdcToken USDC;
    FlashLoanBorrower flashLoanBorrower;

    address deployer = makeAddr("deployer");
    address liquidityProvider1 = makeAddr("liquidityProvider1");

    function setUp() external {
        vm.startPrank(deployer);

        USDC = new UsdcToken();
        vault = new Vault(USDC);

        flashLoan = new FlashLoan(IVault(address(vault)));
        vault.setFlashLoanContract(address(flashLoan));

        flashLoanBorrower = new FlashLoanBorrower(USDC, address(flashLoan));

        vm.stopPrank();
    }


    modifier _MultipleLPsDepositTothePool {
        address[] memory liquidityProviders = new address[](5);

        console2.log("");
        console2.log("different liquidityProviders depositing Liquidity to the Pool:");
        console2.log("");

        for (uint i = 0; i < liquidityProviders.length; i++) {
            liquidityProviders[i] = address(uint160(i + 1));

            vm.startPrank(liquidityProviders[i]);

                uint256 amountToDeposit = vm.randomUint(1e6, 10e6);
                deal(address(USDC), liquidityProviders[i], amountToDeposit);

                USDC.approve(address(vault), amountToDeposit);
                uint256 sharesReceived = vault.deposit(amountToDeposit);

                console2.log("                                                              * liquidityProvider[",i+1,"] deposited amount: ", amountToDeposit);
                console2.log("                                                              * liquidityProvider[",i+1,"] received shares amount: ", sharesReceived);
                console2.log("");

            vm.stopPrank();
        }
        _;
    }

    modifier _MultipleLPsRemoveLiquidityFromthePool {
        address[] memory liquidityProviders = new address[](5);

        console2.log("the same liquidityProviders remove Liquidity From the Pool with total amount of shares they hold: ");
        console2.log("");

        for (uint i = 0; i < liquidityProviders.length; i++) {
            liquidityProviders[i] = address(uint160(i + 1));

            vm.startPrank(liquidityProviders[i]);

                uint256 sharesBalance = vault.balanceOf(liquidityProviders[i]);
                vault.approve(address(vault), sharesBalance);
                uint256 assetsReceived = vault.withdraw(sharesBalance);

                console2.log("                                                              * liquidityProvider[",i+1,"] withdrawed assets and received: ", assetsReceived);
                console2.log("");

                assertEq(assetsReceived, USDC.balanceOf(liquidityProviders[i]));


            vm.stopPrank();
        }

        _;
    }


    modifier _addPoolDeposit {
        vm.startPrank(liquidityProvider1);

        uint256 amountToDeposit = vm.randomUint(1e6, 100e6);
        deal(address(USDC), liquidityProvider1, amountToDeposit);

        USDC.approve(address(vault), amountToDeposit);
        uint256 sharesReceived = vault.deposit(amountToDeposit);

        console2.log("amount liquidityProvider1 deposited: ", amountToDeposit);
        console2.log("amount shares liquidityProvider1 received: ", sharesReceived);

        assertEq(amountToDeposit, sharesReceived); // since it's the first deposit, the deposit amount and shares received will be equal
        assertEq(vault.balanceOf(liquidityProvider1), sharesReceived);

        vm.stopPrank();
        _;
    }


    modifier _removeLiquidity {
        vm.startPrank(liquidityProvider1);
        uint256 sharesBalance = vault.balanceOf(liquidityProvider1);

        vault.approve(address(vault), sharesBalance);
        uint256 assetsReceived = vault.withdraw(sharesBalance);

        console2.log("");
        console2.log("liquidityProvider1 decides to remove liquidity with this amount of shares he holds: ", sharesBalance);

        assertEq(USDC.balanceOf(liquidityProvider1), assetsReceived);
        assertEq(sharesBalance, assetsReceived);

        console2.log("this is how much assets he got in return after removing liquidity: ", assetsReceived);

        vm.stopPrank();
        _;
    }

} 