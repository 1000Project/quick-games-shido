
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { SHIDO_RPC_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.24",
  networks: {
    shido: {
      url: SHIDO_RPC_URL || "https://your-shido-rpc.example",
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    }
  }
};
