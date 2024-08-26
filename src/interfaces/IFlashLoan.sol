
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

interface IFlashLoan {

    function flashLoan(address _flashLoanReceiver, uint256 _amount) external;

    function getFee(uint256 _amount) external pure returns(uint256);

}