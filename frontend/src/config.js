// File: ./src/config.js

import {config} from "@onflow/fcl"

config()
  .put("accessNode.api", process.env.REACT_APP_ACCESS_NODE) // Configure FCL's Access Node
  .put("challenge.handshake", process.env.REACT_APP_WALLET_DISCOVERY) // Configure FCL's Wallet Discovery mechanism
  .put("0xExample", process.env.REACT_APP_CONTRACT_EXAMPLE) // Will let us use `0xProfile` in our Cadence