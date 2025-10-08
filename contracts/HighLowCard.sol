
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./HouseConfig.sol";

contract HighLowCard is HouseConfig {
    event Play(address indexed player, uint256 bet, bool pickHigh, uint8 houseCard, uint8 playerCard, bool win, uint256 payout);

    constructor(uint256 _min, uint256 _max, uint256 _edgeBps)
        HouseConfig(_min, _max, _edgeBps) {}

    function play(bool pickHigh) external payable {
        uint256 bet = msg.value;
        if (bet < minBet || bet > maxBet) revert InvalidBet();

        uint8 houseCard = uint8(_rng(13) + 1);
        uint8 playerCard = uint8(_rng(13) + 1);

        bool win;
        if (playerCard == houseCard) {
            win = false; // tie = house
        } else if (pickHigh) {
            win = playerCard > houseCard;
        } else {
            win = playerCard < houseCard;
        }

        uint256 payout;
        if (win) {
            uint256 multBps = 20000 - houseEdgeBps; // ~even money minus edge
            payout = bet * multBps / 10000;
            if (address(this).balance < payout) revert InsufficientTreasury();
            (bool ok, ) = payable(msg.sender).call{value: payout}("");
            require(ok, "payout failed");
        }

        emit Play(msg.sender, bet, pickHigh, houseCard, playerCard, win, payout);
    }

    receive() external payable {}
}
