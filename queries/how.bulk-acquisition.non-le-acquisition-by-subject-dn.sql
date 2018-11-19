-- Question: Do a small number of domains acquire a large number of
--           NON Let's Encrypt certificates?

SELECT count_for_domain, count(*) as domains_with_this_count
FROM (
  SELECT
    count(*) as count_for_domain,
    parsed.subject_dn
  FROM
    `censys-io.certificates_public.certificates`,
    UNNEST(parsed.issuer.organization) AS org_name
  WHERE
    -- What about things that are not Let's Encrypt?
    org_name != "Let\'s Encrypt" AND precert
  GROUP BY
    parsed.subject_dn
)
GROUP BY
  count_for_domain
