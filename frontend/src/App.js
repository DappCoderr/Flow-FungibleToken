import React from "react"
import {Auth} from "../src/component/Auth"
import {Account} from "../src/component/Account"
import {BrowserRouter, Route} from "react-router-dom"

export default function App() {
  return (
    <div>
      <BrowserRouter>
        <Route exact path="/0x:address" component={Account} />
        <Route exact path="/" component={Auth} />
      </BrowserRouter>
    </div>
  )
}