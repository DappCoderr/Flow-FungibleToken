import ExampleToken from 0x907dcef430805a20

pub fun main(): UFix64 {

    let supply = ExampleToken.totalSupply

    log(supply)

    return supply
}