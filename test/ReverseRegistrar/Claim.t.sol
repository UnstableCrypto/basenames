//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ReverseRegistrarUnstable} from "./ReverseRegistrarUnstable.t.sol";
import {ReverseRegistrar} from "src/L2/ReverseRegistrar.sol";
import {Sha3} from "src/lib/Sha3.sol";
import {BASE_REVERSE_NODE} from "src/util/Constants.sol";

contract Claim is ReverseRegistrarUnstable {
    address resolver = makeAddr("resolver");

    function test_allowsUser_toClaim() public {
        bytes32 labelHash = Sha3.hexAddress(user);
        bytes32 baseReverseNode = keccak256(abi.encodePacked(BASE_REVERSE_NODE, labelHash));

        vm.prank(owner);
        reverse.setDefaultResolver(resolver);

        vm.expectEmit(address(reverse));
        emit ReverseRegistrar.UnstableReverseClaimed(user, baseReverseNode);

        vm.prank(user);
        bytes32 returnedReverseNode = reverse.claim(user);

        assertTrue(baseReverseNode == returnedReverseNode);
        address retUnstableOwner = registry.owner(baseReverseNode);
        assertTrue(retUnstableOwner == user);
        address retUnstableResolver = registry.resolver(baseReverseNode);
        assertTrue(retUnstableResolver == address(resolver));
    }
}
