import FlowToken from "../contracts/utility/FlowToken.cdc"

transaction {
	prepare(signer: AuthAccount) {
		let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
			?? panic("Could not borrow reference to the owner's Vault!")
		log(signer.address.toString().concat(" : ").concat(vaultRef.balance.toString()))
	}
}