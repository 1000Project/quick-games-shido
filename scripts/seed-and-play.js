const hre = require("hardhat");

async function main() {
  const [player] = await hre.ethers.getSigners();

  // --- CONNECT TO CONTRACT ---
  const coin = await hre.ethers.getContractAt(
    "CoinFlip",
    "0x592ed631d646087CC6DCFc226Cb18C224B66F364"
  );

  // --- FUND TREASURY ---
  console.log("Depositing to contract treasury...");
  const fundTx = await coin.depositTreasury({
    value: hre.ethers.parseEther("0.25"),
  });
  await fundTx.wait();
  console.log("Treasury funded ✔️");

  // --- PLAY A ROUND ---
  console.log("Playing a round (bet 0.001 on HEADS)...");
  const playTx = await coin.play(true, {
    value: hre.ethers.parseEther("0.001"),
  });
  console.log("Tx sent:", playTx.hash);
  await playTx.wait();

  console.log("✅ Round complete! Check ShidoScan for result.");
}

main().catch((err) => {
  console.error("❌ Error:", err);
  process.exit(1);
});
