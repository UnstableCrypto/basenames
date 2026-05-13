// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {UpgradeableL2ResolverUnstable} from "./UpgradeableL2ResolverUnstable.t.sol";
import {BASE_ETH_NODE} from "src/util/Constants.sol";
import {ResolverUnstable} from "src/L2/resolver/ResolverUnstable.sol";

// Because isAuthorised() is an internal method, we test it indirectly here by using `setAddr()` which
// checks the authorization status via `isAuthorised()`.
contract IsAuthorised is UpgradeableL2ResolverUnstable {
    function test_returnsTrue_ifSenderIsController() public {
        vm.prank(controller);
        resolver.setAddr(node, user);
        assertEq(resolver.addr(node), user);
    }

    function test_returnsTrue_ifSenderIsReverse() public {
        vm.prank(reverse);
        resolver.setAddr(node, user);
        assertEq(resolver.addr(node), user);
    }

    function test_returnsFalse_ifSenderIsNotAuthorised(address operator) public notProxyAdmin(operator) {
        vm.assume(operator != controller && operator != reverse && operator != user);

        vm.prank(operator);
        vm.expectRevert(abi.encodeWithSelector(ResolverUnstable.NotAuthorized.selector, node, operator));
        resolver.setAddr(node, user);
    }

    function test_returnsTrue_ifSenderIOwnerOfNode() public {
        vm.prank(owner);
        registry.setSubnodeOwner(BASE_ETH_NODE, label, user);
        vm.prank(user);
        resolver.setAddr(node, user);
        assertEq(resolver.addr(node), user);
    }

    function test_returnsTrue_ifSenderIsOperatorOfNode(address operator) public notProxyAdmin(operator) {
        vm.assume(operator != user);
        vm.prank(owner);
        registry.setSubnodeOwner(BASE_ETH_NODE, label, user);
        vm.prank(user);
        resolver.setApprovalForAll(operator, true);
        vm.prank(operator);
        resolver.setAddr(node, user);
        assertEq(resolver.addr(node), user);
    }

    function test_returnsTrue_ifSenderIDelegateOfNode(address operator) public notProxyAdmin(operator) {
        vm.assume(operator != user);
        vm.prank(owner);
        registry.setSubnodeOwner(BASE_ETH_NODE, label, user);
        vm.prank(user);
        resolver.approve(node, operator, true);
        vm.prank(operator);
        resolver.setAddr(node, user);
        assertEq(resolver.addr(node), user);
    }
}
