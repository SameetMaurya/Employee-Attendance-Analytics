-- Employee Attendance Analytics | MySQL 8+
CREATE DATABASE IF NOT EXISTS employee_attendance;
USE employee_attendance;

CREATE TABLE attendance (
 Date DATE, Employee_ID VARCHAR(10), Employee_Name VARCHAR(100),
 Department VARCHAR(50), Location VARCHAR(50), Shift VARCHAR(30),
 Status VARCHAR(20), Work_Hours DECIMAL(4,2), Month VARCHAR(7)
);

-- Import data/employee_attendance.csv into the table using your SQL client.

-- Overall attendance
SELECT ROUND(100.0*SUM(Status='Present')/COUNT(*),2) AS attendance_rate_pct FROM attendance;

-- Department performance
SELECT Department, COUNT(DISTINCT Employee_ID) Employees,
 SUM(Status='Present') Present_Records, SUM(Status='Absent') Absences,
 SUM(Status='Late') Late_Records,
 ROUND(100.0*SUM(Status='Present')/COUNT(*),2) Attendance_Rate_Pct
FROM attendance GROUP BY Department ORDER BY Attendance_Rate_Pct DESC;

-- Monthly trend
SELECT Month, ROUND(100.0*SUM(Status='Present')/COUNT(*),2) Attendance_Rate_Pct,
 SUM(Status='Absent') Absences
FROM attendance GROUP BY Month ORDER BY Month;

-- Top absence counts
SELECT Employee_ID,Employee_Name,Department,SUM(Status='Absent') Absences,
 SUM(Status='Late') Late_Days
FROM attendance GROUP BY Employee_ID,Employee_Name,Department
ORDER BY Absences DESC LIMIT 10;

-- Shift analysis
SELECT Shift, ROUND(100.0*SUM(Status='Present')/COUNT(*),2) Attendance_Rate_Pct,
 ROUND(AVG(NULLIF(Work_Hours,0)),2) Avg_Work_Hours
FROM attendance GROUP BY Shift;

-- Location analysis
SELECT Location, ROUND(100.0*SUM(Status='Present')/COUNT(*),2) Attendance_Rate_Pct,
 SUM(Status='Absent') Absences
FROM attendance GROUP BY Location ORDER BY Attendance_Rate_Pct DESC;
