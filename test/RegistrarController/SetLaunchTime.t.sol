// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {RegistrarControllerUnstable} from "./RegistrarControllerUnstable.t.sol";
import {Ownable} from "solady/auth/Ownable.sol";

contract SetLaunchTime is RegistrarControllerUnstable {
    function test_reverts_ifCalledByNonOwner(address caller) public {
        vm.assume(caller != owner);
        vm.expectRevert(Ownable.Unauthorized.selector);
        vm.prank(caller);
        controller.setLaunchTime(launchTime);
    }

    function test_allowsTheOwnerToSetTheLaunchTime() public {
        uint256 before_launchTime = controller.launchTime();
        assertEq(before_launchTime, 0);

        vm.prank(owner);
        controller.setLaunchTime(launchTime);

        uint256 after_launchTime = controller.launchTime();
        assertEq(after_launchTime, launchTime);
    }
}
