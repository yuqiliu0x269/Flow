import FungibleToken from "utility/FungibleToken.cdc"
import LiquidityPool from "LiquidityPool.cdc"

access(all) contract ReadonlyReentrancy {
	pub resource Receiver: FungibleToken.Receiver {
		access(self) let receiver: Address

		pub fun deposit(from: @FungibleToken.Vault) {
			let receiverRef = getAccount(self.receiver)
				.getCapability(/public/flowTokenReceiver)
				.borrow<&{FungibleToken.Receiver}>()
				?? panic("Unable to borrow receiver reference")
			log("LPToken price in re-entrancy: ".concat(LiquidityPool.getPrice().toString()))
			receiverRef.deposit(from: <-from)
		}

		init(receiver: Address) {
			self.receiver = receiver
		}
	}

	pub fun createReceiver(receiver: Address): @Receiver {
		return <- create Receiver(receiver: receiver)
	}
}
