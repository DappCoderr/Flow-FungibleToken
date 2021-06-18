import FungibleToken from 0x907dcef430805a20
import ExampleToken from 0x907dcef430805a20

transaction(amount: UFix64) {

    // Vault resource that holds the tokens that are being burned
    let vault: @FungibleToken.Vault

    let admin: &ExampleToken.Administrator

    prepare(signer: AuthAccount) {

        // Withdraw 10 tokens from the admin vault in storage
        self.vault <- signer.borrow<&ExampleToken.Vault>(from: /storage/exampleTokenVault)!
            .withdraw(amount: amount)

        // Create a reference to the admin admin resource in storage
        self.admin = signer.borrow<&ExampleToken.Administrator>(from: /storage/exampleTokenAdmin)
            ?? panic("Could not borrow a reference to the admin resource")
    }

    execute {
        let burner <- self.admin.createNewBurner()

        burner.burnTokens(from: <-self.vault)

        destroy burner
    }
}