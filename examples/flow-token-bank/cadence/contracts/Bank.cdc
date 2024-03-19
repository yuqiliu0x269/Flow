import FungibleToken from "utility/FungibleToken.cdc"
import FlowToken from "utility/FlowToken.cdc"

access(all) contract Bank {
	access(self) var bankVault: @FlowToken.Vault
	access(self) var balances: {Address:UFix64}


	init() {
		self.bankVault <- FlowToken.createEmptyVault() as! @FlowToken.Vault
		self.balances = {}
	}

	access(all) fun deposit(vault: @FlowToken.Vault, address: Address) {
		if let balance = self.balances[address] {
			self.balances[address] = balance + vault.balance
		} else {
			self.balances[address] = vault.balance
		}
		self.bankVault.deposit(from: <- vault)
	}

	access(all) fun withdraw(address: Address, amount: UFix64, receiver: &{FungibleToken.Receiver}) {
		if let balance = self.balances[address] {
			if balance < amount {
				panic("Insufficient balance")
			}
			let vault <- self.bankVault.withdraw(amount: amount)
			receiver.deposit(from: <- vault) // This is where re-entrancy happens
			self.balances[address] = balance - amount
			return
		}
		panic("Nothing deposited")
	}
}
