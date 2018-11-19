-- Question: What are the biases in the TLDs that use LE?

-- Groups the number of unique certificates seen in the last week by their
-- effective TLD, (with effective TLDs sourced from Mozilla's open source list.)
--
-- Only considers precerts, which are guaranteed to have been put on the CT
-- logs by Let's Encrypt

SELECT
  COUNT(distinct parsed.serial_number) AS valid_le_certs_by_etld_last_week,
  etld
FROM
  `censys-io.certificates_public.certificates`,
  UNNEST(parsed.issuer.organization) AS org_name,
  UNNEST(parsed.subject.common_name) AS subject_name,
  `impact-lets-encrypt.research.e_tlds_9_15`
WHERE
  org_name = 'Let\'s Encrypt'

  -- Censys says this certificate is trusted by a browser
  AND (validation.apple.valid
    OR validation.google_ct_primary.valid
    OR validation.microsoft.valid
    OR validation.nss.valid)

  -- Only look at certs updated in the last week.
  AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), metadata.updated_at, HOUR) <= 24 * 7

  -- Only keep precerts
  AND precert

  -- Extract the eTLD this corresponds to
  AND ENDS_WITH(subject_name, etld)

GROUP BY
  etld
ORDER BY
  valid_le_certs_by_etld_last_week DESC
