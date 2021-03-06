-- Question: Are websites new to TLS, or are they switching over
--           from other CAs?

-- For all sites in the Alexa top million that are serving valid LE
-- certificates now, which of them had another valid cert with a validity period
-- starting BEFORE the LE certificate was issued?

SELECT
  COUNT(*) total_certs,
  COUNTIF(certs.metadata.seen_in_scan) as seen_in_scan_ct,
  COUNTIF(not certs.metadata.seen_in_scan) as not_seen_in_scan_ct
FROM
  `censys-io.domain_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name,
  `censys-io.certificates_public.certificates` AS certs,
  UNNEST(parsed.issuer.organization) AS inner_org_name
WHERE

  -- The orgname of the domain certificate is LE.
  org_name = 'Let\'s Encrypt'

  -- Consider certificates that are not precerts in the certificates
  -- table.
  AND not certs.precert

  -- Censys says both certs are trusted by browser
  -- (certificates in certificates table previously valid)
  -- (certificates in domains currently valid/browser trusted)
  AND (certs.validation.apple.was_valid
    OR certs.validation.microsoft.was_valid
    OR certs.validation.google_ct_primary.was_valid
    OR certs.validation.nss.was_valid
    )
  AND p443.https.tls.validation.browser_trusted

  -- The other cert we look at needs to have the same subject_dn but not
  -- be a Let's Encrypt certificate.
  AND inner_org_name != 'Let\'s Encrypt'
  AND p443.https.tls.certificate.parsed.subject_dn = certs.parsed.subject_dn

  -- Non-LE cert needs to have been valid before the current LE cert.
  AND certs.parsed.validity.start < p443.https.tls.certificate.parsed.validity.start


# Latest answer: 64,148 of 1,358,098 domains present in the domains list
# are serving an LE cert and previously had another valid non-LE cert.
#
# That means that 64,148 out of 241,802 total domains in Alexa top million
# that give LE certs back, previous CAs were used.
#
# This shows that the majority actually are new to HTTPS! Because a good
# amount of the LE certs in the Alexa top million seem to not have had another
# CA before Let's Encrypt.
