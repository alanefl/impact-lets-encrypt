-- Question: To what degree are LE certs being used to certify typosquatting

-- The number of domains in generated typosquate domains list that
-- are serving valid certs, grouped by what cert they are serving.

-- NOTE: this one may be stale, IPv4 addresses
--       are highly dynamic, typosquatted IPs are likely to be
--       even more dynamic.

-- Uses Censys's IPv4 table.

SELECT
  COUNT(ip) AS domain_ct,
  org_name
FROM
  `censys-io.ipv4_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
WHERE

  -- Censys says this certificate is trusted by some browser
  p443.https.tls.validation.browser_trusted

  -- This IP is in one of the ones from our list of typosquats
  ip IN (
    SELECT
      ip
    FROM
      `research.typosquats_9_13`
      )
GROUP BY
  org_name
ORDER BY
  domain_ct DESC
