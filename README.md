
<br>

> *just a simple flashloan protocol i made for fun.*

# DollarFlash Protocol

`DollarFlash` is a decentralized finance (DeFi) protocol that offers `USDC` flash loans, allowing users to borrow `USDC` without collateral, provided the loan is repaid within the same transaction. This protocol is designed to cater to both liquidity providers and flash loan borrowers, ensuring a balanced and profitable ecosystem.

## How It Works

### For Liquidity Providers

Liquidity providers can deposit their `USDC` into the `DollarFlash` protocol, which is pooled and made available for flash loans. In return for providing liquidity, providers receive LP Tokens that represent their share in the pool.

#### Key Points:
- **Deposit USDC:** Liquidity providers deposit `USDC` into the `DollarFlash` protocol.
- **Receive LP Tokens:** Upon depositing, providers receive LP Tokens, which represent their share in the liquidity pool.
- **Earn Fees:** Every time a flash loan is executed, the borrower pays a `0.3%` fee based on the borrowed amount. These fees are distributed among liquidity providers, increasing the value of their `LP Tokens`.
- **Withdraw Profits:** Liquidity providers can redeem their LP Tokens for `USDC` at any time. The amount of `USDC` received will include their initial deposit plus a share of the accumulated fees.

### For Flash Loan Borrowers

Flash loans on `DollarFlash` allow users to borrow USDC instantly without collateral, provided that the loan is repaid within the same transaction. These loans are ideal for arbitrage opportunities, collateral swaps, or liquidations.

#### Key Points:
- **Instant Loans:** Borrow `USDC` without collateral for the duration of a single transaction.
- **0.3% Fee:** A fee of `0.3%` of the borrowed amount is paid to the liquidity pool.
- **Flexible Use Cases:** Use flash loans for various DeFi strategies like arbitrage, liquidation, and more.

## Example Workflow

1. **Deposit:** A user deposits 1,000 `USDC` into the `DollarFlash` pool and receives LP Tokens equivalent to their share in the pool.
2. **Borrow:** Another user borrows 500 `USDC` as a flash loan and pays a fee of 1.5 `USDC` (0.3% of 500 USDC).
3. **Profit Distribution:** The 1.5 `USDC` fee is distributed among all liquidity providers, increasing the value of the LP Tokens.
4. **Withdraw:** The original liquidity provider can later redeem their LP Tokens, receiving their initial 1,000 `USDC` plus a share of the accumulated fees.

