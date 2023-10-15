// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ICounter {
    function setNumber(uint256 newNumber) external;

    function increment() external;

    function number() external view returns (uint256);
}
