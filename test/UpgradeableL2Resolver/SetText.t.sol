// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UpgradeableL2ResolverUnstable} from "./UpgradeableL2ResolverUnstable.t.sol";
import {ResolverUnstable} from "src/L2/resolver/ResolverUnstable.sol";
import {TextResolver} from "src/L2/resolver/TextResolver.sol";

contract SetText is UpgradeableL2ResolverUnstable {
    string key = "key";
    string value = "value";

    function test_reverts_forUnauthorizedUser() public {
        vm.expectRevert(abi.encodeWithSelector(ResolverUnstable.NotAuthorized.selector, node, notUser));
        vm.prank(notUser);
        resolver.setText(node, key, value);
    }

    function test_setsTheTextValue_forTheSpecifiedKey() public {
        vm.prank(user);
        resolver.setText(node, key, value);
        string memory retValue = resolver.text(node, key);
        assertEq(keccak256(bytes(retValue)), keccak256(bytes(value)));
    }

    function test_canClearRecord() public {
        vm.startPrank(user);

        resolver.setText(node, key, value);
        assertEq(resolver.text(node, key), value);

        resolver.clearRecords(node);
        assertEq(resolver.text(node, key), "");

        vm.stopPrank();
    }
}
