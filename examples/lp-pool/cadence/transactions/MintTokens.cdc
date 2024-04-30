import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import FlowToken from "../contracts/utility/FlowToken.cdc"

transaction(recipient: Address, amount: UFix64) {
	let tokenAdmin: &FlowToken.Administrator
	let tokenReceiver: &{FungibleToken.Receiver}
	let tokenBalance: &{FungibleToken.Balance}

	prepare(signer: AuthAccount) {
		self.tokenAdmin = signer
			.borrow<&FlowToken.Administrator>(from: /storage/flowTokenAdmin)
			?? panic("Signer is not the token admin")

		self.tokenReceiver = getAccount(recipient)
			.getCapability(/public/flowTokenReceiver)
			.borrow<&{FungibleToken.Receiver}>()
			?? panic("Unable to borrow receiver reference")

		self.tokenBalance = getAccount(recipient)
			.getCapability(/public/flowTokenBalance)
			.borrow<&{FungibleToken.Balance}>()
			?? panic("Unable to borrow balance reference")
	}

	execute {
		let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
		let mintedVault <- minter.mintTokens(amount: amount)

		self.tokenReceiver.deposit(from: <-mintedVault)

		destroy minter

		log("Minted ".concat(amount.toString()).concat("tokens for ").concat(recipient.toString()).concat(". Current balance: ").concat(self.tokenBalance.balance.toString()))
	}
}