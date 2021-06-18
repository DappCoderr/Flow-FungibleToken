import React, {useState, useEffect} from "react"
import * as fcl from "@onflow/fcl"
import {Redirect} from "react-router-dom"

export function Auth() {
  const [user, setUser] = useState({loggedIn: null})
  useEffect(() => fcl.currentUser().subscribe(setUser), [])

  if (user.loggedIn) return <Redirect to={"/" + user.addr}/>
    return (
      <div>
        <h1>FCL Wallet Intregation</h1>
        <button onClick={fcl.logIn}>Log In</button>
      </div>
    )
  
}