WITH top3 AS (
    SELECT
        company_id,
        COUNT(job_id) as job_count
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
    ORDER BY job_count DESC
    LIMIT 3
    )

SELECT
    company_id
FROM    
    job_postings_fact
WHERE company_id IN top3