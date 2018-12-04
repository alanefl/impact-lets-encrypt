-- Question: What percentage of all currently valid Let's Encrypt
-- cer

SELECT
  total_valid_now,
  valid_alexa_top_mill,
  valid_alexa_top_mill / total_valid_now * 100 AS percentage
FROM (
  SELECT
    COUNT(*) AS valid_alexa_top_mill
  FROM
    `censys-io.domain_public.current`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
  WHERE
    org_name = "Let\'s Encrypt"
    AND p443.https.tls.validation.browser_trusted ),
  (
  SELECT
    COUNT(*) AS total_valid_now
  FROM
    `censys-io.certificates_public.certificates` AS certs,
    UNNEST(parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'
    AND NOT certs.precert
    AND (certs.validation.apple.valid
      OR certs.validation.microsoft.valid
      OR certs.validation.google_ct_primary.valid
      OR certs.validation.nss.valid))
