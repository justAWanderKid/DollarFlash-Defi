
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FlashLoan} from "../src/FlashLoan.sol";
import {Vault} from "../src/Vault.sol";
import {IVault} from "../src/interfaces/IVault.sol";
import {UsdcToken} from "../test/mocks/UsdcToken.sol";

contract DeployScript is Script {

    Vault vault;
    FlashLoan flashLoan;
    UsdcToken usdc;

    address deployer = makeAddr("deployer");

    function run() external {
        vm.startBroadcast(deployer);

        usdc = new UsdcToken();
        vault = new Vault(usdc);
        flashLoan = new FlashLoan(IVault(address(vault)));

        vault.setFlashLoanContract(address(flashLoan));

        vm.stopBroadcast();
    }

}