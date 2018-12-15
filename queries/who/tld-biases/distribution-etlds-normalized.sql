-- Question: what are the biases in TLDs that use Let's Encrypt?

-- Same thing as in who.tld_biases.distribution-etlds.sql, but
-- normalized by the total number of certificates seen in that eTLD.

SELECT
    valid_le_certs_by_etld_last_week,
    valid_certs_by_etld_last_week,
    all_data.etld,
    valid_le_certs_by_etld_last_week / valid_certs_by_etld_last_week as norm_ct
FROM (
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

    -- Only keep non-precerts
    AND not precert

    -- Extract the eTLD this corresponds to
    AND ENDS_WITH(subject_name, etld)
  GROUP BY
    etld) as le_data,
  (SELECT
    COUNT(distinct parsed.serial_number) AS valid_certs_by_etld_last_week,
    etld
  FROM
    `censys-io.certificates_public.certificates`,
    UNNEST(parsed.issuer.organization) AS org_name,
    UNNEST(parsed.subject.common_name) AS subject_name,
    `impact-lets-encrypt.research.e_tlds_9_15`
  WHERE

  -- Censys says this certificate is trusted by a browser
    (validation.apple.valid
      OR validation.google_ct_primary.valid
      OR validation.microsoft.valid
      OR validation.nss.valid)

    -- Only look at certs updated in the last week.
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), metadata.updated_at, HOUR) <= 24 * 7

    -- Only keep non-precerts
    AND not precert

    -- Extract the eTLD this corresponds to
    AND ENDS_WITH(subject_name, etld)
  GROUP BY
    etld) as all_data
WHERE
  all_data.etld = le_data.etld
ORDER BY
  norm_ct desc
