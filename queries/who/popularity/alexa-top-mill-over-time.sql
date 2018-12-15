-- How has the popularity of Let's Encrypt domains changed
-- amongst the Alexa top million sites since its release?

-- NOTE: Censys keeps data for a single scan for a week after some time
--       has passed, so this query samples the data Censys has available
--       each month since Let's Encrypt was released.

SELECT
  *
FROM (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_12
  FROM
    `censys-io.domain_public.20181201`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_11
  FROM
    `censys-io.domain_public.20181101`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_10
  FROM
    `censys-io.domain_public.20181001`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_9
  FROM
    `censys-io.domain_public.20180901`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_8
  FROM
    `censys-io.domain_public.20180801`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_7
  FROM
    `censys-io.domain_public.20180701`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_6
  FROM
    `censys-io.domain_public.20180601`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_5
  FROM
    `censys-io.domain_public.20180501`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_4
  FROM
    `censys-io.domain_public.20180403`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_3
  FROM
    `censys-io.domain_public.20180306`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_2
  FROM
    `censys-io.domain_public.20180207`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_18_1
  FROM
    `censys-io.domain_public.20180102`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_12
  FROM
    `censys-io.domain_public.20171205`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_11
  FROM
    `censys-io.domain_public.20171107`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_10
  FROM
    `censys-io.domain_public.20171003`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_9
  FROM
    `censys-io.domain_public.20170905`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_8
  FROM
    `censys-io.domain_public.20170801`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_7
  FROM
    `censys-io.domain_public.20170704`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_6
  FROM
    `censys-io.domain_public.20170606`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_5
  FROM
    `censys-io.domain_public.20170502`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_4
  FROM
    `censys-io.domain_public.20170404`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_3
  FROM
    `censys-io.domain_public.20170314`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_2
  FROM
    `censys-io.domain_public.20170207`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_17_1
  FROM
    `censys-io.domain_public.20170103`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_12
  FROM
    `censys-io.domain_public.20161209`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_11
  FROM
    `censys-io.domain_public.20161108`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_10
  FROM
    `censys-io.domain_public.20161017`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_9
  FROM
    `censys-io.domain_public.20160902`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_8
  FROM
    `censys-io.domain_public.20160806`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_7
  FROM
    `censys-io.domain_public.20160705`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_6
  FROM
    `censys-io.domain_public.20160608`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_5
  FROM
    `censys-io.domain_public.20160502`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_4
  FROM
    `censys-io.domain_public.20160404`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_3
  FROM
    `censys-io.domain_public.20160307`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_2
  FROM
    `censys-io.domain_public.20160204`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_16_1
  FROM
    `censys-io.domain_public.20160107`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_15_12
  FROM
    `censys-io.domain_public.20151203`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name),
  (
  SELECT
    COUNTIF(org_name = "Let\'s Encrypt") / 1000000 * 100 AS percent_lets_encrypt_15_11
  FROM
    `censys-io.domain_public.20151126`,
    UNNEST(p443.https.tls.certificate.parsed.issuer.organization) AS org_name)
