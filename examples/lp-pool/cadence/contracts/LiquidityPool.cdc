import FungibleToken from "utility/FungibleToken.cdc"
import FlowToken from "utility/FlowToken.cdc"
import LPToken from "LPToken.cdc"

pub contract LiquidityPool {
    access(self) let flowTokenVault : @FlowToken.Vault
    access(self) let minter: @LPToken.Minter
    access(self) let burner: @LPToken.Burner

    init() {
        self.flowTokenVault <- FlowToken.createEmptyVault() as! @FlowToken.Vault
        let admin = self.account.borrow<&LPToken.Administrator>(from: /storage/lpTokenAdmin)
            ?? panic("Contract not deployed to the administrator account of LPToken")
        self.minter <- admin.createNewMinter(allowedAmount: UFix64.max)
        self.burner <- admin.createNewBurner()
    }

    // Add liquidity to the pool
    pub fun add(_ flowTokenVault: @FlowToken.Vault) : @LPToken.Vault {
        let depositAmount = flowTokenVault.balance
        let lpTokensToMint = LPToken.totalSupply == 0.0
            ? depositAmount
            : depositAmount * LPToken.totalSupply / self.flowTokenVault.balance
        self.flowTokenVault.deposit(from: <- flowTokenVault)
        return <- self.minter.mintTokens(amount: lpTokensToMint)
    }

    // Remove liquidity from the pool
    pub fun remove(_ lpTokenVault: @LPToken.Vault, receiver: &{FungibleToken.Receiver}) {
        let tokenAmountToWithdraw = lpTokenVault.balance * self.flowTokenVault.balance / LPToken.totalSupply
        self.burner.burnTokens(from: <-lpTokenVault)
        let vault <- self.flowTokenVault.withdraw(amount: tokenAmountToWithdraw)
        receiver.deposit(from: <-vault)
    }

    pub fun getPrice(): UFix64 {
        return self.flowTokenVault.balance / LPToken.totalSupply
    }
}
