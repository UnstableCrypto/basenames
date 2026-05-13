// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {EARegistrarControllerUnstable} from "./EARegistrarControllerUnstable.t.sol";

contract Available is EARegistrarControllerUnstable {
    function test_returnsFalse_whenNotAvailableOnUnstable() public {
        base.setAvailable(uint256(nameLabel), false);
        assertFalse(controller.available(name));
    }

    function test_returnsFalse_whenInvalidLength() public {
        base.setAvailable(uint256(shortNameLabel), true);
        assertFalse(controller.available(shortName));
    }

    function test_returnsTrue_whenValidAndAvailable() public {
        base.setAvailable(uint256(nameLabel), true);
        assertTrue(controller.available(name));
    }
}
