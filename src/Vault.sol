
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is ERC20, Ownable {

    using Math for uint256;
    using SafeERC20 for IERC20;

    error Vault__AmountToDepositCannotBeZero();
    error Vault__CallerIsNotFlashLoanContract();
    error Vault__SettingFlashLoanContractToAddressZero();
    error Vault__FlashLoanContractAddressNotInitialized();
    error Vault__SpecifiedSharesAmountExceedsCallerBalance();

    event Deposited(address indexed _depositor, uint256 indexed _amountDeposited, uint256 indexed _sharesReceived);
    event Withdrawal(address indexed _withdrawer, uint256 indexed _amountAssetsReceived, uint256 indexed _amountSharesBurned);

    IERC20 immutable public asset;
    address public flashLoan;

    // 1. deploy `Vault` contract.
    // 2. deploy `FlashLoan` contract.
    // 3. owner of `Vault` calls `setFlashLoanContract()` to set the `flashLoan` address to `FlashLoan` contract address.
    // 4. then `FlashLoan` contract calls `Vault::approveFlashLoan()` to approve himself.
    // 5. then we can offer flashloans to users after liquidity providers deposited atleast 1e6 USDC to the Vault.
    constructor(IERC20 _token) ERC20("LPTokens", "LPT") Ownable(msg.sender) {
        asset = _token;
    }

    modifier onlyFlashLoan {
        if (flashLoan != msg.sender) {

            revert Vault__CallerIsNotFlashLoanContract();
        }
        _;
    }

    function setFlashLoanContract(address _flashLoan) external onlyOwner {

        if (_flashLoan == address(0)) {
            revert Vault__SettingFlashLoanContractToAddressZero();
        }

        flashLoan = _flashLoan;

    }


    function approveFlashLoan() external onlyFlashLoan returns(bool) {

        if (flashLoan == address(0)) {
            revert Vault__FlashLoanContractAddressNotInitialized();
        }

        asset.approve(flashLoan, type(uint256).max);
        return true;
        
    }


    function deposit(uint256 _assets) external returns(uint256) {
        if (_assets == 0) {
            revert Vault__AmountToDepositCannotBeZero();
        }

        uint256 _shares = convertAssetToShares(_assets);

        asset.safeTransferFrom(msg.sender, address(this), _assets);
        _mint(msg.sender, _shares);

        emit Deposited(msg.sender, _assets, _shares);

        return _shares;
    }

    
    function withdraw(uint256 _shares) external returns(uint256) {
        if (_shares > balanceOf(msg.sender)) {
            revert Vault__SpecifiedSharesAmountExceedsCallerBalance();
        }

        uint256 _assets = convertSharesToAsset(_shares);

        IERC20(address(this)).safeTransferFrom(msg.sender, address(this), _shares); // transfer LPTokens from  msg.sender to address(this).
        _burn(address(this), _shares);
        emit Withdrawal(msg.sender, _assets, _shares);

        asset.safeTransfer(msg.sender, _assets);
        
        return _assets;
    }


    function convertAssetToShares(uint256 _assets) public view returns(uint256) {

        //   _assets * (totalShares + 1)
        // ------------------------------ = shares amount
        //         totalAssets + 1

        // (7693 * 1) / 1 = 
        return _assets.mulDiv(totalSupply() + 1, totalAssets() + 1, Math.Rounding.Floor);
    }

    function convertSharesToAsset(uint256 _shares) public view returns(uint256) {

        //   _shares * (totalAssets + 1)
        // ------------------------------- = asset amount
        //         totalSupply + 1

        return _shares.mulDiv(totalAssets() + 1, totalSupply() + 1, Math.Rounding.Floor);
    }

    function totalAssets() public view returns(uint256) {
        return asset.balanceOf(address(this));
    }


}