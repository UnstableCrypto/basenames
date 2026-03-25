---
name: basenames-dune-queries
description: >-
  Write Dune Analytics SQL queries for Basenames (.base.eth) on Base. Use when
  writing, debugging, or extending Dune queries involving basename registrations,
  renewals, discounts, or resolver data.
---

# Basenames Dune Queries

## Dune Namespace

Project name: **`basenames_base`**

Table pattern: `basenames_base.<ContractName>_evt_<EventName>`

## Registrar Controllers

There are three registrar controllers. All historical data matters even from deprecated ones.

| Controller | Status | Address | Has Renewals |
|---|---|---|---|
| EARegistrarController | Deprecated | _(early access, pre-launch)_ | No |
| RegistrarController | Deprecated | `0x4cCb0BB02FCABA27e82a56646E81d8c5bC4119a5` | Yes |
| UpgradeableRegistrarController (Proxy) | **Active** | `0xa7d2607c6BD39Ae9521e514026CBB078405Ab322` | Yes |

Always UNION ALL across all relevant controllers for complete data.

## Key Decoded Event Tables

### Registration Events

```
basenames_base.EARegistrarController_evt_NameRegistered(name, label, owner, expires)
basenames_base.RegistrarController_evt_NameRegistered(name, label, owner, expires)
basenames_base.UpgradeableRegistrarController_evt_NameRegistered(name, label, owner, expires)
```

### Discount Events

```
basenames_base.EARegistrarController_evt_DiscountApplied(registrant, discountKey)
basenames_base.RegistrarController_evt_DiscountApplied(registrant, discountKey)
basenames_base.UpgradeableRegistrarController_evt_DiscountApplied(registrant, discountKey)
```

### Renewal Events (no renewals on EARegistrarController)

```
basenames_base.RegistrarController_evt_NameRenewed(name, label, expires)
basenames_base.UpgradeableRegistrarController_evt_NameRenewed(name, label, expires)
```

### Payment Events

```
basenames_base.<Controller>_evt_ETHPaymentProcessed(payee, price)
```

### Base Registrar (token-level)

```
basenames_base.BaseRegistrar_evt_NameRegistered(id, owner, expires)
basenames_base.BaseRegistrar_evt_NameRenewed(id, expires)
basenames_base.BaseRegistrar_evt_NameRegisteredWithRecord(id, owner, expires, resolver, ttl)
```

## Discount Key Reference

| Discount | Key (bytes32) | Derivation |
|---|---|---|
| Early Access (EA) | `0xf5f55d...f6ed42` | `keccak256("ea.discount.validator")` |
| Coinbase ID (CBID) | `0x51a5a4...695e6` | `keccak256("cbid.discount.validator")` |
| Coinbase One (CB1) | `0x70667e...7359da` | `keccak256("cb1.discount.validator")` |
| Verified Account (VA) | `0xf08863...e3d218` | `keccak256("va.discount.validator")` |
| OCS NFT | `0xc1af3c...d0676d` | `keccak256("ocsnft.discount.validator")` |
| Devfolio | `0x3143ec...669116` | `keccak256("devfolio.discount.validator")` |
| BNS | `0xd54e7e...0e1a` | `keccak256("bns.discount.validator")` |
| Base ETH Holder | `0x1a1629...91ff4` | `keccak256("baseeth.discount.validator")` |
| Coupon | `0x804880...fcd9a` | `keccak256("coupon.discount.validator")` |
| Talent Protocol | `0xd257b6...706d04` | `keccak256("talent.protocol.discount.validator")` |
| Base World | `0xb4db75...46389b` | `keccak256("base.world.discount.validator")` |
| Devcon | `0xbf2bde...a5ca` | `keccak256("devcon.discount.validator")` |
| Onchain Pass | `0x1248f4...434021` | `keccak256("onchainpass.discount.validator")` |
| Signature | `0x31a45e...fc456` | `keccak256("signature.discount.validator")` |

### Full Discount Key Values (for use in SQL)

```sql
-- Use in a CTE with VALUES clause:
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
)
```

## Query Patterns

### Always UNION ALL across controllers

```sql
SELECT ... FROM basenames_base.EARegistrarController_evt_DiscountApplied
UNION ALL
SELECT ... FROM basenames_base.RegistrarController_evt_DiscountApplied
UNION ALL
SELECT ... FROM basenames_base.UpgradeableRegistrarController_evt_DiscountApplied
```

### Common columns in decoded event tables

All decoded event tables include:
- `evt_block_time` (timestamp)
- `evt_block_number` (bigint)
- `evt_tx_hash` (varbinary)
- `evt_index` (bigint)
- `contract_address` (varbinary)

### Other Contract Addresses (Base Mainnet)

| Contract | Address |
|---|---|
| Registry | `0xb94704422c2a1e396835a571837aa5ae53285a95` |
| BaseRegistrar | `0x03c4738ee98ae44591e1a4a4f3cab6641d95dd9a` |
| L2Resolver | `0xC6d566A56A1aFf6508b41f6c90ff131615583BCD` |
| UpgradeableL2Resolver (Proxy) | `0x426fA03fB86E510d0Dd9F70335Cf102a98b10875` |
| ReverseRegistrar | `0x79ea96012eea67a83431f1701b3dff7e37f9e282` |
