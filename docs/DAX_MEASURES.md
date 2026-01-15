# DAX Measures Documentation

## Overview

This document explains the business logic behind each DAX measure used in the Job Market Analytics dashboard. Measures are organized by category with plain-English explanations suitable for non-technical stakeholders.

---

## Core KPIs

### Total Postings
**What it does:** Counts the total number of job postings visible in the current filter context

**Business Logic:**
Simply counts rows in the fact table. This number changes when users apply filters (e.g., selecting "Data Analyst" or "Delhi").

**Why not use COUNT(JobID)?**
Using COUNTROWS ensures we count jobs, not skills. If we counted the bridge table, one job with 5 skills would count as 5 jobs.

**Used in:** Overview page KPI card, denominator for percentage calculations

---

### Average Salary (LPA)
**What it does:** Calculates the mean salary across all visible jobs

**Business Logic:**
Takes the salary midpoint for each job posting and averages them. Jobs without disclosed salaries are excluded from the calculation.

**Context Sensitivity:**
- Filter by "Senior Analyst" → shows ~₹12 LPA
- Filter by "Junior Analyst" → shows ~₹5 LPA
- No filters → shows overall market average (~₹8.5 LPA)

**Limitations:**
- Based on midpoint estimates (salary ranges compressed to single value)
- Excludes "Not Disclosed" postings (may skew if non-disclosure correlates with salary level)

**Used in:** Overview KPI card, salary comparison charts

---

### High-Pay Percentage
**What it does:** Shows what portion of jobs offer salaries above ₹12 LPA

**Business Logic:**
1. Count jobs where Salary_Mid > 12
2. Divide by total jobs
3. Express as percentage

**Why 12 LPA threshold?**
Industry convention for "senior" compensation tier in India analytics market.

**Interpretation:**
- 15% → Only senior roles paying premium salaries
- 40% → Healthy market with many mid-to-senior opportunities
- 5% → Market dominated by entry-level positions

**Used in:** Overview page KPI, trend analysis

---

## Skill Analysis Measures

### Postings with Skill (%)
**What it does:** Calculates what percentage of jobs require a specific skill

**Business Logic:**
When user selects a skill (e.g., "SQL") from slicer or visual:
1. Count jobs that require SQL (via bridge table)
2. Divide by all jobs in current context
3. Return percentage

**Example:**
- Total jobs visible: 10,000
- Jobs requiring SQL: 2,500
- Result: 25%

**Cross-Filtering Behavior:**
- Select "Data Analyst" role → shows SQL% among analysts only
- Select "Delhi" → shows SQL% for Delhi jobs
- Select both → shows SQL% for Delhi analysts

**Used in:** Skills heatmap, treemap, skill comparison bar charts

---

### Skill Demand Rank
**What it does:** Orders skills from most to least demanded

**Business Logic:**
Counts how many times each skill appears across all job-skill pairs, then sorts descending.

**Purpose:**
Quickly identify top 5-10 skills without manually counting. Used to filter visuals to "Top N Skills" for cleaner presentations.

**Used in:** Skills treemap (showing top 20), ranking tables

---

### Skill Co-Occurrence Score
**What it does:** Identifies skills that frequently appear together

**Business Logic:**
For a selected skill (e.g., "SQL"):
1. Find all jobs requiring SQL
2. Count how often Python, Excel, etc. appear in those same jobs
3. Express as percentage

**Example:**
- 1,000 jobs require SQL
- 700 of those also require Python
- Co-occurrence: 70%

**Business Value:**
Reveals skill bundles (e.g., "SQL + Python" package common for data engineers).

**Used in:** Advanced drill-through page (future enhancement)

---

## Role Segmentation Measures

### Data Analyst Postings
**What it does:** Counts jobs with "Analyst" in the title

**Business Logic:**
Uses pattern matching to identify analyst roles regardless of exact title format:
- "Data Analyst"
- "Business Analyst"
- "Senior Data Analyst"
All counted.

**Alternative Approach:**
Could use a dedicated RoleCategory column, but pattern matching handles variations without manual classification.

**Used in:** Role comparison charts, filtering

---

### Engineer vs Analyst Split