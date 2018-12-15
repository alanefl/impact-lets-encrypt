
WITH
  preprocessed AS (
  SELECT
    parsed.subject_dn,
    ARRAY_CONCAT([TIMESTAMP_SECONDS(0)], ARRAY_AGG(parsed.validity.start
      ORDER BY
        parsed.validity.start ASC)) AS bottom_arr,
    ARRAY_CONCAT(ARRAY_AGG(parsed.validity.start
      ORDER BY
        parsed.validity.start ASC), [TIMESTAMP_SECONDS(0)]) AS top_arr
  FROM
    `censys-io.certificates_public.certificates`,
    UNNEST(parsed.issuer.organization) AS org_name
  WHERE
    NOT precert
    AND org_name = 'Let\'s Encrypt'
    AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), parsed.validity.start, HOUR) < 365 * 24
  GROUP BY
    parsed.subject_dn)
SELECT
  SUM(early_renewals) AS total_early_renewals,
  SUM(mid_renewals) AS total_mid_renewals,
  SUM(late_renewals) AS total_late_renewals,
  SUM(expired_renewals) AS total_expired_renewals,
  SUM(no_renewals) AS total_not_renewed,
  SUM(currently_valid) AS total_not_renewed_currently_valid
FROM (
  SELECT
    subject_dn,
    COUNTIF(TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) BETWEEN 0
      AND 30 * 24) AS early_renewals,
    COUNTIF(TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) BETWEEN 30 * 24
      AND 60 * 24) AS mid_renewals,
    COUNTIF(TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) BETWEEN 60 * 24
      AND 90 * 24) AS late_renewals,
    COUNTIF(TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) > 90 * 24) AS expired_renewals,
    COUNTIF(TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) < 0
      AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), TIMESTAMP_SECONDS(-TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, SECOND)), HOUR) > 90 * 24 ) AS no_renewals,
    COUNTIF(TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) < 0
      AND TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), TIMESTAMP_SECONDS(-TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, SECOND)), HOUR) BETWEEN 0
      AND 90 * 24 ) AS currently_valid
  FROM
    preprocessed,
    UNNEST (bottom_arr) AS bottom_arr_unnested
  WITH
  OFFSET
    AS bottom_offset,
    UNNEST (top_arr) AS top_arr_unnested
  WITH
  OFFSET
    AS top_offset
  WHERE
    bottom_offset = top_offset
    AND TIMESTAMP_DIFF(top_arr_unnested, bottom_arr_unnested, HOUR) < 30000
  GROUP BY
    subject_dn)
