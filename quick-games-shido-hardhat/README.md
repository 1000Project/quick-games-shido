
# Quick Games on SHIDO — Hardhat Starter

Three simple on-chain games (MVP) with house-configurable min/max bets and edge:
- CoinFlip
- HighLowCard (player vs house card, ties = house)
- DiceHighLow (bet on total <7 or >7, 7 = house)

⚠️ RNG uses blockhash and is *not* production-safe. Good for testnets and rapid MVP.
We will upgrade to a commit–reveal or VRF oracle for mainnet fairness.

## Prereqs
- Node.js LTS
- `npm i -g pnpm` (optional but recommended)
- A SHIDO RPC URL + private key for a funded test wallet

## Setup
```bash
pnpm install        # or: npm install
cp .env.example .env
# edit .env with RPC + PRIVATE_KEY
pnpm hardhat compile
```

## Deploy
```bash
pnpm hardhat run scripts/deploy.js --network shido
```

## Verify (if block explorer supports it)
```bash
pnpm hardhat verify --network shido <ADDRESS>
```

## Notes
- House edge is in basis points (bps). 200 = 2%.
- Owner can set min/max bet, edge, and withdraw treasury.
- Each play is a single transaction; emit events for front-end indexing.
