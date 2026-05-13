// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UpgradeableL2ResolverUnstable} from "./UpgradeableL2ResolverUnstable.t.sol";
import {ResolverUnstable} from "src/L2/resolver/ResolverUnstable.sol";
import {DNSResolver} from "src/L2/resolver/DNSResolver.sol";

contract SetZonehash is UpgradeableL2ResolverUnstable {
    bytes zonehash = bytes("zonehash");

    function test_reverts_forUnauthorizedUser() public {
        vm.expectRevert(abi.encodeWithSelector(ResolverUnstable.NotAuthorized.selector, node, notUser));
        vm.prank(notUser);
        resolver.setZonehash(node, zonehash);
    }

    function test_setsZonehash() public {
        vm.prank(user);
        resolver.setZonehash(node, zonehash);
        assertEq(keccak256(resolver.zonehash(node)), keccak256(zonehash));
    }

    function test_canClearRecord() public {
        vm.startPrank(user);

        resolver.setZonehash(node, zonehash);
        assertEq(resolver.zonehash(node), zonehash);

        resolver.clearRecords(node);
        assertEq(resolver.zonehash(node), "");

        vm.stopPrank();
    }
}
