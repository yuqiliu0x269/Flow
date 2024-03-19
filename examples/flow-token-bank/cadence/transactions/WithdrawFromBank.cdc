// This transaction is a template for a transaction that
// could be used by anyone to send tokens to another account
// that has been set up to receive tokens.
//
// The withdraw amount and the account from getAccount
// would be the parameters to the transaction

import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import FlowToken from "../contracts/utility/FlowToken.cdc"
import Bank from "../contracts/Bank.cdc"

transaction(amount: UFix64) {
	prepare(signer: AuthAccount) {

		// Get a reference to the signer's stored vault
		let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
			?? panic("Could not borrow reference to the owner's Vault!")

		Bank.withdraw(address: signer.address, amount: amount, receiver: vaultRef)
	}

	execute {
	}
}