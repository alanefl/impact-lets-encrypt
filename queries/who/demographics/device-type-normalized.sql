-- Question: What kind of devices serve valid LE certificates?

-- Counts of distinct IP addresses serving valid LE certificates in the
-- past day, grouped by device_type, ordered by normalized count (dividing by
-- total observed IP addresses in that country)

SELECT
    device_type_le,
    ct_le,
    ct_total,
    ct_le / ct_total as normalized_ct
FROM (
  SELECT
    count(ip) as ct_le,
    metadata.device_type as device_type_le
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'

    -- Censys says this certificate was trusted by a browser.
    AND p443.https.tls.validation.browser_trusted

    -- Only consider IPs updated in the last 24 hours.
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24

  GROUP BY
    metadata.device_type
  ),
  (
  SELECT
    count(ip) as ct_total,
    metadata.device_type as device_type_total
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE

    -- Only look at IPs updated in the last 24 hours.
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24

  GROUP BY
    metadata.device_type
)
WHERE device_type_le = device_type_total
AND device_type_le is not NULL
ORDER BY normalized_ct desc;
