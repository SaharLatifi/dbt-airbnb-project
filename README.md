
# dbt-airbnb-analytics

![dbt](https://img.shields.io/badge/dbt-analytics--engineering-orange?logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-cloud--data--warehouse-blue?logo=snowflake&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-dashboard-yellow?logo=powerbi&logoColor=white)
![GitHub](https://img.shields.io/badge/version-control-black?logo=github)

End-to-end Airbnb analytics project using **dbt** for data transformation and a dashboard to visualize key metrics.  

## 📌 Project Status
- ✅ Data exploration started  
- 🔄 Designing data model (staging + star schema)  
- ⏳ Building transformations in dbt  
- ⏳ Defining business metrics  
- ⏳ Creating dashboard for Airbnb analytics
  
📌 *I will keep updating this README as the project moves forward.* 
---

## 📑 Table of Contents
1. [Public Dashboard](#-public-dashboard)  
2. [Architecture](#-architecture)  
3. [Data Model](#-data-model)  
4. [ETL Flow](#-etl-flow)  
5. [Major Metrics](#-major-metrics)  
6. [Data Quality Checks](#-data-quality-checks)  
7. [Dashboard](#-dashboard)  
8. [Next Steps](#-next-steps)  

---

## 📊 Public Dashboard
🔗 [View the dashboard here](<ADD_LINK>)  

👉 *[Insert a screenshot of the dashboard]*  
![Dashboard Preview](<ADD_IMAGE_PATH>)  

---

## 🏗️ Architecture
This project follows a modern data stack pipeline:  
![alt text](image-3.png)
 
Data is sourced from publicly available Airbnb CSV files containing listings and reviews. These files are ingested into a Snowflake data warehouse where dbt-fusion orchestrates transformations to clean the raw data, build staging layers, and create fact and dimension tables in marts. The transformed data is then used to power an interactive dashboard built in Power BI, providing insights into key metrics such as pricing, occupancy, host performance, and guest reviews.

---

## 📐 Data Model
The project uses a **star schema** design:  
## 📄 Tables

### Dimensions
- dim_listing  
- dim_host  
- dim_neighbourhood  
- dim_property_type  
- dim_date  
- dim_amenity  
- dim_reviewer  

### Facts
- fct_reviews  
- fct_listing_snapshot  

### Bridges
- bridge_listing_amenity 

![alt text]![alt text](image-4.png)
 

---

## 🔄 ETL Flow
The transformation pipeline includes:  
1. **Raw Layer** → Load Airbnb CSVs into Snowflake  
2. **Staging Layer** → Clean and standardize source tables (`stg_listings`, `stg_reviews`)  
3. **Intermediate Layer** → Join and enrich datasets (host details, review scores)  
4. **Marts Layer** → Facts and dimensions ready for analytics  

👉 *[Insert your ETL flow diagram]*  
![ETL Flow](<ADD_IMAGE_PATH>)  

---

## 📊 Major Metrics

Key business metrics tracked in this project:

### 🏠 Listings & Supply
- **Active Listings** → count of distinct `listing_id` where `has_availability = true`  
- **Superhost %** → (count of listings with `host_is_superhost = true`) ÷ total listings × 100  
- **Listings by Property Type** → count of listings grouped by `property_type`  

### 💰 Pricing
- **Median Price per Night** → median(`price`) across listings  
- **Average Price by Neighbourhood** → avg(`price`) grouped by `neighbourhood`  

### ⭐ Reviews & Quality
- **Total Reviews** → sum(`number_of_reviews`)  
- **Average Review Score** → avg(`review_scores_rating`)  
- **Recent Reviews Trend** → count of reviews in `fct_reviews` by `date`  
- **% Positive Reviews** → (count of reviews with `sentiment = 'Positive'`) ÷ total reviews × 100  

### 👩‍💼 Host Performance
- **Average Host Response Rate** → avg(`host_response_rate`)  
- **Average Host Acceptance Rate** → avg(`host_acceptance_rate`)  
- **Listings per Host** → avg(`host_listings_count`)  
- **Instant Bookable %** → (count of `instant_bookable = true`) ÷ total listings × 100  

👉 *[Add a chart or metric cards screenshot]*  
![Metrics Example](<ADD_IMAGE_PATH>)  

 
👉 *[Add a chart or metric cards screenshot]*  
![Metrics Example](<ADD_IMAGE_PATH>)  

---

## ✅ Data Quality Checks
Implemented using dbt tests + dbt-utils:  
- **Uniqueness**: `id`, `host_id` in dimension tables  
- **Not Null**: keys and required fields (price, room_type, review scores)  
- **Accepted Values**: room types, property types, host verification methods  
- **Custom Tests**: `price >= 0`, occupancy rate within valid range  

👉 *[Add a dbt test results screenshot]*  
![Data Quality Checks](<ADD_IMAGE_PATH>)  

---

## 📊 Dashboard
flowchart TD

    A[Dashboard: Airbnb Analytics] --> B[Page 1: Overview]
    A --> C[Page 2: Map & Supply]
    A --> D[Page 3: Pricing]
    A --> E[Page 4: Reviews & Sentiment]
    A --> F[Page 5: Host Performance]

    B --> B1[KPIs: Active Listings, Median Price, Avg Rating, Superhost %, Total Reviews, % Positive Sentiment]
    B --> B2[Filters: Neighbourhood, Property Type, Room Type, Superhost, Availability]
    B --> B3[Charts: Listings by Property Type, Price Trend, Rating by Neighbourhood]

    C --> C1[KPI: Active Listings]
    C --> C2[Map: Listings by Lat/Long, Colored by Rating Band]
    C --> C3[Chart: Listings by Room Type]
    C --> C4[Table: Listing Directory]

    D --> D1[KPIs: Median Price, Avg Price, Price IQR]
    D --> D2[Chart: Price Trend Over Time]
    D --> D3[Chart: Price Distribution by Neighbourhood]
    D --> D4[Chart: Median Price by Property Type]

    E --> E1[KPIs: Total Reviews, Avg Rating, % Positive]
    E --> E2[Line: Review Counts Over Time]
    E --> E3[Stacked Bar: Sentiment by Neighbourhood]
    E --> E4[Table: Recent Reviews with Sentiment]

    F --> F1[KPIs: Avg Response Rate, Avg Acceptance Rate, Superhost %]
    F --> F2[Chart: Listings per Host (Top N)]
    F --> F3[Chart: Superhost % by Neighbourhood]
    F --> F4[Table: Host Directory]

The dashboard provides:  
- Listing distribution by room type, price, and neighborhood  
- Host performance (Superhost %, acceptance rate, response time)  
- Occupancy and revenue trends  
- Review score breakdowns  

👉 *[Insert final dashboard screenshots]*  
![Dashboard Screenshot 1](<ADD_IMAGE_PATH>)  
![Dashboard Screenshot 2](<ADD_IMAGE_PATH>)  

---

## 🚀 Next Steps
- Automate with CI/CD (GitHub Actions)  
- Add incremental models for performance  
- Expand metrics with time-based trends  

---
