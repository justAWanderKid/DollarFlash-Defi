
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface IFlashLoanReceiver {
    
    function onFlashLoanReceived(uint256 _amount) external returns(bool);

}