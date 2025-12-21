-- Problem 1
-- Select job postings with salary information
(
SELECT 
    job_id, 
    job_title, 
    'With Salary Info' AS salary_info  -- Custom field indicating salary info presence
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL  
)
UNION ALL
 -- Select job postings without salary information
(
SELECT 
    job_id, 
    job_title, 
    'Without Salary Info' AS salary_info  -- Custom field indicating absence of salary info
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NULL AND salary_hour_avg IS NULL 
)
ORDER BY 
    salary_info DESC, 
    job_id; 


SELECT * FROM skills_dim;

SELECT * FROM skills_job_dim;



-- Problem 2

-- WITH january_jobs AS (
--     SELECT 
--         job_postings_fact.job_id as job_id,
--         job_postings_fact.job_title_short as job_title,
--         job_postings_fact.job_location as job_location,
--         job_postings_fact.job_via as job_via,
--         skills_dim.skills as skill,
--         skills_dim.type as skill_type
--     FROM 
--         job_postings_fact LEFT JOIN
--         skills_job_dim ON
--         job_postings_fact.job_id = skills_job_dim.job_id
--         LEFT JOIN skills_dim
--         ON skills_job_dim.skill_id = skills_dim.skill_id
--     WHERE 
--         EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 1
--         AND
--         job_postings_fact.salary_year_avg > 70000
-- )


-- WITH february_jobs AS (
--     SELECT 
--         job_postings_fact.job_id as job_id,
--         job_postings_fact.job_title_short as job_title,
--         job_postings_fact.job_location as job_location,
--         job_postings_fact.job_via as job_via,
--         skills_dim.skills as skill,
--         skills_dim.type as skill_type
--     FROM 
--         job_postings_fact LEFT JOIN
--         skills_job_dim ON
--         job_postings_fact.job_id = skills_job_dim.job_id
--         LEFT JOIN skills_dim
--         ON skills_job_dim.skill_id = skills_dim.skill_id
--     WHERE 
--         EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 2
--         AND
--         job_postings_fact.salary_year_avg > 70000

-- )


-- WITH march_jobs AS (
--     SELECT 
--         job_postings_fact.job_id as job_id,
--         job_postings_fact.job_title_short as job_title,
--         job_postings_fact.job_location as job_location,
--         job_postings_fact.job_via as job_via,
--         skills_dim.skills as skill,
--         skills_dim.type as skill_type
--     FROM 
--         job_postings_fact LEFT JOIN
--         skills_job_dim ON
--         job_postings_fact.job_id = skills_job_dim.job_id
--         LEFT JOIN skills_dim
--         ON skills_job_dim.skill_id = skills_dim.skill_id
--     WHERE 
--         EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 3
--         AND
--         job_postings_fact.salary_year_avg > 70000

-- )


SELECT 
    job_id,
    job_title_short,
    job_location,
    job_via,
    skill,
    skill_type

FROM
    january_jobs
UNION ALL
SELECT 
    job_id,
    job_title_short,
    job_location,
    job_via,
    skill,
    skill_type

FROM




SELECT * FROM
(
    SELECT 
        january_jobs.job_id as job_id,
        january_jobs.job_title_short as job_title,
        january_jobs.job_location as job_location,
        january_jobs.job_via as job_via,
        skills_dim.skills as skill,
        skills_dim.type as skill_type
    FROM 
        january_jobs LEFT JOIN
        skills_job_dim ON
        january_jobs.job_id = skills_job_dim.job_id
        LEFT JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        january_jobs.salary_year_avg > 70000
    UNION ALL
    SELECT 
        february_jobs.job_id as job_id,
        february_jobs.job_title_short as job_title,
        february_jobs.job_location as job_location,
        february_jobs.job_via as job_via,
        skills_dim.skills as skill,
        skills_dim.type as skill_type
    FROM 
        february_jobs LEFT JOIN
        skills_job_dim ON
        february_jobs.job_id = skills_job_dim.job_id
        LEFT JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        february_jobs.salary_year_avg > 70000
    UNION ALL
    SELECT 
        march_jobs.job_id as job_id,
        march_jobs.job_title_short as job_title,
        march_jobs.job_location as job_location,
        march_jobs.job_via as job_via,
        skills_dim.skills as skill,
        skills_dim.type as skill_type
    FROM 
        march_jobs LEFT JOIN
        skills_job_dim ON
        march_jobs.job_id = skills_job_dim.job_id
        LEFT JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        march_jobs.salary_year_avg > 70000
)
ORDER BY
    job_id 



SELECT * FROM january_jobs



-- Problem 3

select * from job_postings_fact



select * from skills_dim

select * from skills_job_dim


select 
    skills_dim.skills, 
    count(job_postings_fact.job_id)
from
    job_postings_fact 
    INNER JOIN
    skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    count(job_postings_fact.job_id) DESC
    


-- Answer to problem 3

-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
    SELECT
        skills_dim.skills,  
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
        COUNT(combined_job_postings.job_id) AS postings_count 
    FROM
        combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
    GROUP BY
        skills_dim.skills, 
        year, 
        month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
    skills,  
    year,  
    month,  
    postings_count 
FROM
    monthly_skill_demand
ORDER BY
    skills, 
    year,
    month;
