# Introduction

 This project is a deep dive into the current job market to identify the most financially rewarding and strategically important skills for Data Analyst and Business Analyst roles.

 The goal of this analysis is to move beyond simple job counts and understand which skills offer both high compensation and low risk, which roles provide the best salary opportunities, and how the broader market behaves across remote and senior-level positions.

 Through a series of SQL queries, the project identifies:

* Skills with the most predictable and stable salary ranges

* The highest-paying Data Analyst and Business Analyst roles

* Skill requirements behind top-compensated positions

* The most demanded core skills in the job market

* High-paying but niche technical skills

* The optimal skills to learn based on both salary and demand


This repository provides a data-driven, evidence-based overview of the current analytics job landscape — useful for analysts, students, and career-focused professionals who want to understand where to invest their learning time for maximum impact.

SQL queries? Check them out
here: [project_sql folder](/project_sql/)

# Background

The modern **Data Analyst** job market is shaped by rapid changes in technology, the rise of cloud platforms, increasing automation, and the growing importance of data in strategic decision-making. Employers now expect analysts to combine traditional analytical skills with **programming**, **data engineering concepts**, and **business intelligence tools**. As a result, not all skills provide the same career value — some are widely demanded but offer broad salary ranges, while others are niche but highly paid and more stable.

To understand these dynamics, this project analyzes a comprehensive dataset of job postings that includes salary information, skill requirements, company attributes, and job categories. Using **SQL**, the analysis examines both the supply side (number of postings requiring each skill) and the compensation side (salary averages, standard deviations, and stability metrics).

Several core questions guide the project:

* Which skills consistently appear in the highest number of job postings?

* Do the most demanded skills also provide the highest salary stability?

* What skills are required for elite, top-paying remote roles?

* Which niche technical skills offer exceptional salaries despite lower demand?

* Which combination of demand, salary, and stability defines the most optimal skill set?

By structuring the dataset with CTEs and targeted filtering, the project isolates salary-cleaned records, identifies high-paying positions, and measures salary variance for each skill. This creates a clearer picture of how skill choice affects earnings potential and career risk.

---

#### **Data Source & Credits**

The data used for this analysis was sourced from a comprehensive job posting dataset, providing realistic and up-to-date market information.

**Credit:** This project utilizes the job posting dataset provided by **Luke Barousse**.

Data hails from [SQL Course](https://lukebarousse.com/sql). 

# Tools I Used
The project leveraged several tools for efficient database management, query development, and version control, ensuring a robust and repeatable analysis.       
| Category | Tool | Purpose |
| :--- | :--- | :--- |
| **Database Management** | **PostgreSQL** | Primary database used for robust data storage and execution of complex analytical SQL queries. |
| **Development** | **VS Code** | Used as the integrated development environment for writing SQL, Python scripts (if any), and managing project files. |
| **Version Control** | **Git** & **GitHub** | Essential for tracking all changes, managing code versions, and hosting the final project repository. |
| **Querying** | **SQLite** | Utilized for initial data exploration, quick querying, and lightweight data manipulation before scaling to PostgreSQL. |


# The Analysis

### 1. Skill Demand and Salary Risk Analysis

This analysis is based on an SQL query designed to identify high-value skills for Data Analyst roles by assessing two key metrics: average salary and salary stability. The query performs the following steps:
* **Salary Cleaning (salary_cleaned CTE):** It standardizes all reported salaries by converting hourly rates to annual salaries (multiplying by 2080 working hours) and filters the data specifically for job postings with the title *'Data Analyst'* that include salary information.

* **Skill Variance Calculation (skill_salary_variance CTE):** It calculates the *Average Salary* and *Standard Deviation* for each skill. This step only includes skills associated with more than 20 job postings , ensuring a statistically relevant sample size.

* **Risk Ratio Determination (Final SELECT):** The final output introduces the Risk Ratio Risk = Avg Salary / STDDEV. This metric quantifies salary stability: a higher Risk Ratio indicates lower salary variance relative to the average, suggesting the skill offers a more stable and predictable income.

``` sql
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
```

#### Breakdown and Overview
The analysis is presented in two main tables:
* **Risk Ratio Ranking:** This table ranks skills by their Risk Ratio (Average Salary / Standard Deviation), highlighting skills with the most predictable and stable salaries, such as SSRS and C#. These are considered the most stable skills regardless of job volume.
* **Job Count Ranking:** This table ranks skills by the absolute volume of job postings, identifying the most widely sought-after skills, like SQL, Excel, and Python. While highly demanded, these skills generally exhibit a wider salary range, reflecting lower stability compared to specialized skills.

----

This table shows the most frequently advertised skills, indicating broad market demand. While essential, these skills often have a lower Risk Ratio due to the wide range of salaries they command in the market.

| Skill      | Avg Salary ($) | Std Dev ($) | Job Count | Risk Ratio |
| ---------- | -------------- | ----------- | --------- | ---------- |
| SQL        | 92,643         | 34,804      | 5,012     | 2.66       |
| Excel      | 80,624         | 31,730      | 3,837     | 2.54       |
| Python     | 95,143         | 36,994      | 2,760     | 2.57       |
| Tableau    | 93,141         | 37,607      | 2,721     | 2.48       |
| SAS        | 86,648         | 33,050      | 1,656     | 2.62       |
| Power BI   | 87,822         | 32,528      | 1,620     | 2.70       |


 *High-Volume Skills (Based on Job Count)*

---

### 2. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered
data analyst positions by average yearly salary
and focusing on remote jobs. This query
highlights the high paying opportunities in the
field.

```sql
SELECT 
    job_id, 
    c.name as company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim c 
ON job_postings_fact.company_id = c.company_id
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home IS TRUE
ORDER BY salary_year_avg DESC
LIMIT 10;
```
The analysis of the top-paying remote Data Analyst jobs reveals a high-stakes market where compensation is heavily influenced by title seniority and a few extreme salary outliers.

* **Financial Range:** The annual salary spans a massive range from $184K to $650K, with a median pay of $211K representing the typical top-tier salary.

* **Seniority Premium:** The majority of the highest-paying jobs (60%) are explicitly designated as 'Director' or 'Principal' roles, proving that strategic and expert seniority commands a significant pay premium.

* **Top Companies:** Meta ($336.5K) and AT&T ($255.8K) lead the market among large corporations, while Mantys presents an extreme outlier with a $650K salary.


![Top Salary Outlier](assets\query1_graphg.png)
*Bar chart visualizing the top 10 Data Analyst salaries, generated using Gemini from the results of a SQL query.*

### 3. Skills for Top Paying Jobs 
This SQL query retrieves the top 10 highest-paying, remote Data or Business Analyst jobs and then lists the specific skills required for each of them.

🔍 Overview

**Goal:** Find the best-paid remote jobs for Data/Business Analysts.

**Method:** It first filters jobs by title ('Data Analyst' or 'Business Analyst'), remote work status, and salary, limiting the result to the top 10 by pay.

**Result:** It then links these top jobs to the list of technologies and skills needed for the role.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id, 
        c.name as company_name,
        j.job_title,
        salary_year_avg
    FROM job_postings_fact j
    LEFT JOIN company_dim c ON j.company_id = c.company_id  
        WHERE (job_title_short = 'Data Analyst' OR job_title_short = 'Business Analyst')
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home IS TRUE
    ORDER BY salary_year_avg DESC
    LIMIT 10
    )

SELECT 
    tpj.*,
    sd.skills as skill_name
FROM top_paying_jobs tpj
INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY tpj.salary_year_avg DESC
```
**Top Core Skills**
* SQL – required in almost every high-paying role

* Python – equally important as SQL

* Tableau – top visualization tool

**Conclusion:** 
Top-paying jobs require SQL + Python + BI tools + Cloud/big data experience.

![Most In-Demand Skills](assets\query2_gpt.jpg)
*Most In-Demand Skills in the Top-Paying Remote Data Analyst / Business Analyst Jobs (>$200K)*

### 4. In-Demand Skills for Data Analysts

This query identifies the top 5 most in-demand skills for Data Analyst jobs by counting the frequency of each skill mentioned in job postings.

```sql
SELECT 
    sd.skills,
    COUNT(sjd.job_id) as demand_count
FROM job_postings_fact tpj
INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 5;
```
📊 Key Results Breakdown
* **SQL is King:** The most demanded skill by a significant margin 92,628, confirming it as the fundamental requirement for all Data Analysts.
* **BI Tool Demand:** Tableau 46,554 and Power BI 39,468 are highly sought-after, showing that visualization and reporting are core job responsibilities.
* **Programming & Utility:** Python 57,326 is the preferred programming language for advanced analysis, while Excel 67,031 remains a critical tool for foundational data tasks.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 92628        |
| Excel    | 67031        |
| Python   | 57326        |
| Tableau  | 465554       |
| Power BI | 39468        |

*Table of the demand for the top 5 skills in data analyst job postings*

### 5. Skills Based on Salary
This query calculates and ranks the **average annual salary** associated with different **skills** for **remote Data Analyst** positions.

```sql
SELECT 
    sd.skills AS skill_name,
    ROUND(AVG(salary_year_avg)) AS average_salary
FROM job_postings_fact tpj
    INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE (job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL)
        AND job_work_from_home IS TRUE
GROUP BY sd.skills
ORDER BY average_salary DESC
```
Based on the provided list of top-paying skills for data analysts, here are three quick insights into the trends:

* **Premium on Big Data and Advanced Analytics:**
    The highest-paying skills are dominated by Big Data processing and 
    advanced machine learning tools. 
    For instance, PySpark ($208,172) and Databricks ($141,907)
    suggest a strong demand for analysts who can handle massive datasets 
    and cloud-based data platforms.

* **High Value in DevOps and MLOps Tools:**
    Several skills relate to software development, 
    version control, and DataOps/MLOps, 
    indicating that data analysts are increasingly expected to 
    contribute to the engineering and deployment side of data projects. 
    This includes skills like Bitbucket ($189,155), GitLab ($154,500), 
    Kubernetes ($132,500), and Airflow ($126,103).

* **Strong Compensation for Niche/Proprietary Systems:**
    Skills tied to specific or less common technologies, 
    particularly certain databases and AI platforms, 
    command higher salaries. 
    Examples include Couchbase ($160,515) and 
    Watson ($160,515), which indicates that expertise in specialized
    vendor ecosystems or less common database structures is highly rewarded.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 6. Most Optimal Skills to Learn
This query identifies the top skills for remote Data Analyst and Business Analyst roles, filtering for those with at least 21 postings and available salary data, and orders them by the highest average salary and then by demand count.

```sql
SELECT
    skills_dim. skill_id,
    skills_dim. skills,
    COUNT (skills_job_dim. job_id) AS demand_count,
    ROUND (AVG( job_postings_fact. salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact. job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title_short = 'Data Analyst' OR    
    job_title_short = 'Business Analyst') 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim. skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 20
ORDER BY
    avg_salary DESC,
    demand_count DESC
```
Here's a breakdown and recommendation based on your SQL query and results:

🔍 Query Definition
This query identifies the top skills for remote Data Analyst and Business Analyst roles, filtering for those with at least 21 postings and available salary data, and orders them by the highest average salary and then by demand count.

![Dual-axis chart for remote Data Analyst skills](assets\query5_chart.png)
*Dual-axis chart for remote Data Analyst skills. Snowflake (highest salary, $112K) and SQL (highest demand, 440 jobs) are key findings.*

📊 **Breakdown of Results**

The results provide a prioritized list of skills based on their market value and popularity for remote Data Analyst/Business Analyst jobs.

* **Highest Paying Skills (Cloud/Big Data/Niche Languages):** The top of the list features specialized skills that command a premium, such as Snowflake ($112,989), Hadoop ($111,849), and cloud platforms like Azure and AWS. This suggests expertise in modern data infrastructure is highly valued.

* **High Demand, High Value Skills (Programming/BI):** Python and R are high in demand (256 and 156 postings, respectively) and offer excellent average salaries (over $101k). Tableau is the second most demanded skill (257 postings) with a competitive salary ($99,807).

* **Foundational Skills (SQL/Office Suite):** SQL is the most demanded skill by a large margin (440 postings) but has a moderate average salary ($97,417). The Microsoft Office Suite skills (Excel, PowerPoint, Word) are highly demanded but have the lowest associated average salaries, confirming their status as necessary foundational knowledge rather than high-value differentiators.

# 💡 What I Learned

This project was a comprehensive exercise that significantly reinforced several key technical and analytical skills:

* **Advanced SQL and Analytical Querying:** I gained practical experience using **Common Table Expressions (CTEs)** to structure and solve multi-step analytical problems efficiently. This improved the readability and maintenance of complex queries.
* **End-to-End Workflow:** I successfully implemented an end-to-end data analysis workflow, from data extraction and storage in **PostgreSQL/SQLite** to query development in **VS Code**, and final presentation via **GitHub** and Markdown.
* **Market-Specific Data Insights:** The analysis provided concrete, actionable insights into the Data Analyst job market, confirming the high **Return on Investment (ROI)** for mastering skills like **Python** and advanced **SQL**, and highlighting the salary premium associated with **Cloud technologies** and Data Engineering skills.
* **Version Control Mastery:** I utilized **Git and GitHub** extensively for tracking project iterations, managing code changes, and ensuring the project's evolution was properly documented and ready for collaboration.

# ✅ Conclusion

The analysis successfully leveraged SQL to transform raw job posting data into actionable career intelligence.

### **1. Key Insights from Each Query**

| Query | Insight |
| :--- | :--- |
| **Salary Cleaning & Risk Ratio** | Standardizing salaries showed that some skills offer high pay with low variance. Tools like SSRS and C# had the most stable salary profiles. |
| **Top-Paying Jobs** | The highest salaries were mostly senior or director-level roles, with a few extreme outliers. Remote top-paying positions consistently exceeded $180K. |
| **Skills in Top-Paying Roles** | SQL, Python, cloud tools, and BI platforms appeared in almost every high-paying job. |
| **Most In-Demand Skills** | SQL, Excel, Python, Tableau, and Power BI dominate job postings, confirming them as essential baseline skills. |
| **Skills Based on Salary** | Niche technologies (PySpark, Databricks, Bitbucket, Couchbase) produced the highest average salaries. |
| **Optimal Skills** | Snowflake, SQL, and Python stood out when combining high salary and strong demand. |

---

### **2. Closing Thoughts**

This project helped me view the **Data Analyst** job market more analytically. Salary alone doesn’t show the full picture—stability, demand, and niche specialization all matter. The **SQL** queries provided a clear way to evaluate which skills offer both strong earning potential and practical job opportunities. Overall, the analysis gives a data-driven roadmap for deciding what skills are worth learning next.