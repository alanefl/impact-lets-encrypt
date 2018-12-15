-- Question: What type of devices serve valid LE certificates?

-- Counts of distinct IP addresses serving valid LE certificates in the
-- past day, grouped by manufacturer, ordered by normalized count (dividing by
-- total observed IP addresses in that country)

SELECT manufacturer_le, ct_le, ct_total, ct_le / ct_total as normalized_ct
FROM (
  SELECT
    count(ip) as ct_le,
    metadata.manufacturer as manufacturer_le
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'

    -- Censys says this is trusted by a browser.
    AND p443.https.tls.validation.browser_trusted

    -- Was updated in the last 24 hours.
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24
  GROUP BY
    metadata.manufacturer
  ),
  (
  SELECT
    count(ip) as ct_total,
    metadata.manufacturer as manufacturer_total
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE

    -- Was updated in the last 24 hours.
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24
  GROUP BY
    metadata.manufacturer
  )
WHERE manufacturer_le = manufacturer_total
AND manufacturer_le is not NULL
ORDER BY normalized_ct desc;
