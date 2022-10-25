SELECT pid, (now() - query_start) AS duration, query, state FROM pg_stat_activity WHERE now() - pg_stat_activity.query_start > interval '10 minutes';

select pg_cancel_backend(18898);
select pg_terminate_backend(22655);
