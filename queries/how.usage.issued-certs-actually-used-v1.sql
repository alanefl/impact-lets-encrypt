-- Question: How often is a procured certificate actually used
--           by some site?

-- NOTE: this query has limited.  We are using the Censys "seen_in_scan"
--       to determine whether a procured certificate has been seen or not.
--       This may not be as accurate as doing an active scan.

--------------------------

-- For all valid let's encrypt certificates (non-precerts) updated
-- in the last thirty days, how many of them were seen in a scan?
--
-- Note the number here is abysmally low. This means many more LE certificates
-- are issued than Censys sees in its scans.

SELECT
  COUNT(*) AS lets_encrypt_certs,
  COUNTIF(metadata.seen_in_scan) as seen_in_scan,
  COUNTIF(not metadata.seen_in_scan) as not_seen_in_scan,
  COUNTIF(metadata.seen_in_scan) / COUNT(*) as percent_seen_in_scan
FROM
  `censys-io.certificates_public.certificates`,
  UNNEST(parsed.issuer.organization) AS org_name
WHERE
  org_name = 'Let\'s Encrypt'

  -- Censys says some browser trusts this certificate.
  AND (validation.apple.valid
    OR validation.google_ct_primary.valid
    OR validation.microsoft.valid
    OR validation.nss.valid)

  -- Only look at certificates that have been updated in the last week
  AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), metadata.updated_at, HOUR) <= 24 * 30

  -- NOTE: precerts are not supposed to be seen in scans (and the numbers
  --       confirm it), so we use non-precert here as an approximation
  --       for the question.
  AND not precert
