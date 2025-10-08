
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./HouseConfig.sol";

contract DiceHighLow is HouseConfig {
    event Roll(address indexed player, uint256 bet, bool pickHigh, uint8 d1, uint8 d2, uint8 total, bool win, uint256 payout);

    constructor(uint256 _min, uint256 _max, uint256 _edgeBps)
        HouseConfig(_min, _max, _edgeBps) {}

    function play(bool pickHigh) external payable {
        uint256 bet = msg.value;
        if (bet < minBet || bet > maxBet) revert InvalidBet();

        uint8 d1 = uint8(_rng(6) + 1);
        uint8 d2 = uint8(_rng(6) + 1);
        uint8 total = d1 + d2;

        bool win;
        if (total == 7) {
            win = false; // house on 7
        } else if (pickHigh) {
            win = total > 7;
        } else {
            win = total < 7;
        }

        uint256 payout;
        if (win) {
            uint256 multBps = 20000 - houseEdgeBps; // even money minus edge
            payout = bet * multBps / 10000;
            if (address(this).balance < payout) revert InsufficientTreasury();
            (bool ok, ) = payable(msg.sender).call{value: payout}("");
            require(ok, "payout failed");
        }

        emit Roll(msg.sender, bet, pickHigh, d1, d2, total, win, payout);
    }

    receive() external payable {}
}
