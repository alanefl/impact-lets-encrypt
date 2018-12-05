-- Question: Of the websites that switched to LE but previously had
--           certificates, what certificates were abandoned? Did any certificate
--           authorities suffer a greater hit than others?

-- For all sites in the Alexa top million that are serving valid LE
-- certificates, which of them had another valid PREcert with a validity period
-- starting BEFORE the LE certificate was issued? Grouped by
-- each previous CA.

-- In other words, for each CA, how many domains original had a valid cert
-- from that CA but then went on to try Let's Encrypt?

SELECT
  COUNT(*) as prev_certs_by_issuer,
  certs.parsed.issuer_dn
FROM
  `censys-io.domain_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name,
  `censys-io.certificates_public.certificates` AS certs,
  UNNEST(parsed.issuer.organization) AS inner_org_name
WHERE

  -- Domain cert organization must be Let's Encrypt.
  org_name = 'Let\'s Encrypt'

  -- Censys says the domain cert is valid, and the cert from the certificate
  -- tables was valid at some point now or in the past.
  AND p443.https.tls.validation.browser_trusted
  AND (certs.validation.apple.was_valid
    OR certs.validation.microsoft.was_valid
    OR certs.validation.google_ct_primary.was_valid
    OR certs.validation.nss.was_valid )

  -- The other valid certificates needs to have been something other than
  -- Let's Encrypt. Keep only the certificates for the same subject_dn.
  AND inner_org_name != 'Let\'s Encrypt'
  AND p443.https.tls.certificate.parsed.subject_dn = certs.parsed.subject_dn

  -- Let's only look at non-precerts.
  AND not certs.precert

  -- Validity of other cert must have started before the validity of the current
  -- Let's Encrypt cert.
  AND certs.parsed.validity.start < p443.https.tls.certificate.parsed.validity.start
GROUP BY
  certs.parsed.issuer_dn
ORDER BY prev_certs_by_issuer desc;
