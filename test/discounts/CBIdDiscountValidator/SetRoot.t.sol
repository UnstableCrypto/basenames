//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "solady/auth/Ownable.sol";
import {CBIdDiscountValidatorUnstable} from "./CBIdDiscountValidatorUnstable.t.sol";

contract SetRoot is CBIdDiscountValidatorUnstable {
    function test_reverts_ifCalledByNonowner(address caller) public {
        vm.assume(caller != address(0) && caller != owner);
        vm.expectRevert(Ownable.Unauthorized.selector);
        vm.prank(caller);
        validator.setRoot(bytes32(0));
    }

    function test_allowsTheOwnerToSetTheRoot(bytes32 newRoot) public {
        vm.assume(newRoot != root);
        assertEq(validator.root(), root);
        vm.prank(owner);
        validator.setRoot(bytes32(0));
        assertEq(validator.root(), bytes32(0));
    }
}
