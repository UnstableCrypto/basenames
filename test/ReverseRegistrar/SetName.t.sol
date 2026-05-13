//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ReverseRegistrarUnstable} from "./ReverseRegistrarUnstable.t.sol";
import {ReverseRegistrar} from "src/L2/ReverseRegistrar.sol";
import {Sha3} from "src/lib/Sha3.sol";
import {BASE_REVERSE_NODE} from "src/util/Constants.sol";
import {NameResolver, MockNameResolver} from "test/mocks/MockNameResolver.sol";

contract SetName is ReverseRegistrarUnstable {
    NameResolver resolver = new MockNameResolver();

    function test_setsName() public {
        bytes32 labelHash = Sha3.hexAddress(user);
        bytes32 baseReverseNode = keccak256(abi.encodePacked(BASE_REVERSE_NODE, labelHash));

        string memory name = "name";
        vm.prank(owner);
        reverse.setDefaultResolver(address(resolver));

        vm.expectEmit(address(reverse));
        emit ReverseRegistrar.UnstableReverseClaimed(user, baseReverseNode);
        vm.prank(user);
        bytes32 returnedReverseNode = reverse.setName(name);

        assertTrue(baseReverseNode == returnedReverseNode);
        address retUnstableOwner = registry.owner(baseReverseNode);
        assertTrue(retUnstableOwner == user);
        address retUnstableResolver = registry.resolver(baseReverseNode);
        assertTrue(retUnstableResolver == address(resolver));
        assertTrue(keccak256(abi.encode(resolver.name(baseReverseNode))) == keccak256(abi.encode(name)));
    }
}
