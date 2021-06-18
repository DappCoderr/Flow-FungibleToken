import FungibleToken from 0x907dcef430805a20
import ExampleToken from 0x907dcef430805a20

transaction {

    prepare(signer: AuthAccount) {

        // Return early if the account already stores a ExampleToken Vault
        if signer.borrow<&ExampleToken.Vault>(from: /storage/exampleTokenVault) != nil {
            return
        }

        // Create a new ExampleToken Vault and put it in storage
        signer.save(
            <-ExampleToken.createEmptyVault(),
            to: /storage/exampleTokenVault
        )

        // Create a public capability to the Vault that only exposes
        // the deposit function through the Receiver interface
        signer.link<&ExampleToken.Vault{FungibleToken.Receiver}>(
            /public/exampleTokenReceiver,
            target: /storage/exampleTokenVault
        )

        // Create a public capability to the Vault that only exposes
        // the balance field through the Balance interface
        signer.link<&ExampleToken.Vault{FungibleToken.Balance}>(
            /public/exampleTokenBalance,
            target: /storage/exampleTokenVault
        )
    }
}