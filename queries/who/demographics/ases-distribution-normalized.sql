-- Question: What ASes serve valid LE certificates?

-- Counts of distinct IP addresses serving valid LE certificates in the
-- past day, grouped by autonomous system, ordered by normalized count
-- (dividing by total observed IP addresses in that AS)

-- For clarity, only consider ASes where we see at least 100 ip addresses.

SELECT asn_le, asn_name, ct_le, ct_total, ct_le / ct_total as normalized_ct
FROM (
  SELECT
    count(DISTINCT ip) as ct_le,
    autonomous_system.asn as asn_le,
    autonomous_system.name as asn_name
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'

    -- Censys says this certificate is trusted by a browser.
    AND p443.https.tls.validation.browser_trusted

    -- Only consider IPv4 addresses updated in the last 24 hours.
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24

  GROUP BY
    autonomous_system.asn, autonomous_system.name

  -- For clarity, let's only keep ASes with more than 100 distinct IPs.
  HAVING count(DISTINCT ip) > 100

  ),
  (
  SELECT
    count(DISTINCT ip) as ct_total,
    autonomous_system.asn as asn_total,
    autonomous_system.name as asn_name_total
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE

    -- Only consider IPv4 addresses updated in the last 24 hours.
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24

  GROUP BY
    autonomous_system.asn, autonomous_system.name
  )
WHERE asn_total = asn_le AND asn_name = asn_name_total
ORDER BY normalized_ct desc;
