import pandas as pd
from datetime import datetime, timedelta

# Create a date dataframe
start_date = datetime(2023, 1, 1)
end_date = datetime(2023, 12, 31)
date_range = pd.date_range(start=start_date, end=end_date, freq='D')

df_dates = pd.DataFrame({
    'date': date_range,
    'year': date_range.year,
    'month': date_range.month,
    'day': date_range.day,
    'day_of_week': date_range.day_name(),
    'week_of_year': date_range.isocalendar().week
})

# Copy the content into a date.csv file
df_dates.to_csv('date.csv', index=False)

print("Date CSV file created successfully!")
print(df_dates.head())
