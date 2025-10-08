
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./HouseConfig.sol";

contract CoinFlip is HouseConfig {
    event Flip(address indexed player, uint256 bet, bool choiceHeads, bool win, uint256 payout, uint256 result);

    constructor(uint256 _min, uint256 _max, uint256 _edgeBps)
        HouseConfig(_min, _max, _edgeBps) {}

    function play(bool choiceHeads) external payable {
        uint256 bet = msg.value;
        if (bet < minBet || bet > maxBet) revert InvalidBet();

        uint256 result = _rng(2); // 0 or 1
        bool heads = (result == 1);
        bool win = (heads == choiceHeads);

        uint256 payout;
        if (win) {
            uint256 multBps = 20000 - houseEdgeBps; // 2.0x minus edge
            payout = bet * multBps / 10000;
            if (address(this).balance < payout) revert InsufficientTreasury();
            (bool ok, ) = payable(msg.sender).call{value: payout}("");
            require(ok, "payout failed");
        }

        emit Flip(msg.sender, bet, choiceHeads, win, payout, result);
    }

    receive() external payable {}
}
