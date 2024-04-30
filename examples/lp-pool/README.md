### What is this project?
It's a simplified example of a liquidity pool that demonstrates Cadence's resistence against readonly re-entrancy attack

### How to run this project?
1. Clone this repository
2. [Install Flow CLI](https://developers.flow.com/tools/flow-cli/install)
3. Open a terminal at the project root and run `flow emulator`
4. Open another terminal at the project root
5. Add two accounts by running `flow accounts create` twice. Let's suppose you name the account `Alice`.
6. Deploy contracts to the accounts:
   - `flow accounts add-contract cadence/contracts/LPToken.cdc –signer emulator-account`
   - `flow accounts add-contract cadence/contracts/LiquidityPool.cdc –signer emulator-account`
   - `flow accounts add-contract cadence/contracts/ReadonlyReentrancy.cdc –signer Alice`
7. Make an initial deposit to the pool:
   - `flow transactions send cadence/transactions/InitialDeposit.cdc 10000.0 --signer emulator-account`
7. Mint tokens to Alice's account:
   - `flow transactions send cadence/transactions/MintTokens.cdc {Alice’s address} 1000.0 –signer emulator-account`
8. Run the readonly re-entrancy demonstration:
   - `flow transactions send cadence/transactions/DemonstrateReadonlyReentrancy.cdc 1000.0 --signer Alice`