-- Problem 1

SELECT job_schedule_type, avg(salary_year_avg), avg(salary_hour_avg)
FROM job_postings_fact
WHERE job_posted_date::DATE > '2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type;


-- Problem 2

SELECT 
    comp.name,
    count(*)
FROM job_postings_fact as fact
INNER JOIN company_dim as comp
ON fact.company_id = comp.company_id
WHERE EXTRACT(QUARTER FROM fact.job_posted_date) = 2
AND
fact.job_health_insurance = true
GROUP BY comp.name
ORDER BY count(*) DESC;