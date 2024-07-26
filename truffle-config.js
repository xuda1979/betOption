module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545, // Update to your Ganache port
      network_id: "*", // Match any network id
      gas: 8000000 // Increase the gas limit if needed
    }
  },
  compilers: {
    solc: {
      version: "0.8.21"
    }
  }
};
