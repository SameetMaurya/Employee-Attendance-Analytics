import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("../data/employee_attendance.csv")
df["Date"] = pd.to_datetime(df["Date"])

print("Rows:", len(df))
print("Employees:", df["Employee_ID"].nunique())
print(f"Attendance rate: {df['Status'].eq('Present').mean()*100:.2f}%")

department = df.groupby("Department").agg(
    Employees=("Employee_ID","nunique"),
    Attendance_Rate=("Status", lambda x: x.eq("Present").mean()*100),
    Absences=("Status", lambda x: x.eq("Absent").sum()),
    Avg_Work_Hours=("Work_Hours", lambda x: x[x>0].mean())
).round(2)

monthly = df.groupby("Month").agg(
    Attendance_Rate=("Status", lambda x: x.eq("Present").mean()*100),
    Absences=("Status", lambda x: x.eq("Absent").sum())
).round(2)

print("\nDepartment analysis:\n", department)
print("\nMonthly analysis:\n", monthly)

department.to_csv("../reports/department_analysis.csv")
monthly.to_csv("../reports/monthly_analysis.csv")

department["Attendance_Rate"].sort_values().plot(kind="barh", figsize=(9,5), title="Attendance Rate by Department")
plt.xlabel("Attendance Rate (%)"); plt.tight_layout()
plt.savefig("../screenshots/department_attendance.png", dpi=180); plt.close()

monthly["Attendance_Rate"].plot(marker="o", figsize=(9,5), title="Monthly Attendance Rate")
plt.ylabel("Attendance Rate (%)"); plt.ylim(0,100); plt.grid(alpha=.25); plt.tight_layout()
plt.savefig("../screenshots/monthly_attendance.png", dpi=180); plt.close()
