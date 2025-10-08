
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer:", deployer.address);

  const minBet = hre.ethers.parseEther("0.001");
  const maxBet = hre.ethers.parseEther("1");
  const edgeBps = 200; // 2%

  const CoinFlip = await hre.ethers.getContractFactory("CoinFlip");
  const coin = await CoinFlip.deploy(minBet, maxBet, edgeBps);
  await coin.waitForDeployment();
  console.log("CoinFlip:", await coin.getAddress());

  const HighLowCard = await hre.ethers.getContractFactory("HighLowCard");
  const card = await HighLowCard.deploy(minBet, maxBet, edgeBps);
  await card.waitForDeployment();
  console.log("HighLowCard:", await card.getAddress());

  const DiceHighLow = await hre.ethers.getContractFactory("DiceHighLow");
  const dice = await DiceHighLow.deploy(minBet, maxBet, edgeBps);
  await dice.waitForDeployment();
  console.log("DiceHighLow:", await dice.getAddress());
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
