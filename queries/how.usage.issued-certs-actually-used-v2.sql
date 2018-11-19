-- Question: How often are procured certs actually used?

-- This query takes a different approach than
-- how.usage.issued_-certs-actually-used-v1.sql.
--
-- It looks at all unique valid LE certs (unique means a unique serial
-- number) seen in IPv4 space over the past week,
-- and divides that by the number of unique valid LE certs seen
-- in certificate transparency logs.


SELECT
  all_valid_le_certs_in_last_week,
  unique_le_certs_seen_in_wild_past_week,
  unique_le_certs_seen_in_wild_past_week / all_valid_le_certs_in_last_week
FROM (
  SELECT
    COUNT(DISTINCT parsed.serial_number) AS all_valid_le_certs_in_last_week
  FROM
    `censys-io.certificates_public.certificates`,
    UNNEST(parsed.issuer.organization) AS org_name
  WHERE
    org_name = 'Let\'s Encrypt'

    -- Censys says browser trusted
    AND (validation.apple.valid
      OR validation.google_ct_primary.valid
      OR validation.microsoft.valid
      OR validation.nss.valid)

    -- Valid at some point in the last wekk.
    AND parsed.validity.END >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 * 7 HOUR)

    -- Consider only things that are not precerts, since those are the things
    -- we expect to see in Censys scans.
    AND NOT precert
    ),
  (
  SELECT
    COUNT(DISTINCT p443.https.tls.certificate.parsed.serial_number) AS unique_le_certs_seen_in_wild_past_week
  FROM (
      -- BigQuery doesn't allow wildcards for table views :(
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181108`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
      UNION ALL
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181109`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
      UNION ALL
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181110`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
      UNION ALL
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181111`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
      UNION ALL
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181112`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
      UNION ALL
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181113`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name
      UNION ALL
      SELECT
        *
      FROM
        `censys-io.ipv4_public.20181114`,
        UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name )
    WHERE
      org_name = 'Let\'s Encrypt'

      -- Censys says this certificate is trusted by a browser
      AND p443.https.tls.validation.browser_trusted

      -- Only look at IPv4 addresses updated in the last week.
      AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), updated_at, HOUR) <= 24 * 7
 )
