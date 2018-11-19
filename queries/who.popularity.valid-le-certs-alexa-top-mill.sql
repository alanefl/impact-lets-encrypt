-- Question: Do popular or high-value websites use Let's Encrypt,
--           or are most LE clients small and obscure?

-- Returns the number of domains with valid LE certificates binned by chunks of 100,000
-- spots in the Alexa top million in the last day.

SELECT
  count(CASE WHEN alexa_rank BETWEEN 900000 AND 1000000 THEN 1 END) as _900k_1m,
  count(CASE WHEN alexa_rank BETWEEN 800000 AND 899999 THEN 1 END) as _800k_900k,
  count(CASE WHEN alexa_rank BETWEEN 700000 AND 799999 THEN 1 END) as _700k_800k,
  count(CASE WHEN alexa_rank BETWEEN 600000 AND 699999 THEN 1 END) as _600k_700k,
  count(CASE WHEN alexa_rank BETWEEN 500000 AND 599999 THEN 1 END) as _500k_600k,
  count(CASE WHEN alexa_rank BETWEEN 400000 AND 499999 THEN 1 END) as _400k_500k,
  count(CASE WHEN alexa_rank BETWEEN 300000 AND 399999 THEN 1 END) as _300k_400k,
  count(CASE WHEN alexa_rank BETWEEN 200000 AND 299999 THEN 1 END) as _200k_300k,
  count(CASE WHEN alexa_rank BETWEEN 100000 AND 199999 THEN 1 END) as _100k_200k,
  count(CASE WHEN alexa_rank BETWEEN 1 AND 99999 THEN 1 END) as _1_100k
FROM `censys-io.domain_public.current`,
  UNNEST(p443.https.tls.certificate.parsed.issuer.organization) as org_name
WHERE
  org_name = 'Let\'s Encrypt'

  -- Censys says this cert is trusted by a browser
  AND p443.https.tls.validation.browser_trusted
