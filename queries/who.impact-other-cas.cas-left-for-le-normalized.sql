-- Question: Of the websites that switched to LE but previously had
--           certificates, what certificates were abandoned? Did any certificate
--           authorities suffer a greater hit than others?

-- Now the same as who.impact_other_cas.cas-left-for-le.sql,
-- but normalized by the number of certificates total from that CA.
--
-- In other words,
--
--    # valid certificates issued such that the domains issued those certificates
--      now have a valid LE certificate, grouped by CA
--    -----------------------------------------
--    # all valid certificates issued by that CA

SELECT
  issuer_dn,
  prev_certs_by_issuer,
  all_valid_certs_by_issuer,
  prev_certs_by_issuer / all_valid_certs_by_issuer AS normalized_prev_certs_by_issuer
FROM (
  SELECT
    COUNT(*) AS prev_certs_by_issuer,
    certs.parsed.issuer_dn AS issuer_dn
  FROM
    `censys-io.domain_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name,
    `censys-io.certificates_public.certificates` AS certs,
    UNNEST(parsed.issuer.organization) AS inner_org_name
  WHERE

    -- Here we care about Let's Encrypt certificates
    org_name = 'Let\'s Encrypt'

    -- Censys says this is trusted by a browser
    AND p443.https.tls.validation.browser_trusted

    -- Let's consider certs that match the subject_dn of the valid Let's Encrypt
    -- cert, but are not Let's Encrypt themselves and which were valid at some point
    -- in the past.
    AND p443.https.tls.certificate.parsed.subject_dn = certs.parsed.subject_dn
    AND inner_org_name != 'Let\'s Encrypt'
    AND certs.parsed.validity.start < p443.https.tls.certificate.parsed.validity.start

    -- Keep only precerts
    AND certs.precert

    -- Certs must have been valid.
    AND (certs.validation.apple.was_valid
      OR certs.validation.microsoft.was_valid
      OR certs.validation.google_ct_primary.was_valid
      OR certs.validation.nss.was_valid)

  GROUP BY
    certs.parsed.issuer_dn) AS le,
  (
  SELECT
    COUNT(*) AS all_valid_certs_by_issuer,
    certs.parsed.issuer_dn AS dn_all
  FROM
    `censys-io.certificates_public.certificates` AS certs
  WHERE

    -- Keep only precerts
    certs.precert

    -- Must have been valid at some time in the past.
    AND (certs.validation.apple.was_valid
      OR certs.validation.microsoft.was_valid
      OR certs.validation.google_ct_primary.was_valid
      OR certs.validation.nss.was_valid)

  GROUP BY
    certs.parsed.issuer_dn) AS all_
WHERE all_.dn_all = le.dn
ORDER BY
  ratio DESC;
