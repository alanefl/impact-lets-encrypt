-- Question: How many domains have multiple valid certs at the same time
--           and at least one of them is a valid LE cert?

-- Print the counts of websites that have multiple valid certificates
-- for the same Subject DN, but only where at least one of those valid certificates
-- is a LE cert.

SELECT
  COUNT(*) AS valid_certs_by_dn,
  parsed.subject_dn
FROM
  `censys-io.certificates_public.certificates`,
  UNNEST(parsed.issuer.organization) AS org_name
WHERE

  -- Censys says at least one browser trusts this certificate.
  (validation.apple.valid
    OR validation.google_ct_primary.valid
    OR validation.microsoft.valid
    OR validation.nss.valid)

  -- Valid right now
  AND parsed.validity.END > CURRENT_TIMESTAMP() AND parsed.validity.start <= CURRENT_TIMESTAMP()

  -- Only consider precerts.
  AND precert

  -- Only count subject distinguished names that have a valid
  -- LE certificate right now.
  AND parsed.subject_dn IN (
    SELECT
      DISTINCT parsed.subject_dn
    FROM
      `censys-io.certificates_public.certificates`,
      UNNEST(parsed.issuer.organization) AS org_name

    WHERE
      org_name = 'Let\'s Encrypt'

      -- These certificates also need to be valid right now.
      AND (validation.apple.valid
        OR validation.google_ct_primary.valid
        OR validation.microsoft.valid
        OR validation.nss.valid)

      AND parsed.validity.END > CURRENT_TIMESTAMP() AND parsed.validity.start <= CURRENT_TIMESTAMP()

      -- Look only at LE precerts.
      AND precert
  )
GROUP BY
  parsed.subject_dn
HAVING
  COUNT(*) > 1

-- NOTE: this query does not finish on Colab, but it does on BigQuery.

-- BigQuery ==> returns 2,986,557  subject dns with more than 2 valid certs (one of them LE)
-- BigQuery ==> returns 22,940,431 subject dns with more than 1 valid certs (one of them LE)
-- BigQuery ==> returns 56,247,091 subject dns with at least 1 valid cert (one of them LE)
