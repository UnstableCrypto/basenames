//SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

import {Test} from "forge-std/Test.sol";
import {LaunchAuctionPriceOracleUnstable} from "./LaunchAuctionPriceOracleUnstable.t.sol";

contract DecayedPremium is LaunchAuctionPriceOracleUnstable {
    function test_decayedPremium_zeroElapsed() public view {
        uint256 elapsed = 0;
        uint256 expectedPremium = startPremium;
        uint256 actualPremium = oracle.decayedPremium(elapsed);
        assertEq(actualPremium, expectedPremium);
    }

    function test_decayedPremium_auctionEnd() public view {
        uint256 auctionEndPremium = oracle.decayedPremium(_auctionDuration());
        assertTrue(auctionEndPremium < oracle.endValue());
    }

    function test_decayedPremium_halfPeriod() public view {
        uint256 elapsed = PRICE_PREMIUM_HALF_LIFE / 2;
        uint256 expectedPremium = _calculateDecayedPremium(elapsed);
        uint256 actualPremium = oracle.decayedPremium(elapsed);
        assertEq(actualPremium, expectedPremium);
    }

    function test_decayedPremium_threePeriods() public view {
        uint256 elapsed = 3 * PRICE_PREMIUM_HALF_LIFE;
        uint256 expectedPremium = _calculateDecayedPremium(elapsed);
        uint256 actualPremium = oracle.decayedPremium(elapsed);
        assertEq(actualPremium, expectedPremium);
    }
}
