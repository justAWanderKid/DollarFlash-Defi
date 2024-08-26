
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVault {
    
    function asset() external view returns(address);

    function approveFlashLoan() external returns(bool);

}