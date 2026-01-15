# Data Model Documentation

## Overview

The Job Market Analytics dashboard uses a **star schema** design optimized for analytical queries and Power BI's filtering engine. This document explains the model structure, relationships, and design decisions.

## Schema Design: Star vs Snowflake

**Chosen Approach:** Star Schema

**Rationale:**
- Simpler for Power BI's DirectQuery/Import engine
- Faster query performance (fewer joins)
- Easier for business users to understand
- Sufficient for current analytical requirements

## Table Inventory

### Fact Table

#### `FactJobs`
**Grain:** One row per job posting

**Columns:**
- `JobID` (Surrogate Key): Unique identifier
- `Title`: Job title as posted
- `Company`: Employer name
- `StarRating`: Company rating (1-5 scale)
- `ReviewsCount`: Number of company reviews
- `Experience_Years`: Numeric years extracted from text
- `Salary_Mid`: Parsed midpoint salary in LPA
- `Location`: City name
- `JobDescription`: Full text description
- `PostedDate`: Date of posting
- `DeptID`: Foreign key to DimDepartments
- `CompanyID`: Foreign key to DimCompanies (if normalized)

**Row Count:** ~54,000 (full dataset) or ~10,000 (filtered to Data/Analyst roles)

**Cardinality Considerations:**
- Each job posting appears exactly once
- Skills linked via bridge table to maintain proper many-to-many relationship

---

### Dimension Tables

#### `DimSkills`
**Grain:** One row per unique skill

**Columns:**
- `SkillID` (Primary Key)
- `SkillName`: Standardized skill name (e.g., "SQL", "Python")
- `SkillCategory`: Grouped classification (e.g., "Programming", "Databases", "BI Tools")

**Row Count:** ~50-100 unique skills

**Standardization Logic:**
Skills were normalized during ETL:
- MySQL, PostgreSQL, T-SQL, SQL Server → "SQL"
- Python, Python3, Python 3.x → "Python"
- Power BI, PowerBI, Power BI Desktop → "Power BI"

---

#### `BridgeJobSkills` (Many-to-Many Resolver)
**Grain:** One row per job-skill pair

**Columns:**
- `JobID` (Foreign Key to FactJobs)
- `SkillID` (Foreign Key to DimSkills)

**Row Count:** ~120,000+ (multiple skills per job)

**Purpose:**
Resolves the many-to-many relationship:
- One job requires multiple skills
- One skill appears in multiple jobs

**Alternative Approach Rejected:**
Denormalization (repeating job rows per skill) would cause:
- Incorrect aggregations (double-counting salaries)
- Inflated KPI values
- Filtering ambiguities

---

#### `DimDepartments`
**Grain:** One row per department

**Columns:**
- `DeptID` (Primary Key)
- `DeptName`: Department name (e.g., "IT", "Finance", "Marketing")

**Row Count:** ~10-15 departments

---

#### `DimLocations`
**Grain:** One row per city

**Columns:**
- `LocationID` (Primary Key)
- `City`: City name
- `State`: State/region
- `Metro_Tier`: Classification (Tier-1, Tier-2, Tier-3)

**Row Count:** ~50-100 cities

**Enhancement Opportunity:**
Add latitude/longitude for map visuals

---

#### `DimCompanies`
**Grain:** One row per unique company

**Columns:**
- `CompanyID` (Primary Key)
- `CompanyName`: Standardized company name
- `Industry`: Sector classification (if available)

**Row Count:** ~5,000-10,000 companies

**Note:** Currently embedded in FactJobs; dimension split optional for advanced filtering

---

#### `DimDate` (Optional but Recommended)
**Grain:** One row per day

**Columns:**
- `Date` (Primary Key)
- `Year`, `Quarter`, `Month`, `MonthName`
- `WeekOfYear`, `DayOfWeek`
- `IsWeekend`, `FiscalYear`

**Purpose:**
Enables time intelligence functions in DAX (YTD, MTD, same period last year)

---

## Relationships

### Relationship Diagram (Conceptual)
```
        DimSkills
             |
             | (SkillID)
             |
    BridgeJobSkills -----(JobID)---- FactJobs -----(DeptID)---- DimDepartments
                                        |
                                        |--(LocationID)-- DimLocations
                                        |
                                        |--(PostedDate)-- DimDate
                                        |
                                        |--(CompanyID)--- DimCompanies
```

### Relationship Details

| From Table | To Table | Cardinality | Cross-Filter Direction | Active |
|------------|----------|-------------|------------------------|--------|
| DimSkills | BridgeJobSkills | 1:Many | Single | Yes |
| BridgeJobSkills | FactJobs | Many:1 | Single | Yes |
| DimDepartments | FactJobs | 1:Many | Single | Yes |
| DimLocations | FactJobs | 1:Many | Single | Yes |
| DimDate | FactJobs | 1:Many | Single | Yes |
| DimCompanies | FactJobs | 1:Many | Single | Yes |

**Cross-Filter Direction:**
- Set to **Single** (dimension → fact) for performance
- Prevents circular dependencies
- Bi-directional filtering avoided unless absolutely necessary

---

## Design Decisions

### Why Separate Skill Dimension?

**Problem:** Raw data had skills in 8 columns (skill_1 through skill_8)

**Options Considered:**
1. Keep wide format, create 8 measure for each skill column ❌
2. Unpivot in Power Query, keep all in fact table ❌
3. Unpivot and create skill dimension ✅

**Chosen Approach Benefits:**
- Enables filtering by skill without complex DAX
- Reduces fact table width
- Supports skill grouping/categorization
- Allows skill hierarchy drilling

---

### Bridge Table vs Denormalization

**Why use BridgeJobSkills instead of repeating jobs?**

**Example:**
Job "Data Analyst @ TCS" requires SQL, Python, Excel

**Bad Approach (Denormalized):**
```
JobID | Title | Salary | Skill
1     | DA    | 8 LPA  | SQL
1     | DA    | 8 LPA  | Python
1     | DA    | 8 LPA  | Excel
```
**Problem:** `SUM(Salary)` = 24 LPA (wrong! Should be 8)

**Good Approach (Bridge Table):**
- FactJobs: 1 row (JobID=1, Salary=8)
- Bridge: 3 rows (JobID=1→SkillID=SQL, Python, Excel)
- Aggregations work correctly

---

### Surrogate Keys vs Natural Keys

**JobID:** Auto-generated surrogate key (not title/company combo)
- Handles duplicate job titles at same company
- Faster joins (integer vs text comparison)
- Stable even if title is corrected

**SkillID, DeptID, LocationID:** Surrogate keys for consistency

---

## Hidden Tables and Columns

**Hidden from Report View:**
- Intermediate transformation queries (raw unpivot steps)
- Foreign key columns in fact table (use dimension values instead)
- Technical columns (ETL timestamps, row hash keys)

**Purpose:**
- Simplifies field list for report builders
- Prevents accidental use of redundant fields
- Guides users toward correct measure usage

---

## Data Types and Formats

| Column | Data Type | Format | Notes |
|--------|-----------|--------|-------|
| JobID | Integer | - | Surrogate key |
| Title | Text | - | Unicode support |
| Salary_Mid | Decimal (10,2) | Currency | In Lakhs (LPA) |
| Experience_Years | Integer | - | Whole numbers only |
| PostedDate | Date | DD/MM/YYYY | No time component |
| StarRating | Decimal (2,1) | 0.0 | 1.0 to 5.0 scale |
| ReviewsCount | Integer | #,##0 | Thousands separator |

---

## Row-Level Security (RLS)

**Current State:** Not implemented (public dataset)

**Future Enhancement:**
If dashboard deployed for company-specific use:
```DAX
[UserDepartment] = USERNAME()
```
Filter FactJobs to only show jobs matching user's department

---

## Performance Optimizations

### Indexing Strategy (If using DirectQuery)
- Primary keys: Clustered indexes
- Foreign keys: Non-clustered indexes
- Frequently filtered columns (Location, Dept): Indexes

### Aggregations
- Pre-calculated skill counts in DimSkills
- Monthly aggregation table for time-series charts

### Column Selection
- Only loaded necessary columns (excluded verbose job descriptions from visuals)
- Text columns trimmed to reduce file size

---

## Model Validation Checklist

✅ All relationships have correct cardinality  
✅ No circular dependencies detected  
✅ Cross-filter directions set appropriately  
✅ Primary keys are unique (no duplicates)  
✅ Foreign keys match dimension values (referential integrity)  
✅ Date table covers full range of posting dates  
✅ Measures calculate correctly with and without filters  
✅ Slicers propagate filters as expected  

---

## Troubleshooting Common Issues

**Issue:** Salary totals seem inflated  
**Cause:** Jobs repeated per skill (denormalized)  
**Fix:** Use bridge table, calculate DISTINCTCOUNT(JobID)

**Issue:** Skill filter doesn't affect job count  
**Cause:** Relationship direction wrong  
**Fix:** Ensure bridge → fact relationship active

**Issue:** Date slicer doesn't work  
**Cause:** Date relationship not established  
**Fix:** Create relationship between DimDate[Date] and FactJobs[PostedDate]

---

*This data model supports all dashboard requirements while maintaining analytical integrity and query performance.*