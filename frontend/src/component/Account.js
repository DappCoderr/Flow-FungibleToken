import React, {useState, useEffect} from "react"
import * as fcl from "@onflow/fcl"
import {Redirect} from "react-router-dom"

export function Account() {
    const [user, setUser] = useState({loggedIn: null})
    const [balance, setBalance] = useState(0);
    const [addr, setAddr] = useState(null);
    const [amount, setAmount] = useState(null);
    const [status, setStatus] = useState("Not Started");
    const [transaction, setTransaction] = useState(null)
    useEffect(() => fcl.currentUser().subscribe(setUser), [])

  if (user.loggedIn) {
      return(
          <div>
              <h1>Send Tokens</h1>
              <button onClick={fcl.unauthenticate}>Log out</button>
              <p>Account: {user.addr}</p>
              <code>Balance: {balance}</code>
              <input placeholder='Receiver Address' onChange={updateAddr}/>
              <input placeholder='Amount' onChange={updateAmount}/>
              <button>Send Token</button>
          </div>
      )
  }
    return <Redirect to={"/"}/>
}


