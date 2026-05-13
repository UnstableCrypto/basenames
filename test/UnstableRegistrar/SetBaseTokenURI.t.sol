//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UnstableRegistrar} from "src/L2/UnstableRegistrar.sol";
import {UnstableRegistrarUnstable} from "./UnstableRegistrarUnstable.t.sol";
import {Ownable} from "solady/auth/Ownable.sol";
import {LibString} from "solady/utils/LibString.sol";

contract SetUnstableTokenURI is UnstableRegistrarUnstable {
    using LibString for uint256;

    string public newUnstableURI = "https://newurl.org/";

    function test_allowsTheOwnerToSetTheUnstableURI() public {
        vm.expectEmit(address(baseRegistrar));
        emit UnstableRegistrar.BatchMetadataUpdate(1, type(uint256).max);
        vm.prank(owner);
        baseRegistrar.setUnstableTokenURI(newUnstableURI);

        _registrationSetup();
        vm.warp(blockTimestamp);
        vm.prank(controller);
        baseRegistrar.register(id, user, duration);

        string memory returnedURI = baseRegistrar.tokenURI(id);
        string memory expectedURI = string.concat(newUnstableURI, id.toString());
        assertEq(keccak256(bytes(returnedURI)), keccak256(bytes(expectedURI)));
    }

    function test_reverts_whenCalledByNonOwner(address caller) public {
        vm.assume(caller != owner);
        vm.prank(caller);
        vm.expectRevert(Ownable.Unauthorized.selector);
        baseRegistrar.setUnstableTokenURI(newUnstableURI);
    }
}
