### What is this project?
It's a simple example featuring a Flow Token Bank smart contract used to demonstrate what re-entrancy attacks may look like in Flow.

### How to run this project?
1. Clone this repository
2. [Install Flow CLI](https://developers.flow.com/tools/flow-cli/install)
3. Open a terminal at the project root and run `flow emulator`
4. Open another terminal at the project root
5. Add two accounts by running `flow accounts create` twice. Let's suppose you name the first account `Alice` and the second account `Bob`.
6. Deploy contracts to the accounts:
   - `flow accounts add-contract cadence/contracts/Bank.cdc –signer Alice`
   - `flow accounts add-contract cadence/contracts/Bank.cdc –signer Bob`
   - `flow accounts add-contract cadence/contracts/MaliciousContract.cdc –signer Bob`
7. Mint tokens to the two accounts:
   - `flow transactions send cadence/transactions/MintTokens.cdc {Alice’s address} 1000.0 –signer emulator-account`
   - `flow transactions send cadence/transactions/MintTokens.cdc {Bob’s address} 1000.0 –signer emulator-account`
8. Deposit tokens to the bank:
   - `flow transactions send cadence/transactions/DepositToBank.cdc 1000.0 –signer Alice`
   - `flow transactions send cadence/transactions/DepositToBank.cdc 1000.0 –signer Bob`
9. Execute the re-entrancy attack:
    - `flow transactions send cadence/transactions/WithdrawFromBankWithMaliciousReceiver.cdc 1000.0 –signer Bob`
10. Now you can check the balance of `Bob` by running `flow transactions send cadence/transactions/LogBalance.cdc --signer Bob`. It should be 2000.0 instead of 1000.0.