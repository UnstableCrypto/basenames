// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UpgradeableL2ResolverUnstable} from "./UpgradeableL2ResolverUnstable.t.sol";
import {ResolverUnstable} from "src/L2/resolver/ResolverUnstable.sol";
import {NameResolver} from "src/L2/resolver/NameResolver.sol";

contract SetName is UpgradeableL2ResolverUnstable {
    function test_reverts_forUnauthorizedUser() public {
        vm.expectRevert(abi.encodeWithSelector(ResolverUnstable.NotAuthorized.selector, node, notUser));
        vm.prank(notUser);
        resolver.setName(node, name);
    }

    function test_setsTheName() public {
        vm.prank(user);
        resolver.setName(node, name);
        string memory retName = resolver.name(node);
        assertEq(keccak256(bytes(name)), keccak256(bytes(retName)));
    }

    function test_canClearRecord() public {
        vm.startPrank(user);

        resolver.setName(node, name);
        assertEq(resolver.name(node), name);

        resolver.clearRecords(node);
        assertEq(resolver.name(node), "");

        vm.stopPrank();
    }
}
