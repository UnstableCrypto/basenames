// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UpgradeableL2ResolverUnstable} from "./UpgradeableL2ResolverUnstable.t.sol";
import {ResolverUnstable} from "src/L2/resolver/ResolverUnstable.sol";

import {IVersionableResolver} from "ens-contracts/resolvers/profiles/IVersionableResolver.sol";

contract ClearRecords is UpgradeableL2ResolverUnstable {
    function test_reverts_forUnauthorizedUser() public {
        vm.expectRevert(abi.encodeWithSelector(ResolverUnstable.NotAuthorized.selector, node, notUser));
        vm.prank(notUser);
        resolver.clearRecords(node);
    }

    function test_clearRecords() public {
        uint64 currentRecordVersion = resolver.recordVersions(node);
        vm.prank(user);
        vm.expectEmit(address(resolver));
        emit IVersionableResolver.VersionChanged(node, currentRecordVersion + 1);
        resolver.clearRecords(node);
    }
}
