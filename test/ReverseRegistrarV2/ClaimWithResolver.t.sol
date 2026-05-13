//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ReverseRegistrarV2Unstable} from "./ReverseRegistrarV2Unstable.t.sol";
import {ReverseRegistrarV2} from "src/L2/ReverseRegistrarV2.sol";
import {Sha3} from "src/lib/Sha3.sol";
import {BASE_REVERSE_NODE} from "src/util/Constants.sol";

contract ClaimWithResolver is ReverseRegistrarV2Unstable {
    function test_allowsUser_toClaimWithResolver() public {
        bytes32 labelHash = Sha3.hexAddress(user);
        bytes32 reverseNode = keccak256(abi.encodePacked(BASE_REVERSE_NODE, labelHash));

        vm.expectEmit(address(reverse));
        emit ReverseRegistrarV2.UnstableReverseClaimed(user, reverseNode);
        vm.prank(user);
        bytes32 returnedReverseNode = reverse.claimWithResolver(user, address(resolver));
        assertTrue(reverseNode == returnedReverseNode);
        address retOwner = registry.owner(reverseNode);
        assertTrue(retOwner == user);
        address retResolver = registry.resolver(reverseNode);
        assertTrue(retResolver == address(resolver));
    }
}
