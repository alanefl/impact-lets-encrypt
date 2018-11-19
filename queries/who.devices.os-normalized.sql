-- Question: What types of devices serve valid LE certificates?

--Counts of distinct IP addresses serving valid LE certificates in the
-- past day, grouped by OS, ordered by normalized count (dividing by
-- total observed IP addresses in that country)

SELECT os_le, ct_le, ct_total, ct_le / ct_total as normalized_ct
FROM (
  SELECT
    count(distinct ip) as ct_le,
    metadata.os as os_le
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'

    -- Censys says this certificate is trusted by a browser.
    AND p443.https.tls.validation.browser_trusted

    -- IPv4 address was updated in the last 24 hours.
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24
  GROUP BY
    metadata.os
  ),
  (
  SELECT
    count(distinct ip) as ct_total,
    metadata.os as os_total
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE

    -- IPv4 Address updated in the last 24 hours.
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24
  GROUP BY
    metadata.os
)
WHERE os_le = os_total
AND os_le is not NULL
ORDER BY normalized_ct, ct_total desc;
