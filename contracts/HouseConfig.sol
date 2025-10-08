
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract HouseConfig {
    address public owner;
    uint256 public minBet;
    uint256 public maxBet;
    uint256 public houseEdgeBps; // e.g., 200 = 2%
    uint256 internal nonce;

    error NotOwner();
    error InvalidBet();
    error InsufficientTreasury();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(uint256 _minBet, uint256 _maxBet, uint256 _edgeBps) {
        owner = msg.sender;
        minBet = _minBet;
        maxBet = _maxBet;
        houseEdgeBps = _edgeBps;
    }

    function setLimits(uint256 _minBet, uint256 _maxBet) external onlyOwner {
        require(_minBet <= _maxBet, "min>max");
        minBet = _minBet;
        maxBet = _maxBet;
        emit LimitsUpdated(_minBet, _maxBet);
    }

    function setEdge(uint256 _edgeBps) external onlyOwner {
        require(_edgeBps <= 1000, "edge too high"); // cap at 10% for safety
        houseEdgeBps = _edgeBps;
        emit EdgeUpdated(_edgeBps);
    }

    function depositTreasury() external payable onlyOwner {
        emit TreasuryDeposit(msg.value);
    }

    function withdrawTreasury(uint256 amount) external onlyOwner {
        if (address(this).balance < amount) revert InsufficientTreasury();
        (bool ok, ) = payable(owner).call{value: amount}("");
        require(ok, "withdraw failed");
        emit TreasuryWithdraw(amount);
    }

    function _rng(uint256 range) internal returns (uint256) {
        // ⚠️ Not production-grade RNG. For MVP only.
        unchecked { nonce++; }
        return uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender, address(this), nonce))
        ) % range;
    }

    event LimitsUpdated(uint256 minBet, uint256 maxBet);
    event EdgeUpdated(uint256 bps);
    event TreasuryDeposit(uint256 amount);
    event TreasuryWithdraw(uint256 amount);
}
