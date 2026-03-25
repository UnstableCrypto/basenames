-- Basenames: Name Renewals
-- Shows how many names have been renewed across all registrar controllers.
-- Note: EARegistrarController does not support renewals.
-- Dune namespace: basenames_base

WITH all_renewals AS (
    SELECT
        name,
        label,
        expires,
        evt_block_time,
        evt_tx_hash,
        'RegistrarController' AS controller
    FROM basenames_base.RegistrarController_evt_NameRenewed

    UNION ALL

    SELECT
        name,
        label,
        expires,
        evt_block_time,
        evt_tx_hash,
        'UpgradeableRegistrarController' AS controller
    FROM basenames_base.UpgradeableRegistrarController_evt_NameRenewed
)

SELECT
    controller,
    COUNT(*) AS total_renewals,
    COUNT(DISTINCT label) AS unique_names_renewed
FROM all_renewals
GROUP BY controller

UNION ALL

SELECT
    'All Controllers' AS controller,
    COUNT(*) AS total_renewals,
    COUNT(DISTINCT label) AS unique_names_renewed
FROM all_renewals

ORDER BY controller
