//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UnstableRegistrar} from "src/L2/UnstableRegistrar.sol";
import {UnstableRegistrarUnstable} from "./UnstableRegistrarUnstable.t.sol";
import {Ownable} from "solady/auth/Ownable.sol";

contract RemoveController is UnstableRegistrarUnstable {
    function test_allowsOwnerToRemoveController(address controller) public {
        vm.prank(owner);
        baseRegistrar.addController(controller);
        assertTrue(baseRegistrar.controllers(controller));

        vm.expectEmit();
        emit UnstableRegistrar.ControllerRemoved(controller);
        vm.prank(owner);
        baseRegistrar.removeController(controller);
        assertFalse(baseRegistrar.controllers(controller));
    }

    function test_reverts_whenCalledByNonOwner(address caller) public {
        vm.assume(caller != owner);
        vm.prank(caller);
        vm.expectRevert(Ownable.Unauthorized.selector);
        baseRegistrar.removeController(caller);
    }
}
