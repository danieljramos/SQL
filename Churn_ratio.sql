-- monthdiff was already in the database as was not calculated using SQL, it can be calculated using the date_truncate function and date_diff.

SELECT raw.conversion_date,
       raw.monthdiff,
       raw.sum_of_conversions,
       (cast(ratio.total_cancelation AS float)/cast(ratio.total_conversions AS float)) AS churn_ratio,
       ratio.total_cancelation
FROM raw_dataraw AS RAW
LEFT JOIN
  (SELECT conversion_date AS date,
          monthdiff,
          sum_of_conversions,
          sum(sum_of_conversions) OVER (PARTITION BY conversion_date) AS total_conversions,
                                       sum_of_cancellations,
                                       sum(sum_of_cancellations) OVER (PARTITION BY conversion_date
                                                                       ORDER BY monthdiff) AS total_cancelation
   FROM raw_dataraw
   GROUP BY date, monthdiff) AS ratio ON ratio.date = raw.conversion_date
AND ratio.monthdiff = raw.monthdiff
