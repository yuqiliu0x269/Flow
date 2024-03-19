// This transaction just adds the default vault, balance and receiver to an account
// this should be added to 0x04 and 0x05

import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import FlowToken from "../contracts/utility/FlowToken.cdc"

transaction {

	prepare(signer: AuthAccount) {

		if signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) == nil {
			signer.save(<-FlowToken.createEmptyVault(), to: /storage/flowTokenVault)

			signer.link<&FlowToken.Vault{FungibleToken.Receiver}>(
				/public/flowTokenReceiver,
				target: /storage/flowTokenVault
			)

			signer.link<&FlowToken.Vault{FungibleToken.Balance}>(
				/public/flowTokenBalance,
				target: /storage/flowTokenVault
			)
		}
	}
}
