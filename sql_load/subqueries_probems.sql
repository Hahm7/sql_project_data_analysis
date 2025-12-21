SELECT 
    skill_id,
    count(*)
FROM 
    skills_job_dim
GROUP BY skill_id;



SELECT 
    skill_id,
    count(*)
FROM 
    skills_job_dim
GROUP BY 
    skill_id


SELECT 
    skills,
    count(*)
FROM
    skills_dim LEFT JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills
ORDER BY count(*) DESC
LIMIT 5;



SELECT 
    skill_id,
    count(*)
FROM 
    skills_job_dim
GROUP BY 
    skill_id 
ORDER BY
    count(*) DESC
LIMIT 5


/* PROBLEM 1*/


SELECT 
    skills_dim.skills
FROM skills_dim INNER JOIN (
    SELECT 
        skill_id,
        count(*) as skill_count
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id 
    ORDER BY
        count(*) DESC
    LIMIT 5
) as skills_list on skills_dim.skill_id = skills_list.skill_id
ORDER BY skills_list.skill_count DESC;



/* PROBLEM 2*/
SELECT
    company_id,
    name,
    CASE
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM (
    select 
        company_dim.company_id,
        company_dim.name,
        count(job_postings_fact.job_id) as job_count
    from 
        company_dim  
        INNER JOIN 
        job_postings_fact
        ON company_dim.company_id = job_postings_fact.company_id
    group by
        company_dim.company_id,
        company_dim.name
)



/* PROBLEM 3*/



SELECT 
    name
FROM
    (
        SELECT
            company_dim.name,
            company_dim.company_id,
            AVG(job_postings_fact.salary_year_avg)
        FROM
                company_dim
            INNER JOIN
                job_postings_fact
            ON
                company_dim.company_id
                =
                job_postings_fact.company_id
        GROUP BY
            company_dim.name,
            company_dim.company_id
        HAVING
            AVG(job_postings_fact.salary_year_avg) > (
                SELECT 
                    avg(salary_year_avg)
                FROM
                    job_postings_fact
            )
    )



-- Find the average salary of companies

SELECT
    company_dim.name,
    company_dim.company_id,
    AVG(job_postings_fact.salary_year_avg)
FROM
        company_dim
    INNER JOIN
        job_postings_fact
    ON
        company_dim.company_id
        =
        job_postings_fact.company_id
GROUP BY
    company_dim.name,
    company_dim.company_id
HAVING
    AVG(job_postings_fact.salary_year_avg) > (
        SELECT 
            avg(salary_year_avg)
        FROM
            job_postings_fact
    )





-- Find the average salary across all job postings
SELECT 
    avg(salary_year_avg)
FROM
    job_postings_fact



-- CTES Problem 1

select * from company_dim

with unique_company_name as (select 
    company_dim.name as company_name,
    count(distinct job_postings_fact.job_title) as job_count
from 
    job_postings_fact
    INNER JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
group by
    company_name
)

select 
    company_name,
    job_count
from
    unique_company_name
order by job_count DESC
LIMIT 10


-- Problem 2


WITH avg_salaries AS (
    select
        job_country,
        avg(salary_year_avg) as average_salary
    from
        job_postings_fact
    group by
        job_country
)




select 
    job_postings_fact.job_id,
    job_postings_fact.job_title_short,
    company_dim.name,
    job_postings_fact.salary_year_avg,
    avg_salaries.average_salary,
    job_postings_fact.job_country,
    avg_salaries.job_country
from
    job_postings_fact
    INNER JOIN
    company_dim
    ON job_postings_fact.company_id = company_dim.company_id
    INNER JOIN
    avg_salaries
    ON avg_salaries.job_country = job_postings_fact.job_country


select
    job_country,
    avg(salary_year_avg) as average_salary
from
    job_postings_fact
group by
    job_country

-- Problem 3

WITH skills_name AS (
    select 
        skills_job_dim.job_id as job_id,
        count(distinct skills_job_dim.skill_id) as skill_count
    from 
        skills_job_dim
    group by
        job_id
    order by
        skill_count
)

select
    company_dim.name,
    count(skills_name.skill_name) as skills_count,
    max(average_annual_salary)
from
    company_dim
    INNER JOIN
    skills_name
    ON company_dim.company_id = skills_name.company_id
group by
    company_dim.name
order by
    skills_count

select * from company_dim

select * from job_postings_fact

select job_id, count(skill_id) from skills_job_dim group by job_id having count(skill_id) = 0

select * from skills_dim


    select 
       skills_job_dim.job_id,
       skills_dim.skills as skill_name,
       job_postings_fact.salary_year_avg,
       job_postings_fact.company_id
    from 
        skills_job_dim
        INNER JOIN
        skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
        INNER JOIN
        job_postings_fact
        ON skills_job_dim.job_id = job_postings_fact.job_id


select
    job_postings_fact.company_id as company_id,
    max(job_postings_fact.salary_year_avg) as highest_salary
from
    job_postings_fact
group by 
    company_id
















