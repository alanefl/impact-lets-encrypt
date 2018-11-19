-- Question: How many domains have different valid certificates at the
--           same time?

-- Print the counts of websites that have multiple valid certificates
-- for the same Subject DN.

SELECT
  COUNT(*) AS valid_certs_by_dn,
  parsed.subject_dn
FROM
  `censys-io.certificates_public.certificates`,
  UNNEST(parsed.issuer.organization) AS org_name
WHERE

  -- Censys says at least one browser trusts this certificate
  (validation.apple.valid
    OR validation.google_ct_primary.valid
    OR validation.microsoft.valid
    OR validation.nss.valid)

  -- This certificate must be valid right now.
  AND parsed.validity.END > CURRENT_TIMESTAMP() AND parsed.validity.start <= CURRENT_TIMESTAMP()

  -- Consider only precerts.
  AND precert

-- Group by Subject Distinguished Name to see which have multiple valid certificates.
GROUP BY
  parsed.subject_dn
HAVING

  -- Can vary clause here to get results for 1, 2, 2+ valid certs.
  COUNT(*) > 1

 -- NOTE: this query does not finish on Colab, but it does on BigQuery.

 -- BigQuery ==> returns 4,211,670  subject dns with more than 2 valid certs,
 -- BigQuery ==> returns 29,498,906 subject dns with more than 1 valid cert
 -- BigQuery ==> returns 88,930,768 subject dns with at least 1 valid cert.
