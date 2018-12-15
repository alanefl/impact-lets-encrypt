-- Questions: how many domains left Let's Encrypt for another CA?

SELECT
  COUNT(*) total_certs, AVG(alexa_rank), MIN(alexa_rank), MAX(alexa_rank)
FROM
  `censys-io.domain_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name,
  (
  SELECT
    certs.parsed.subject_dn as subject_dn,
    MIN(certs.parsed.validity.start) as min_validity
  FROM
    `censys-io.certificates_public.certificates` AS certs,
    UNNEST(parsed.issuer.organization) AS inner_org_name
  WHERE
    inner_org_name = 'Let\'s Encrypt'
    AND NOT certs.precert
  GROUP BY
    certs.parsed.subject_dn ) AS min_le_validity_times
WHERE
  org_name != 'Let\'s Encrypt'
  AND min_le_validity_times.subject_dn = p443.https.tls.certificate.parsed.subject_dn
  AND p443.https.tls.validation.browser_trusted
  AND min_le_validity_times.min_validity < p443.https.tls.certificate.parsed.validity.start 
