// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/ICounter.sol";

contract Counter is ICounter {
    uint256 public number;

    function setNumber(uint256 newNumber) public override {
        number = newNumber;
    }

    function increment() public override {
        number++;
    }
}
