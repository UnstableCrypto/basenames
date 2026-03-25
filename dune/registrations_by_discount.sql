-- Basenames: Registrations by Discount Key
-- Counts names registered using each discount across all registrar controllers.
-- Dune namespace: basenames_base

WITH discount_keys(key, name) AS (
    VALUES
        (0xf5f55dcafd77c74cf5ff621cd6531daacd008302c7462bf9e7cda1cf2df6ed42, 'Early Access (EA)'),
        (0x51a5a42a1e8f8f9700bb48594d76135443eede20cf2497051d7d6345bac695e6, 'Coinbase ID (CBID)'),
        (0x70667e9a23f580e9966858fa09ecce3ad61648ebb5a2b5c32911cbd0cb7359da, 'Coinbase One (CB1)'),
        (0xf088634d46dc5d3c72a8f69a871bb3e3433c6bb91ea6734e8327d1b282e3d218, 'Coinbase Verified Account (VA)'),
        (0xc1af3c32616941d3f6d85f4f01aafb556b5620e8868acac1ed2a816fb9d0676d, 'OCS NFT'),
        (0x3143ec71f55f3de688c3d85458596266f04998cc0b032da92189f8a8bc669116, 'Devfolio'),
        (0xd54e7ef626460046c62f997ca5d45096587ddf69917a1d56a881e0d938f70e1a, 'BNS'),
        (0x1a16299978120bd83712dc61838e2ccb1a1a20bd2398398e9a11eff218f91ff4, 'Base ETH Holder'),
        (0x804880ed80dc9d8ef441e93aca7e5a53a2a918408fabafb914b6b3215f0fcd9a, 'Coupon'),
        (0xd257b661337e034311e2952f99c2741dd95a5cd694e5c4966e63c8046a706d04, 'Talent Protocol'),
        (0xb4db75984d292ffb4699c8925b2e88d49552665c71aa3e33d3dca40ba846389b, 'Base World'),
        (0xbf2bded7889eadee054bfe1644c12f4e6333cd25c06efddb6f557d119a80a5ca, 'Devcon'),
        (0x1248f468f70a535b451368debdb00cb0d5f15d6e32e3e74fed9db136da434021, 'Onchain Pass'),
        (0x31a45e818734635b36e2fc92dd8be0a4db88508e132a7510836afc78ea5fc456, 'Signature')
),

all_discounts AS (
    SELECT discountKey, registrant, evt_block_time, 'EARegistrarController' AS controller
    FROM basenames_base.EARegistrarController_evt_DiscountApplied

    UNION ALL

    SELECT discountKey, registrant, evt_block_time, 'RegistrarController' AS controller
    FROM basenames_base.RegistrarController_evt_DiscountApplied

    UNION ALL

    SELECT discountKey, registrant, evt_block_time, 'UpgradeableRegistrarController' AS controller
    FROM basenames_base.UpgradeableRegistrarController_evt_DiscountApplied
)

SELECT
    COALESCE(dk.name, 'Unknown') AS discount_name,
    ad.discountKey,
    ad.controller,
    COUNT(*) AS registration_count
FROM all_discounts ad
LEFT JOIN discount_keys dk ON ad.discountKey = dk.key
GROUP BY dk.name, ad.discountKey, ad.controller
ORDER BY registration_count DESC
