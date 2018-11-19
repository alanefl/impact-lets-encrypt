-- Question: What is the geographical distribution of domains that use
--           valid LE certificates?

-- Counts of distinct IP addresses serving valid LE certificates in the
-- past day, grouped by country.

SELECT
  count(distinct ip) as ct,
  location.country
FROM
  `censys-io.ipv4_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
WHERE
  org_name = 'Let\'s Encrypt'

  -- Censys says this certificate was trusted
  AND p443.https.tls.validation.browser_trusted

  -- Only consider IPv4 addresses updated by Censys in the last 24 hours.
  AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24
GROUP BY
  location.country
ORDER BY
  ct desc;
