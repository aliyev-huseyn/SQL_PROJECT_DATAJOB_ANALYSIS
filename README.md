# Introduction
 This project conducts an **SQL-based market analysis of Data Analyst job postings**.

The core goal is to provide **clear, actionable insights** into the current job landscape by answering five key questions about:
* Top-paying salaries
* In-demand skills
* The optimal skill set for career growth

The analysis focuses specifically on **remote Data Analyst roles** to understand the high-growth, flexible segment of the modern job market.
SQL queries? Check them out
here: [project_sql folder](/project_sql/)

# Background
### **Project Goals & Analytical Questions**

The primary motivation for this project was to provide a data-driven guide for career advancement and skill development in the Data Analyst field. This analysis was structured around answering the following five key business questions using SQL:

1.  **What are the top-paying Data Analyst jobs?** (Focus on remote roles with specified salaries)
2.  **What skills are required for these top-paying jobs?** (Identifying the tech stack of high-value roles)
3.  **What skills are most in demand for Data Analysts?** (Counting the frequency of skills in job postings)
4.  **Which skills are associated with higher salaries?** (Calculating the average salary per skill)
5.  **What are the most optimal skills to learn?** (Balancing high demand with high salary)

---

### **Data Source & Credits**

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
### 1. Top Paying Data Analyst Jobs
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

### 2. Skills for Top Paying Jobs 
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

### 3. In-Demand Skills for Data Analysts

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

### 4. Skills Based on Salary
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

### 5. Most Optimal Skills to Learn
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
    job_title_short = 'Data Analyst'
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

* **Advanced SQL and Analytical Querying:** I gained practical experience using **Common Table Expressions (CTEs)** to structure and solve multi-step analytical problems efficiently (e.g., Query 5). This improved the readability and maintenance of complex queries.
* **End-to-End Workflow:** I successfully implemented an end-to-end data analysis workflow, from data extraction and storage in **PostgreSQL/SQLite** to query development in **VS Code**, and final presentation via **GitHub** and Markdown.
* **Market-Specific Data Insights:** The analysis provided concrete, actionable insights into the Data Analyst job market, confirming the high **Return on Investment (ROI)** for mastering skills like **Python** and advanced **SQL**, and highlighting the salary premium associated with **Cloud technologies** and Data Engineering skills.
* **Version Control Mastery:** I utilized **Git and GitHub** extensively for tracking project iterations, managing code changes, and ensuring the project's evolution was properly documented and ready for collaboration.

# ✅ Conclusion

The analysis successfully leveraged SQL to transform raw job posting data into actionable career intelligence.

### **1. Key Insights from Each Query**

| Query | Insight |
| :--- | :--- |
| **1) Top-Paying Jobs** | **Seniority and Niche Specialization** are key to high compensation. The highest remote salaries are generally found in specific, high-level roles with clearly defined responsibilities. |
| **2) Skills for Top Jobs** | **Advanced skills**—particularly **Python**, **cloud platforms**, and deep **SQL** knowledge—are non-negotiable for securing top-tier salaries. |
| **3) Most In-Demand Skills** | **SQL** remains the undisputed foundational skill, followed closely by visualization tools and basic programming, indicating the core requirements for entry and mid-level roles. |
| **4) Skills vs. Higher Salaries** | Skills related to **Data Engineering** and **Big Data tools** (like Spark or Cloud services) command the highest average salaries, suggesting that cross-functional knowledge is highly rewarded. |
| **5) Most Optimal Skills** | **Python** and advanced **SQL** offer the **best return on investment (ROI)**, balancing high demand across the market with significantly above-average salaries. |

---

### **2. Closing Thoughts**

This project successfully provided **me** with a **data-driven roadmap** for my own career progression in data analysis. By systematically identifying the convergence of demand and salary, **I learned** that the optimal strategy is clear: **I must master the fundamentals (SQL) and strategically specialize in high-value programming or cloud technologies (Python and AWS/Azure)**. This approach will ensure my maximum marketability and maximize my earning potential in the competitive and flexible remote job landscape.