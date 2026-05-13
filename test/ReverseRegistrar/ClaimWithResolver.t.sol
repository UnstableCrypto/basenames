//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ReverseRegistrarUnstable} from "./ReverseRegistrarUnstable.t.sol";
import {ReverseRegistrar} from "src/L2/ReverseRegistrar.sol";
import {Sha3} from "src/lib/Sha3.sol";
import {BASE_REVERSE_NODE} from "src/util/Constants.sol";

contract ClaimWithResolver is ReverseRegistrarUnstable {
    address resolver = makeAddr("resolver");

    function test_allowsUser_toClaimWithResolver() public {
        bytes32 labelHash = Sha3.hexAddress(user);
        bytes32 reverseNode = keccak256(abi.encodePacked(BASE_REVERSE_NODE, labelHash));

        vm.expectEmit(address(reverse));
        emit ReverseRegistrar.UnstableReverseClaimed(user, reverseNode);
        vm.prank(user);
        bytes32 returnedReverseNode = reverse.claimWithResolver(user, resolver);
        assertTrue(reverseNode == returnedReverseNode);
        address retOwner = registry.owner(reverseNode);
        assertTrue(retOwner == user);
        address retResolver = registry.resolver(reverseNode);
        assertTrue(retResolver == resolver);
    }
}
