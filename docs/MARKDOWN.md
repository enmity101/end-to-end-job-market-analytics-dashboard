# Project Overview: Job Market Analytics Dashboard

## Executive Summary

This project delivers a comprehensive business intelligence solution for analyzing India's technology job market using 54,000+ real job postings. The dashboard serves both job seekers optimizing their career strategy and HR professionals benchmarking compensation and skill requirements.

## Problem Statement

Job seekers and HR teams face three critical challenges:

1. **Skill Gap Uncertainty:** Which technical skills actually drive hiring decisions?
2. **Compensation Opacity:** What are realistic salary expectations by role, experience, and location?
3. **Market Intelligence:** Where should candidates focus applications, and how should recruiters position offers?

## Solution Approach

Built an end-to-end analytics pipeline:

**Data Layer:** Raw CSV → MySQL ingestion → Schema normalization (unpivoting skills)  
**Transformation Layer:** Power Query for cleaning, parsing, and standardization  
**Semantic Layer:** Star schema model with proper fact-dimension relationships  
**Calculation Layer:** DAX measures for KPIs and analytical metrics  
**Presentation Layer:** 4-page interactive dashboard with cross-filtering

## Dataset Characteristics

- **Volume:** 54,000+ job postings
- **Timeframe:** March 2023 snapshot
- **Geography:** Pan-India (concentration in Delhi NCR, Bangalore, Mumbai, Pune)
- **Scope:** IT, Finance, and Analytics departments
- **Granularity:** Individual job posting level with company, role, salary, and skills

**Data Quality Challenges Addressed:**
- 40% null values in skills columns
- Inconsistent salary formats ("3-5 LPA", "Not Disclosed")
- Duplicate skill entries (MySQL vs mysql)
- Experience stored as text ("3-5 yrs")
- Wide schema requiring normalization

## Technical Architecture

### ETL Pipeline
1. **Extract:** Kaggle dataset download
2. **Load:** MySQL bulk import with schema-on-read
3. **Transform:** 
   - SQL-based unpivoting (8 skill columns → long format)
   - Power Query parsing and standardization
   - Null handling and type conversions

### Data Model
**Star Schema Design:**
- Central fact table at job posting grain
- Dimension tables for skills, departments, locations, companies
- One-to-many relationships enabling proper aggregation
- Hidden intermediate tables to simplify user experience

### Calculation Strategy
- **Explicit Measures:** All KPIs defined as DAX measures (not implicit aggregations)
- **Filter Context Awareness:** Measures respond correctly to slicer selections
- **Performance Optimization:** Aggregations pre-calculated where possible

## Business Logic

### Key Metrics Defined
- **Market Activity:** Total postings, posting velocity
- **Compensation:** Average salary, high-pay percentage, geographic differentials
- **Skills Demand:** Penetration rates, skill co-occurrence patterns
- **Segmentation:** Role categories, experience bands, department splits

### Analytical Framework
Questions the dashboard answers:
- **What** skills are in highest demand?
- **Where** are the best-paying opportunities?
- **Who** (which companies) are hiring most actively?
- **When** do posting volumes peak?
- **How much** should I expect to earn at my experience level?
- **Why** do certain skills command premium salaries?

## Expected Business Impact

### For Job Seekers:
- Prioritize upskilling investments (e.g., learn SQL if targeting analyst roles)
- Set realistic salary expectations during negotiations
- Identify high-opportunity companies and locations
- Understand career progression timelines

### For Recruiters/HR:
- Benchmark compensation packages against market rates
- Identify competitive skill requirements for job descriptions
- Plan recruitment budgets based on hiring volume trends
- Adjust posting timing to align with candidate availability

### For Workforce Planners:
- Forecast skill shortages in the analytics domain
- Inform training program curriculum development
- Guide education-to-industry alignment initiatives

## Success Metrics

**Technical:**
- All 54,000 records successfully processed with <1% data loss
- Dashboard refresh time <5 seconds
- Zero broken relationships in data model
- All measures calculate correctly under filter context

**Business:**
- Dashboard enables answering 15+ predefined business questions
- Insights actionable (e.g., "Learn SQL" not "Data is interesting")
- Presentation-ready for portfolio review
- Demonstrates skills directly transferable to analyst roles

## Project Timeline

**Total Duration:** 10-15 hours over 5 days

- **Day 1:** Data acquisition, exploration, SQL setup (2-3 hours)
- **Day 2:** Power Query ETL and data model (3-4 hours)
- **Day 3:** DAX measures and validation (2-3 hours)
- **Day 4:** Dashboard design and visual development (4-5 hours)
- **Day 5:** Testing, documentation, publishing (2 hours)

## Deliverables

1. **Power BI Dashboard (.pbix file):** 4 interactive pages
2. **SQL Scripts:** ETL code for reproducibility
3. **Documentation Suite:** README, technical specs, insights summary
4. **Demo Video:** 2-3 minute walkthrough
5. **GitHub Repository:** Complete project package
6. **Published Service:** Cloud-accessible dashboard

## Differentiation

What makes this project portfolio-worthy:

- **Real data:** Not synthetic or tutorial dataset
- **End-to-end:** From raw CSV to deployed dashboard
- **Business-focused:** Answers specific stakeholder questions
- **Technically rigorous:** Proper normalization, star schema, explicit measures
- **Well-documented:** Fully explained methodology
- **Reproducible:** All code and data sources provided

## Next Steps

Post-delivery enhancements:
- Automate data refresh pipeline
- Add predictive salary modeling
- Integrate NLP for skill extraction from job descriptions
- Expand to multi-month trend analysis
- Create role-specific drill-through pages

---

*This overview provides the strategic context for technical implementation details found in companion documentation files.*