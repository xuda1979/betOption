const BetOption = artifacts.require("BetOption");

module.exports = async function (deployer, network, accounts) {
  const ownerAddress = accounts[0];

  try {
    console.log("Deploying BetOption...");
    await deployer.deploy(BetOption, ownerAddress, { gas: 8000000 });
    const betOptionInstance = await BetOption.deployed();
    console.log("BetOption deployed at address:", betOptionInstance.address);
  } catch (error) {
    console.error("Deployment failed:", error);
  }
};
