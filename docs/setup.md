# ⚙️ Databases and Schemas

This project uses separate Snowflake databases to organize data by layer. The current dbt target environment is `dev`.

| Layer       | Database Name    | Schema Name        | Purpose                                                                        |
| ----------- | ---------------- | ------------------ | ------------------------------------------------------------------------------ |
| **Raw**     | `airbnb_raw`     | `property`         | Stores raw property-related source data, including listings and neighbourhoods |
| **Raw**     | `airbnb_raw`     | `review`           | Stores raw review-related source data                                          |
| **Staging** | `airbnb_staging` | `airbnb_model`     | Stores cleaned and standardized dbt staging models                             |
| **Staging** | `airbnb_staging` | `airbnb_seed`      | Stores dbt seed data                                                           |
| **Staging** | `airbnb_staging` | `airbnb_snapshots` | Stores dbt snapshot tables used to track historical changes                    |
| **Mart**    | `airbnb_mart`    | `airbnb_model`     | Stores analytics-ready dimensional and fact models for reporting and analysis  |

