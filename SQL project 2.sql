Create database sql_project_2;

use sql_project_2;

drop table doctor;

Create table doctor
(
Doctor_ID double,
Doctor_Name Varchar(30),
Specialty varchar(20),
Phone_Number Varchar(35),
Years_Of_Experience int,
Hospital_Affiliation varchar(50),
Hospital_Clinic Varchar(50),
Email varchar(100)
);

select * from doctor;

set global local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Doctor.csv'
INTO TABLE doctor
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * from doctor;

create table lab_result
(
Lab_Result_ID int,
Visit_ID int,
Test_Name varchar(30),
Test_Date date,
Units varchar(20),
Comments varchar(50),
Test_Result varchar(15),
Reference_Range varchar(20)
);

select * from lab_result;

set global local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Lab Result.csv'
INTO TABLE lab_result
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * from lab_result;

drop table patient;

create table patient
(
Patient_ID double,
Gender varchar(10),
Date_of_Birth date,
Age int,
Phone_Number varchar(25),
Address varchar(75),
Blood_Type varchar(10),
Emergency_Contact varchar(25),
Insurance_Provider varchar(40),
State varchar(20),
City varchar(20),
Country varchar(15),
Policy_Number varchar(15),
Medical_History varchar(10),
Race varchar(10),
Ethnicity varchar(20),
Marital_Status varchar(10),
First_Name varchar(15),
LastName varchar(30),
Emergency_Contact_1 varchar(50),
Chronic_Conditions varchar(20),
Allergies varchar(20),
Contact_Number varchar(50)
);

select * from patient;

set global local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Patient.csv'
INTO TABLE patient
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * from Patient;

create table treatment
(
Treatment_ID int,
Visit_ID int,
Medication_Prescribed varchar(25),
Dosage varchar(15),
Instructions varchar(35),
Treatment_Cost double, 
Treatment_Type varchar(25),
Treatment_Name varchar(25),
Status varchar(20),
Cost double,
Outcome varchar(20),
Treatment_Description varchar(30)
);

select * from treatment;

set global local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Treatment.csv'
INTO TABLE treatment
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * from Treatment;

create table visit
(
Visit_ID int,
Patient_ID double,
Doctor_ID double,
Visit_Date date,
Diagnosis varchar(20),
Follow_Up_Required varchar(10),
Visit_Type varchar(25),
Visit_Status varchar(15),
Diagnosis_Code varchar(10),
Reason_for_Visit varchar(25),
Prescribed_Medications varchar(20)
);

select * from visit;

set global local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Visit.csv'
INTO TABLE visit
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * from Treatment;

-- Total patients
select count(patient_id) as Total_Patient
from patient;

-- Total Doctors
select count(doctor_id) as Total_Doctors
from doctor;

-- Total Visit
select count(visit_id) as Total_Visit
from visit;

-- Average Age of Patient
select round(avg(age),1) as Avg_Age_of_Pt
from patient;

-- Treatment Cost Per Visit
select round(avg(treatment_cost),2) as Treatment_Cost_Per_Visit
from treatment;

-- Total Lab test Conducted
select count(lab_result_id) as Total_Lab_Test_Conducted
from Lab_result;

-- Doctor Workload
select
round(
(Select count(patient_id) from patient)/
(select count(doctor_id) from doctor),2) as Doctors_Workload;

-- top 5 doctors with more patient
select d.doctor_name, count(p.patient_id) as patient_count
from doctor as d
join visit as v
on d.doctor_Id = v.doctor_id
join patient as p
on v.patient_id = p.patient_id
group by doctor_name
order by patient_count desc
limit 5;

-- percentage of abnormal result
SELECT 
concat(
round(
(SUM(CASE WHEN test_result = 'Abnormal' THEN 1 ELSE 0 END) * 100.0) 
/ COUNT(*),
2),
" %") AS Abnormal_percentage
FROM lab_result;

-- percentage of test results
SELECT 
test_result,
COUNT(*) AS total_count,
concat(Round((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM lab_result)), 2), " %") AS percentage
FROM lab_result
GROUP BY test_result;

-- Total Revenue
Select concat(Round((sum(treatment_cost)+sum(cost)) / 1000000 ,2), " M") as Total_Revenue
from treatment;

-- Lab Test count
Select ifnull(test_name, "Total") as test_name, Count(test_name) as count
from lab_result
group by test_name with rollup
order by count desc;

-- prescribed medication
select ifnull(prescribed_medications, "Total") as prescribed_medications, count(Prescribed_Medications) as count
from visit
group by prescribed_medications with rollup
order by count desc;