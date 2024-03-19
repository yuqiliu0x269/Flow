// This transaction deposits some flow to the bank contract

import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import FlowToken from "../contracts/utility/FlowToken.cdc"
import Bank from "../contracts/Bank.cdc"

transaction(amount: UFix64) {
	prepare(signer: AuthAccount) {
		let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
			?? panic("Could not borrow reference to the owner's Vault!")
		let vault <- vaultRef.withdraw(amount: amount) as! @FlowToken.Vault
		Bank.deposit(vault: <-vault, address: signer.address)
	}

	execute {
	}
}