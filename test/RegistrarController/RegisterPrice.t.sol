// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {RegistrarControllerUnstable} from "./RegistrarControllerUnstable.t.sol";
import {IPriceOracle} from "src/L2/interface/IPriceOracle.sol";

contract RegisterPrice is RegistrarControllerUnstable {
    function test_returnsRegisterPrice_fromPricingOracle() public view {
        uint256 retPrice = controller.registerPrice(name, 0);
        assertEq(retPrice, prices.DEFAULT_BASE_WEI() + prices.DEFAULT_PREMIUM_WEI());
    }

    function test_fuzz_returnsRegisterPrice_fromPricingOracle(uint256 fuzzUnstable, uint256 fuzzPremium) public {
        vm.assume(fuzzUnstable != 0 && fuzzUnstable < type(uint128).max);
        vm.assume(fuzzPremium < type(uint128).max);
        IPriceOracle.Price memory expectedPrice = IPriceOracle.Price({base: fuzzUnstable, premium: fuzzPremium});
        prices.setPrice(name, expectedPrice);
        uint256 retPrice = controller.registerPrice(name, 0);
        assertEq(retPrice, expectedPrice.base + expectedPrice.premium);
    }
}
