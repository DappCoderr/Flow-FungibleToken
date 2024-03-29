import FungibleToken from 0x907dcef430805a20

pub contract ExampleToken: FungibleToken {

    /// Total supply of ExampleTokens in existence
    pub var totalSupply: UFix64


    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)
    pub event TokensMinted(amount: UFix64)
    pub event TokensBurned(amount: UFix64)
    pub event MinterCreated(allowedAmount: UFix64)
    pub event BurnerCreated()


    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {


        pub var balance: UFix64

        init(balance: UFix64) {
            self.balance = balance
        }

        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <-create Vault(balance: amount)
        }

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @ExampleToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            vault.balance = 0.0
            destroy vault
        }

        destroy() {
            ExampleToken.totalSupply = ExampleToken.totalSupply - self.balance
        }
    }

    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    pub resource Administrator {


        pub fun createNewMinter(allowedAmount: UFix64): @Minter {
            emit MinterCreated(allowedAmount: allowedAmount)
            return <-create Minter(allowedAmount: allowedAmount)
        }

        pub fun createNewBurner(): @Burner {
            emit BurnerCreated()
            return <-create Burner()
        }
    }


    pub resource Minter {

        /// The amount of tokens that the minter is allowed to mint
        pub var allowedAmount: UFix64

        pub fun mintTokens(amount: UFix64): @ExampleToken.Vault {
            pre {
                amount > 0.0: "Amount minted must be greater than zero"
                amount <= self.allowedAmount: "Amount minted must be less than the allowed amount"
            }
            ExampleToken.totalSupply = ExampleToken.totalSupply + amount
            self.allowedAmount = self.allowedAmount - amount
            emit TokensMinted(amount: amount)
            return <-create Vault(balance: amount)
        }

        init(allowedAmount: UFix64) {
            self.allowedAmount = allowedAmount
        }
    }


    pub resource Burner {


        pub fun burnTokens(from: @FungibleToken.Vault) {
            let vault <- from as! @ExampleToken.Vault
            let amount = vault.balance
            destroy vault
            emit TokensBurned(amount: amount)
        }
    }

    init() {
        self.totalSupply = 1000.0

        let vault <- create Vault(balance: self.totalSupply)
        self.account.save(<-vault, to: /storage/exampleTokenVault)

        self.account.link<&{FungibleToken.Receiver}>(
            /public/exampleTokenReceiver,
            target: /storage/exampleTokenVault
        )

        self.account.link<&ExampleToken.Vault{FungibleToken.Balance}>(
            /public/exampleTokenBalance,
            target: /storage/exampleTokenVault
        )

        let admin <- create Administrator()
        self.account.save(<-admin, to: /storage/exampleTokenAdmin)

        emit TokensInitialized(initialSupply: self.totalSupply)
    }
}