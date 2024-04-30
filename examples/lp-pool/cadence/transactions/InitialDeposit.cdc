import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import FlowToken from "../contracts/utility/FlowToken.cdc"
import LPToken from "../contracts/LPToken.cdc"
import LiquidityPool from "../contracts/LiquidityPool.cdc"

transaction(amount: UFix64) {
	let flowTokenAdmin: &FlowToken.Administrator
	let lpTokenReceiver: &{FungibleToken.Receiver}

	prepare(signer: AuthAccount) {
		self.flowTokenAdmin = signer
			.borrow<&FlowToken.Administrator>(from: /storage/flowTokenAdmin)
			?? panic("Signer is not FlowToken admin")
		self.lpTokenReceiver = signer
			.getCapability(/public/lpTokenReceiver)
			.borrow<&{FungibleToken.Receiver}>()
			?? panic("Unable to borrow LPToken receiver reference")
	}

	execute {
		let minter <- self.flowTokenAdmin.createNewMinter(allowedAmount: amount)
		let vault <- minter.mintTokens(amount: amount)
		let lpTokenVault <- LiquidityPool.add(<-vault)
		self.lpTokenReceiver.deposit(from: <-lpTokenVault)
		destroy minter
	}
}