import csv
import sqlite3

# Connect to the SQLite database
conn = sqlite3.connect('sales.db')

# Create a cursor object to execute SQL queries
cursor = conn.cursor()

# Execute the SQL queries
cursor.execute('SELECT * FROM sales')
rows1 = cursor.fetchall()

cursor.execute('SELECT strftime("%Y-%m", order_date) AS month, SUM(quantity * price) AS revenue FROM sales GROUP BY month ORDER BY month')
rows2 = cursor.fetchall()

cursor.execute('SELECT product_id, COUNT(*) AS sales_count FROM sales GROUP BY product_id ORDER BY sales_count DESC LIMIT 5')
rows3 = cursor.fetchall()

cursor.execute('SELECT CASE WHEN customer_type = "New" THEN "New Customer" WHEN customer_type = "Returning" THEN "Returning Customer" ELSE "Unknown" END AS customer_type, COUNT(*) AS sales_count FROM sales GROUP BY customer_type')
rows4 = cursor.fetchall()

cursor.execute('SELECT strftime("%Y-%m", order_date) AS month, SUM(CASE WHEN strftime("%Y", order_date) = "2022" THEN quantity * price END) AS revenue_2022, SUM(CASE WHEN strftime("%Y", order_date) = "2023" THEN quantity * price END) AS revenue_2023 FROM sales WHERE strftime("%Y", order_date) IN ("2022", "2023") GROUP BY month ORDER BY month')
rows5 = cursor.fetchall()

# Combine the results from all queries
all_rows = rows1 + rows2 + rows3 + rows4 + rows5

# Specify the output file path
output_file = 'sales.csv'

# Write the combined results to a CSV file
with open(output_file, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    for row in all_rows:
        csvwriter.writerow(row)
        csvwriter.writerow([])  # Add an empty row after each data row

# Close the database connection
conn.close()
