# Airbnb Analytics Data Model

This document describes the logical data model for the Airbnb Analytics project.  
The schema follows a star schema design with dimensions, facts, and bridge tables.

---

## 📄 Dimensions  

### dim_listing  
- listing_sk  
- listing_id  
- host_sk  
- neighbourhood_sk  
- property_type_sk  
- room_type  
- accommodates  
- bathrooms  
- bedrooms  
- beds  
- instant_bookable  
- latitude  
- longitude  
- created_at  
- updated_at  

### dim_host  
- host_sk  
- host_id  
- host_name  
- host_since  
- host_about  
- host_response_time  
- host_response_rate  
- host_acceptance_rate  
- host_is_superhost  
- host_listings_count  
- host_total_listings_count  
- verified_by_gov_id  
- verified_by_email  
- verified_by_phone  
- verification_notes  
- created_at  
- updated_at  

### dim_neighbourhood  
- neighbourhood_sk  
- neighbourhood  
- neighbourhood_group  
- created_at  
- updated_at  

### dim_property_type  
- property_type_sk  
- canonical_label  
- category  
- is_unique  
- notes  
- created_at  
- updated_at  

### dim_date  
- date_sk  
- date_day  
- year  
- quarter  
- month  
- day  
- day_of_week  
- week_of_year  
- is_weekend  
- created_at  
- updated_at  

### dim_amenity  
- amenity_sk  
- canonical_label  
- normalized_name  
- category  
- subcategory  
- created_at  
- updated_at  

### dim_reviewer  
- reviewer_sk  
- reviewer_id  
- reviewer_name  
- created_at  
- updated_at  

---

## 📄 Facts  

### fct_reviews  
- review_sk  
- review_id  
- listing_sk  
- date_sk  
- reviewer_sk  
- comments  
- sentiment  
- created_at  
- updated_at  

### fct_listing_snapshot  
- listing_snapshot_sk  
- listing_sk  
- date_sk  
- price  
- has_availability  
- number_of_reviews  
- review_scores_rating  
- last_review  
- created_at  
- updated_at  

---

## 📄 Bridges  

### bridge_listing_amenity  
- listing_sk  
- amenity_sk  
- created_at  
- updated_at  
