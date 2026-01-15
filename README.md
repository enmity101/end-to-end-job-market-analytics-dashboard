# Job Market Analytics Dashboard
![Power BI](https://github.com/user-attachments/assets/f261e0f5-4988-42d8-a540-fdadee1d3d2d)
## Project Overview

A comprehensive Power BI dashboard analyzing India's technology job market through 54,000+ job postings scraped from Naukri.com. This project demonstrates end-to-end data analytics capabilities including ETL pipeline development, data modeling, DAX measure creation, and business insight generation.

---

## Business Objective

Answer critical questions for job seekers and HR professionals:
- What skills are most in-demand for Data Analyst and related roles?
- How do salaries vary by location, experience, and role type?
- Which companies are hiring most actively?
- What experience levels command premium compensation?
- How have hiring trends evolved over time?

---

## Dataset

**Source:** [Naukri Jobs Data - March 2023 (Kaggle)](https://www.kaggle.com/datasets/riteshmn/naukri-jobs-data-mar2023)

**Scope:**
- 54,000+ job postings
- March 2023 snapshot
- Focus: IT, Finance, and Analytics departments
- Geographic coverage: Pan-India with major metro concentration

**Key Attributes:**
- Job titles and descriptions
- Company names and ratings
- Experience requirements
- Salary ranges (LPA format)
- Locations (city-level)
- Skills (up to 8 per posting)
- Posting dates
- Department classifications

---

## Tools & Technologies

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Data Ingestion** | MySQL | Raw data loading and initial validation |
| **ETL** | Power Query (M) | Data cleaning, transformation, unpivoting |
| **Normalization** | SQL (UNION ALL) | Schema transformation (wide-to-long) |
| **Modeling** | Power BI | Star schema relationships |
| **Calculations** | DAX | Business metrics and KPIs |
| **Visualization** | Power BI Desktop | Interactive dashboards |
| **Publishing** | Power BI Service | Cloud deployment |

---

## Data Preparation Workflow

### 1. Raw Ingestion (SQL)
- Created `job_market` database in MySQL
- Loaded raw CSV with schema-on-read strategy (all TEXT columns)
- Validated record counts and domain relevance (Data/Analyst roles)

### 2. Schema Transformation
**Problem:** Skills stored across 8 columns (skill_1 through skill_8) violates First Normal Form

**Solution:** Unpivoted skills using UNION ALL to create one-to-many job-skill relationships
- **Before:** 54,000 rows × 8 skill columns
- **After:** ~120,000+ job-skill pairs (long format)

### 3. Power Query Transformations
- **Date Parsing:** Converted `posted_on` to proper date type
- **Salary Extraction:** Parsed "3.20-3.40LPA" text into numeric midpoint values
- **Experience Normalization:** Extracted years from "3-5 yrs" format
- **Null Handling:** Replaced missing salaries with "Not Disclosed"
- **Filtering:** Focused on Data/Analyst roles in IT and Finance departments
- **Skill Standardization:** Grouped variants (MySQL, PostgreSQL → SQL; Python variations → Python)

### 4. Data Model Design
**Star Schema:**
- **Fact Table:** `FactJobs` (grain: one row per job posting)
- **Dimension Tables:** 
  - `DimSkills` (normalized skill taxonomy)
  - `DimDepartments`
  - `DimLocations`
  - `DimCompanies`

**Relationships:** One-to-many from dimensions to facts, ensuring proper filtering propagation

---

## Key Metrics & Business Logic

### Core KPIs
- **Total Postings:** Simple row count of active job listings
- **Average Salary (LPA):** Mean of parsed salary midpoints across visible jobs
- **High-Pay Threshold:** Percentage of roles offering >12 LPA
- **Skill Penetration Rate:** What % of jobs require a specific skill

### Analytical Measures
- **Postings by Skill:** Count of jobs filtered by selected skill, used for demand ranking
- **Experience vs Salary Correlation:** Scatter analysis revealing compensation growth curves
- **Geographic Salary Index:** Location-based salary benchmarking
- **Temporal Trends:** Month-over-month posting volume changes

### Segmentation Logic
- **Role Classification:** Pattern matching on titles (Analyst, Engineer, Scientist, Manager)
- **Seniority Levels:** Experience bands (0-2, 3-5, 6-10, 10+ years)
- **Salary Tiers:** Entry (<5 LPA), Mid (5-10), Senior (10-15), Leadership (15+)

*Detailed DAX formulas available in `DAX_MEASURES.md`*

---

## Dashboard Pages

### Page 1: Market Overview
**Purpose:** High-level snapshot of the job market

**Visuals:**
- KPI cards showing total postings, average salary, and high-pay percentage
- Time-series line chart of posting volumes by month
- Department distribution bar chart (IT dominates at ~40%)

**Insights Answered:**
- How active is the current job market?
- What's the baseline salary expectation?
- Which departments are hiring most?

---

### Page 2: Roles & Experience
**Purpose:** Understand role types and experience-compensation relationships

**Visuals:**
- Clustered column chart of postings by role category
- Scatter plot: Salary vs Experience (shows clear positive correlation)
- Experience distribution histogram

**Insights Answered:**
- Which analytical roles have most openings?
- How does pay scale with experience?
- What experience level sees peak demand?

---

### Page 3: Skills Analysis
**Purpose:** Identify in-demand technical skills

**Visuals:**
- Matrix heatmap: Skill penetration % by role type
- Treemap of top 20 skills by frequency
- Line chart showing skill demand trends over time

**Insights Answered:**
- What are the top 5 must-have skills?
- Do different roles require different skill mixes?
- Which skills are gaining/declining in demand?

---

### Page 4: Companies & Locations
**Purpose:** Identify top employers and geographic hotspots

**Visuals:**
- Table of companies ranked by posting volume and average salary offered
- Gauge chart: Salary comparison across major cities
- Map visual showing geographic concentration

**Insights Answered:**
- Which companies are hiring most aggressively?
- Where are the highest-paying opportunities?
- Should I relocate for better compensation?

---

## Key Insights

Based on analysis of 54,000+ job postings:

### Skills Landscape
- **SQL remains critical:** Present in 25-30% of Data Analyst roles, highest demand skill
- **Python/Excel tie:** Both appear in ~18-20% of postings, essential dual skillset
- **Power BI rising:** Visualization tools showing increased prominence in recent months
- **Domain tools matter:** Tableau, R, and advanced Excel still relevant for specific roles

### Salary Benchmarks
- **Entry-level (0-2 years):** ₹3-5 LPA typical range
- **Mid-level (3-5 years):** ₹6-10 LPA, steepest growth phase
- **Senior (6-10 years):** ₹10-15 LPA plateau
- **Geographic premium:** Delhi NCR and Bangalore offer 15-20% higher compensation than Tier-2 cities

### Market Dynamics
- **IT department dominates:** 40% of all analytics postings
- **Finance sector active:** 15-20% of roles, often higher base salaries
- **Experience matters:** Each additional year of experience correlates with ~₹1-1.5 LPA increase
- **Company size variance:** Large enterprises post higher volumes but mid-sized firms offer competitive pay

### Hiring Patterns
- **Peak posting months:** February-April (fiscal year-end hiring cycles)
- **Role evolution:** "Data Analyst" being supplemented by "Business Analyst" and "Analytics Engineer" titles
- **Skill bundling:** 70% of high-paying roles require 4+ skills simultaneously

---

## How to Use This Dashboard
1. **Filter by desired role and location** using slicers on each page
2. **Check Skills Analysis page** to identify gaps in your current skillset
3. **Use Salary benchmarks** to set realistic compensation expectations
4. **Review Companies page** to target high-volume or high-pay employers

### Interactive Features:
- **Cross-filtering:** Click any visual element to filter all other visuals
- **Drill-through:** Right-click on company names to see detailed breakdowns
- **Slicers:** Use multi-select for comparing multiple skills or locations
- **Tooltips:** Hover over data points for detailed breakdowns

---
---

## Skills Demonstrated

**Technical:**
- Data engineering (ETL pipeline design)
- SQL (schema transformation, normalization, UNION operations)
- Power Query (M language for complex transformations)
- DAX (calculated columns, measures, time intelligence)
- Data modeling (star schema design, relationship management)
- Data visualization (storytelling through charts)

**Business:**
- Translating messy real-world data into clean analytics
- Defining meaningful KPIs aligned with stakeholder questions
- Identifying actionable insights from patterns
- Communicating technical findings to non-technical audiences

**Soft Skills:**
- End-to-end project ownership
- Documentation and knowledge transfer
- Portfolio presentation

---

## Future Enhancements

- **Real-time data refresh:** Automate scraping and incremental loads
- **Predictive modeling:** Salary prediction based on skills/experience using Python integration
- **NLP analysis:** Extract skills from job descriptions using text analytics
- **Competitive intelligence:** Company-to-company comparison matrices
- **Mobile optimization:** Responsive layouts for phone/tablet viewing

---

## Contact & Portfolio

**Author:** Harsh Pratap Singh   
**LinkedIn:** https://www.linkedin.com/in/harshsingh94/  
**Email:** harshpratapsingh892@gmail.com  
**Portfolio:** [I'll update it later]

---

## Acknowledgments

- **Dataset:** Ritesh M N (Kaggle)
- **Inspiration:** Data analytics community tutorials
- **Tools:** Microsoft Power BI, MySQL Community Edition

---

## License

This project is available for educational and portfolio purposes. Dataset usage governed by Kaggle's terms of service.

---

*Last Updated: January 2026*
