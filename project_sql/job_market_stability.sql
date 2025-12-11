/*
    🚀 Data Analyst: Market Stability & Competitive Skill Analysis
    This project analyzes job posting data to move beyond simple high-salary metrics,
    quantifying the reliability and risk associated with top-paying skills 
    for Data Analyst roles in the current market.

    🎯 Project Goal
    The primary objective is to identify skills that
    not only command high average salaries 
    but also offer market stability (low variance/standard deviation) 
    by comparing salary potential against risk.
*/


WITH salary_cleaned AS (
    SELECT
        job_id,
        job_title,
        CASE
            WHEN salary_rate = 'hour' THEN (salary_hour_avg*2080)
            WHEN salary_rate = 'year' THEN salary_year_avg
        END AS yearly_salary
    FROM
        job_postings_fact              
    WHERE 
        (salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL) 
        AND job_title_short = 'Data Analyst'
),

skill_salary_variance AS (
    SELECT
        sd.skills AS skill_name,
        COUNT(sc.job_id) AS job_count,
        ROUND(AVG(sc.yearly_salary)) AS avg_salary,
        ROUND(STDDEV(sc.yearly_salary)) AS std_dev -- standart deviation
    FROM salary_cleaned sc
        INNER JOIN skills_job_dim sjd ON sc.job_id = sjd.job_id
        INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    GROUP BY 
        sd.skills
    HAVING
        COUNT(sc.job_id) > 20
)


SELECT 
    skill_name,
    job_count,
    avg_salary,
    std_dev,
    ROUND((avg_salary/std_dev),2) AS risk 
FROM 
    skill_salary_variance
ORDER BY 
    risk DESC