// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {RegistrarControllerUnstable} from "./RegistrarControllerUnstable.t.sol";

contract Valid is RegistrarControllerUnstable {
    function test_returnsTrue_whenValid() public view {
        assertTrue(controller.valid("abc"));
        assertTrue(controller.valid("abcdef"));
        assertTrue(controller.valid("abcdefghijklmnop"));
    }

    function test_returnsFalse_whenInvalid() public view {
        assertFalse(controller.valid(""));
        assertFalse(controller.valid("a"));
        assertFalse(controller.valid("ab"));
    }
}
