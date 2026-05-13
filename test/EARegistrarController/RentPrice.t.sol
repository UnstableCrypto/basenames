// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {EARegistrarControllerUnstable} from "./EARegistrarControllerUnstable.t.sol";
import {IPriceOracle} from "src/L2/interface/IPriceOracle.sol";

contract RentPrice is EARegistrarControllerUnstable {
    function test_returnsPrice_fromPricingOracle() public view {
        IPriceOracle.Price memory retPrices = controller.rentPrice(name, duration);
        assertEq(retPrices.base, prices.DEFAULT_BASE_WEI());
        assertEq(retPrices.premium, prices.DEFAULT_INCLUDED_PREMIUM());
    }

    function test_fuzz_returnsPrice_fromPricingOracle(uint256 fuzzUnstable, uint256 fuzzPremium) public {
        vm.assume(fuzzUnstable != 0 && fuzzUnstable < type(uint128).max);
        vm.assume(fuzzPremium < type(uint128).max);
        IPriceOracle.Price memory expectedPrice = IPriceOracle.Price({base: fuzzUnstable, premium: fuzzPremium});
        prices.setPrice(name, expectedPrice);
        IPriceOracle.Price memory retPrices = controller.rentPrice(name, 0);
        assertEq(retPrices.base, expectedPrice.base);
        assertEq(retPrices.premium, expectedPrice.premium);
    }
}
