/*
    Answer: What are the top skills based on salary?
    Look at the average salary associated with each skill for Data Analyst positions
    Focuses on roles with specified salaries, regardless of location
    Why? It reveals how different skills impact salary levels for Data Analysts and
    helps identify the most financially rewarding skills to acquire or improve
*/ 

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


/*
Based on the provided list of top-paying skills for data analysts, here are three quick insights into the trends:

Premium on Big Data and Advanced Analytics: 
    The highest-paying skills are dominated by Big Data processing and 
    advanced machine learning tools. 
    For instance, PySpark ($208,172) and Databricks ($141,907)
    suggest a strong demand for analysts who can handle massive datasets 
    and cloud-based data platforms.

High Value in DevOps and MLOps Tools: 
    Several skills relate to software development, 
    version control, and DataOps/MLOps, 
    indicating that data analysts are increasingly expected to 
    contribute to the engineering and deployment side of data projects. 
    This includes skills like Bitbucket ($189,155), GitLab ($154,500), 
    Kubernetes ($132,500), and Airflow ($126,103).

Strong Compensation for Niche/Proprietary Systems: 
    Skills tied to specific or less common technologies, 
    particularly certain databases and AI platforms, 
    command higher salaries. 
    Examples include Couchbase ($160,515) and 
    Watson ($160,515), which indicates that expertise in specialized
    vendor ecosystems or less common database structures is highly rewarded.
*/

/*[
  {
    "skill_name": "pyspark",
    "average_salary": "208172"
  },
  {
    "skill_name": "bitbucket",
    "average_salary": "189155"
  },
  {
    "skill_name": "couchbase",
    "average_salary": "160515"
  },
  {
    "skill_name": "watson",
    "average_salary": "160515"
  },
  {
    "skill_name": "datarobot",
    "average_salary": "155486"
  },
  {
    "skill_name": "gitlab",
    "average_salary": "154500"
  },
  {
    "skill_name": "swift",
    "average_salary": "153750"
  },
  {
    "skill_name": "jupyter",
    "average_salary": "152777"
  },
  {
    "skill_name": "pandas",
    "average_salary": "151821"
  },
  {
    "skill_name": "elasticsearch",
    "average_salary": "145000"
  },
  {
    "skill_name": "golang",
    "average_salary": "145000"
  },
  {
    "skill_name": "numpy",
    "average_salary": "143513"
  },
  {
    "skill_name": "databricks",
    "average_salary": "141907"
  },
  {
    "skill_name": "linux",
    "average_salary": "136508"
  },
  {
    "skill_name": "kubernetes",
    "average_salary": "132500"
  },
  {
    "skill_name": "atlassian",
    "average_salary": "131162"
  },
  {
    "skill_name": "twilio",
    "average_salary": "127000"
  },
  {
    "skill_name": "airflow",
    "average_salary": "126103"
  },
  {
    "skill_name": "scikit-learn",
    "average_salary": "125781"
  },
  {
    "skill_name": "jenkins",
    "average_salary": "125436"
  },
  {
    "skill_name": "notion",
    "average_salary": "125000"
  },
  {
    "skill_name": "scala",
    "average_salary": "124903"
  },
  {
    "skill_name": "postgresql",
    "average_salary": "123879"
  },
  {
    "skill_name": "gcp",
    "average_salary": "122500"
  },
  {
    "skill_name": "microstrategy",
    "average_salary": "121619"
  },
  {
    "skill_name": "crystal",
    "average_salary": "120100"
  },
  {
    "skill_name": "go",
    "average_salary": "115320"
  },
  {
    "skill_name": "confluence",
    "average_salary": "114210"
  },
  {
    "skill_name": "db2",
    "average_salary": "114072"
  },
  {
    "skill_name": "hadoop",
    "average_salary": "113193"
  },
  {
    "skill_name": "snowflake",
    "average_salary": "112948"
  },
  {
    "skill_name": "git",
    "average_salary": "112000"
  },
  {
    "skill_name": "ibm cloud",
    "average_salary": "111500"
  },
  {
    "skill_name": "azure",
    "average_salary": "111225"
  },
  {
    "skill_name": "bigquery",
    "average_salary": "109654"
  },
  {
    "skill_name": "aws",
    "average_salary": "108317"
  },
  {
    "skill_name": "shell",
    "average_salary": "108200"
  },
  {
    "skill_name": "unix",
    "average_salary": "107667"
  },
  {
    "skill_name": "java",
    "average_salary": "106906"
  },
  {
    "skill_name": "ssis",
    "average_salary": "106683"
  },
  {
    "skill_name": "jira",
    "average_salary": "104918"
  },
  {
    "skill_name": "oracle",
    "average_salary": "104534"
  },
  {
    "skill_name": "dax",
    "average_salary": "104500"
  },
  {
    "skill_name": "looker",
    "average_salary": "103795"
  },
  {
    "skill_name": "sap",
    "average_salary": "102920"
  },
  {
    "skill_name": "nosql",
    "average_salary": "101414"
  },
  {
    "skill_name": "python",
    "average_salary": "101397"
  },
  {
    "skill_name": "r",
    "average_salary": "100499"
  },
  {
    "skill_name": "redshift",
    "average_salary": "99936"
  },
  {
    "skill_name": "qlik",
    "average_salary": "99631"
  },
  {
    "skill_name": "tableau",
    "average_salary": "99288"
  },
  {
    "skill_name": "ssrs",
    "average_salary": "99171"
  },
  {
    "skill_name": "spark",
    "average_salary": "99077"
  },
  {
    "skill_name": "c++",
    "average_salary": "98958"
  },
  {
    "skill_name": "c",
    "average_salary": "98938"
  },
  {
    "skill_name": "sas",
    "average_salary": "98902"
  },
  {
    "skill_name": "sql server",
    "average_salary": "97786"
  },
  {
    "skill_name": "javascript",
    "average_salary": "97587"
  },
  {
    "skill_name": "rust",
    "average_salary": "97500"
  },
  {
    "skill_name": "power bi",
    "average_salary": "97431"
  },
  {
    "skill_name": "sql",
    "average_salary": "97237"
  },
  {
    "skill_name": "phoenix",
    "average_salary": "97230"
  },
  {
    "skill_name": "flow",
    "average_salary": "97200"
  },
  {
    "skill_name": "bash",
    "average_salary": "96558"
  },
  {
    "skill_name": "t-sql",
    "average_salary": "96365"
  },
  {
    "skill_name": "visio",
    "average_salary": "95842"
  },
  {
    "skill_name": "unity",
    "average_salary": "95500"
  },
  {
    "skill_name": "powershell",
    "average_salary": "95275"
  },
  {
    "skill_name": "mysql",
    "average_salary": "95224"
  },
  {
    "skill_name": "php",
    "average_salary": "95000"
  },
  {
    "skill_name": "mariadb",
    "average_salary": "95000"
  },
  {
    "skill_name": "matlab",
    "average_salary": "94200"
  },
  {
    "skill_name": "alteryx",
    "average_salary": "94145"
  },
  {
    "skill_name": "cognos",
    "average_salary": "93264"
  },
  {
    "skill_name": "spss",
    "average_salary": "92170"
  },
  {
    "skill_name": "pascal",
    "average_salary": "92000"
  },
  {
    "skill_name": "github",
    "average_salary": "91580"
  },
  {
    "skill_name": "outlook",
    "average_salary": "90077"
  },
  {
    "skill_name": "clickup",
    "average_salary": "90000"
  },
  {
    "skill_name": "vb.net",
    "average_salary": "90000"
  },
  {
    "skill_name": "sqlite",
    "average_salary": "89167"
  },
  {
    "skill_name": "vba",
    "average_salary": "88783"
  },
  {
    "skill_name": "powerpoint",
    "average_salary": "88701"
  },
  {
    "skill_name": "microsoft teams",
    "average_salary": "87854"
  },
  {
    "skill_name": "excel",
    "average_salary": "87288"
  },
  {
    "skill_name": "c#",
    "average_salary": "86540"
  },
  {
    "skill_name": "html",
    "average_salary": "86438"
  },
  {
    "skill_name": "sheets",
    "average_salary": "86088"
  },
  {
    "skill_name": "ms access",
    "average_salary": "85519"
  },
  {
    "skill_name": "chef",
    "average_salary": "85000"
  },
  {
    "skill_name": "node.js",
    "average_salary": "83500"
  },
  {
    "skill_name": "arch",
    "average_salary": "82750"
  },
  {
    "skill_name": "word",
    "average_salary": "82576"
  },
  {
    "skill_name": "spring",
    "average_salary": "82000"
  },
  {
    "skill_name": "spreadsheet",
    "average_salary": "81892"
  },
  {
    "skill_name": "sharepoint",
    "average_salary": "81634"
  },
  {
    "skill_name": "webex",
    "average_salary": "81250"
  },
  {
    "skill_name": "zoom",
    "average_salary": "80740"
  },
  {
    "skill_name": "terminal",
    "average_salary": "80625"
  },
  {
    "skill_name": "express",
    "average_salary": "80000"
  },
  {
    "skill_name": "plotly",
    "average_salary": "78750"
  },
  {
    "skill_name": "seaborn",
    "average_salary": "77500"
  },
  {
    "skill_name": "planner",
    "average_salary": "76800"
  },
  {
    "skill_name": "matplotlib",
    "average_salary": "76301"
  },
  {
    "skill_name": "ggplot2",
    "average_salary": "75000"
  },
  {
    "skill_name": "windows",
    "average_salary": "74124"
  },
  {
    "skill_name": "erlang",
    "average_salary": "72500"
  },
  {
    "skill_name": "julia",
    "average_salary": "71148"
  },
  {
    "skill_name": "colocation",
    "average_salary": "67500"
  },
  {
    "skill_name": "sass",
    "average_salary": "67500"
  },
  {
    "skill_name": "mongodb",
    "average_salary": "66020"
  },
  {
    "skill_name": "smartsheet",
    "average_salary": "63000"
  },
  {
    "skill_name": "visual basic",
    "average_salary": "62500"
  },
  {
    "skill_name": "ruby",
    "average_salary": "61780"
  },
  {
    "skill_name": "css",
    "average_salary": "52500"
  },
  {
    "skill_name": "ruby on rails",
    "average_salary": "51059"
  },
  {
    "skill_name": "wire",
    "average_salary": "42500"
  }
]
*/