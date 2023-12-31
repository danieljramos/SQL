WITH users AS
  (SELECT Count(DISTINCT acquisition_data.user_id) AS total_users
   FROM acquisition_data),
     verified AS
  (SELECT COUNT (DISTINCT identity_data.user_id) AS verified_users
   FROM identity_data
   WHERE event_name = 'VerificationApproved'),
     deposit AS
  (SELECT COUNT (DISTINCT transaction_data.user_id) AS deposit_users
   FROM transaction_data
   WHERE deposit_usd > 0),
     yield AS
  (SELECT COUNT (DISTINCT transaction_data.user_id) AS yield_users
   FROM transaction_data
   WHERE yield_subscription_usd > 0)
SELECT Cast(verified_users AS FLOAT) / Cast(total_users AS FLOAT) * 100 AS CR_verified_users,
       Cast(deposit_users AS FLOAT) / Cast(verified_users AS FLOAT) * 100 AS CR_deposit_users,
       Cast(yield_users AS FLOAT) / Cast(deposit_users AS FLOAT) * 100 AS CR_yield_users
FROM users,
     verified,
     deposit,
     yield GROUP  BY total_users,
                     verified_users,
                     deposit_users,
                     yield_users
