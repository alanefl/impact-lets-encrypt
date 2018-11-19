-- Question: What is the geographical distribution of domains that use
--           valid LE certificates?

-- Counts of distinct IP addresses serving valid LE certificates in the
-- past day, grouped by country, ordered by normalized count (by
-- total observed IP addresses in that country)

SELECT country_le, ct_le, ct_total, ct_le / ct_total as normalized_ct
FROM (
  SELECT
    count(distinct ip) as ct_le,
    location.country as country_le
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'

    -- Censys says this certificate is trusted by a browser.
    AND p443.https.tls.validation.browser_trusted

    -- Only look at IPv4 addresses updated in the last 24 hours.
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24

  GROUP BY
    location.country
  ),
  (
  SELECT
    count(distinct ip) as ct_total,
    location.country as country_total
  FROM
    `censys-io.ipv4_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE

    -- Only restriction here is that this IPv4 address was updated in
    -- the last 24 hours.
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24

  GROUP BY
    location.country
)
WHERE country_total = country_le
ORDER BY normalized_ct desc;
