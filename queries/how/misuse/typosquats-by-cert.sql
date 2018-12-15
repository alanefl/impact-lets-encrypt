-- Question: To what degree are LE certs being used to certify typosquatting

-- The number of domains in generated typosquatted domain list that
-- are serving browser-trusted certs, grouped by what cert they are serving.

-- Uses Censys's certificates table.

SELECT
  COUNT(domain) AS domain_ct,
  org_name
FROM
  `censys-io.domain_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
WHERE

  -- Censys says this domain is trusted by a browser
  p443.https.tls.validation.browser_trusted

  -- This domain is one of the domains for typosquatting popular sites.
  AND domain IN (
    SELECT
      domain
    FROM
      `research.typosquats_9_13`
  )
GROUP BY
  org_name
ORDER BY
  domain_ct DESC
