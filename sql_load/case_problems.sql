/* Problem 1 */

SELECT 
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg >= 60000 THEN 'Standard Salary'
        WHEN salary_year_avg < 60000 THEN 'Low Salary'
    END AS salary_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' 
    AND 
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_category DESC;


/* Problem 2 */
select
    COUNT(DISTINCT company_id),
    CASE
        WHEN job_work_from_home = TRUE THEN 'WFH'
        ELSE 'On-Site'
    END AS job_work_location

FROM 
    job_postings_fact
GROUP BY
    job_work_location



/* Problem 3*/
SELECT 
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title LIKE '%Senior%' THEN 'Senior'
        WHEN job_title LIKE '%Manager%' OR job_title LIKE '%Lead%' THEN 'Lead/Manager'
        WHEN job_title LIKE '%Junior%' OR job_title LIKE '%Entry%' THEN 'Senior'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE THEN 'Yes'
        ELSE 'No'
    END AS remote_option
FROM   
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY   
    job_id;
