//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {UnstableRegistrarUnstable} from "./UnstableRegistrarUnstable.t.sol";

contract Symbol is UnstableRegistrarUnstable {
    function test_symbolIsSetAsExpected() public view {
        string memory expectedSymbol = "BASENAME";
        assertEq(keccak256(bytes(baseRegistrar.symbol())), keccak256(bytes(expectedSymbol)));
    }
}
