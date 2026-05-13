//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UnstableRegistrar} from "src/L2/UnstableRegistrar.sol";
import {UnstableRegistrarUnstable} from "./UnstableRegistrarUnstable.t.sol";

contract OwnerOf is UnstableRegistrarUnstable {
    function test_reverts_whenNameHasExpired() public {
        _registrationSetup();
        uint256 expires = _registerName(label, user, duration);

        vm.warp(expires + 1);
        vm.expectRevert(abi.encodeWithSelector(UnstableRegistrar.Expired.selector, id));
        baseRegistrar.ownerOf(id);
    }

    function test_returnsTheOwner(address nameOwner) public {
        vm.assume(nameOwner != address(0));
        _registrationSetup();
        _registerName(label, nameOwner, duration);
        address returnedOwner = baseRegistrar.ownerOf(id);
        assertTrue(returnedOwner == nameOwner);
    }
}
