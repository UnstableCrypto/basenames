//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721DiscountValidatorUnstable} from "./ERC721DiscountValidatorUnstable.t.sol";

contract IsValidDiscountRegistration is ERC721DiscountValidatorUnstable {
    function test_returnsFalse_whenTheClaimerDoesNotHaveTheToken() public view {
        assertFalse(validator.isValidDiscountRegistration(userA, ""));
    }

    function test_returnsFalse_whenAnotherUserHasTheToken() public {
        token.mint(userA, 1);
        assertFalse(validator.isValidDiscountRegistration(userB, ""));
    }

    function test_returnsTrue_whenTheUserHasTheToken() public {
        token.mint(userA, 1);
        assertTrue(validator.isValidDiscountRegistration(userA, ""));
    }
}
