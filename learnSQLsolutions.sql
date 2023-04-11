-- EASY QUESTION SOLUTIONS

-- Show first name, last name, and gender of patients who's gender is 'M'

SELECT first_name, last_name, gender FROM patients
WHERE gender = 'M'

-- Show first name and last name of patients who does not have allergies. (null)

SELECT first_name, last_name FROM patients
WHERE allergies is Null

-- Show first name of patients that start with the letter 'C'

SELECT first_name FROM patients
WHERE first_name LIKE 'C%'

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT first_name, last_name FROM patients
WHERE weight >= 100 AND weight <= 120

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

update patients SET allergies = 'NKA'
WHERE allergies is NULL

-- Show first name and last name concatinated into one column to show their full name.

SELECT concat(first_name, ' ', last_name) AS full_name 
FROM patients

-- Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'

SELECT first_name, last_name, province_name 
FROM patients
JOIN province_names 
ON patients.province_id = province_names.province_id

-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000

SELECT * FROM patients
WHERE patient_id IN (1,45,534,879,1000)

-- Show how many patients have a birth_date with 2010 as the birth year.

SELECT COUNT(*) FROM patients
WHERE YEAR(birth_date) = 2010

-- Show the first_name, last_name, and height of the patient with the greatest height.

SELECT first_name, last_name, MAX(height) FROM patients
HAVING Max(height)

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT * FROM admissions
WHERE admission_date = discharge_date

-- Show the patient id and the total number of admissions for patient_id 579.

SELECT patient_id, count(patient_id) FROM admissions
WHERE patient_id = 579

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

SELECT DISTINCT city FROM patients
WHERE province_id ='NS'

-- Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70

SELECT first_name, last_name, birth_date FROM patients
WHERE height > 160 AND weight > 70

-- Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null

SELECT first_name, last_name, allergies FROM patients
WHERE city = 'Hamilton' AND allergies not NULL

-- Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.

SELECT distinct city FROM patients
WHERE city LIKE 'A%' 
OR city LIKE 'E%'
OR city LIKE 'I%' 
Or city LIke 'O%' 
or city like 'U%'
order by city

-- MEDIUM QUESTION SOLUTIONS

-- Show unique birth years from patients and order them by ascending.

SELECT distinct YEAR(birth_date)
FROM patients
ORDER BY YEAR(birth_date)

-- Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.

SELECT first_name
FROM patients
group by first_name
HAVING COUNT(first_name) = 1

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 'S____%s'

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.

SELECT patients.patient_id, first_name, last_name
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id
WHERE diagnosis = 'Dementia'

-- Display every patient's first_name. Order the list by the length of each name and then by alphabetically

SELECT first_name
FROM patients
order by len(first_name), first_name

-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.

SELECT COUNT(case When gender = 'M' then 1 end),
count(case when gender = 'F' then 1 end)
FROM patients

-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.

SELECT 
first_name,
last_name,
allergies
FROM patients 
Where allergies = 'Penicillin' or allergies = 'Morphine'
order by allergies, first_name, last_name

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT 
patient_id,
diagnosis
FROM admissions 
group by diagnosis, patient_id
HAVING COUNT(patient_id) > 1

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.

SELECT 
count(patient_id), 
city
FROM patients 
group by city
order by COUNT(patient_id) DESC, city

-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"

SELECT 
first_name,
last_name,
(SELECT case when patient_id > 0 then 'Patient' end) as role
FROM patients
UNION ALL
SELECT 
first_name,
last_name,
(SELECT case when doctor_id > 0 then 'Doctor' end) as role
FROM doctors

-- Show all allergies ordered by popularity. Remove NULL values from query.

SELECT 
count(allergies),
allergies
FROM patients
WHERE allergies not NULL
group by allergies 
order by count(allergies) DESC

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

SELECT 
first_name,
last_name,
birth_date
FROM patients
WHERE year(birth_date) between 1970 and 1979
order by birth_date

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
-- EX: SMITH,jane

SELECT 
concat(upper(last_name), ',', lower(first_name))
from patients
order by first_name desc

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT 
province_id,
sum(height)
from patients
group by province_id
having sum(height) > 7000

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT 
max(weight) - min(weight)
from patients
where last_name = 'Maroni'

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

SELECT 
COUNT(day(admission_date)),
day(admission_date)
from admissions
group by day(admission_date)
order by count(day(admission_date)) DESC

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

SELECT 
COUNT(day(admission_date)),
day(admission_date)
from admissions
group by day(admission_date)
order by count(day(admission_date)) DESC

-- Show all columns for patient_id 542's most recent admission_date.

SELECT *
FROM admissions
WHERE patient_id = 542 
order by admission_date desc
limit 1

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT 
patient_id,
attending_doctor_id,
diagnosis
from admissions
where patient_id % 2 != 0 and attending_doctor_id in (1, 5, 19) 
or attending_doctor_id like '%2%' and len(patient_id) = 3

-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.

SELECT 
first_name, 
last_name,
count(attending_doctor_id)
from doctors
join admissions on admissions.attending_doctor_id = doctors.doctor_id
group by doctor_id

-- For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT 
doctor_id,
concat(first_name, ' ', last_name),
min(admission_date),
max(admission_date)
from doctors
join admissions on admissions.attending_doctor_id = doctors.doctor_id
group by doctor_id

-- Display the total amount of patients for each province. Order by descending.

SELECT 
COUNT(patient_id),
province_name
FROM patients
join province_names on patients.province_id = province_names.province_id
group by province_name
order by count(patient_id) desc

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

SELECT 
concat(patients.first_name, ' ', patients.last_name),
diagnosis,
concat(doctors.first_name, ' ', doctors.last_name)
FROM patients
join admissions on patients.patient_id = admissions.patient_id
Join doctors on admissions.attending_doctor_id = doctors.doctor_id

-- display the number of duplicate patients based on their first_name and last_name.

SELECT 
first_name,
last_name,
COUNT(concat(first_name, ' ', last_name)) as full_name 
from patients
group by first_name, last_name
having COUNT(concat(first_name, ' ', last_name)) > 1

-- Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date, gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.

SELECT 
	concat(first_name, ' ', last_name) as full_name,
    ROUND(height / 30.48, 1) as height,
    ROUND(weight * 2.205, 0) as height,
    birth_date,
    (SELECT case when gender = 'M' then 'Male' else 'Female' end)
    as gender 
from patients

-- HARD QUESTION SOLUTIONS

-- Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending.
-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT (weight / 10)*10 AS weight_group, count(weight)
FROM patients
group by weight_group 
order by weight_group DESC

-- Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. 
-- Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg. height is in units cm.

SELECT 
	patient_id,
    weight,
    height,
   	CASE
    	when (weight/power(height/100.00, 2)) >= 30 then 1 else 0 end as Obese
from patients

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
-- Check patients, admissions, and doctors tables for required information.

SELECT patients.patient_id, patients.first_name, patients.last_name, doctors.specialty 
FROM patients
join admissions on patients.patient_id = admissions.patient_id
join doctors on admissions.attending_doctor_id = doctors.doctor_id
where admissions.diagnosis = 'Epilepsy' and doctors.first_name = 'Lisa'

-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password. 
-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date

SELECT 
  distinct admissions.patient_id, 
  concat(patients.patient_id, len(last_name), year(birth_date))
FROM patients
join admissions on patients.patient_id = admissions.patient_id

-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance. 
-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

SELECT 
  case 
    when patient_id % 2 = 0 then 'Yes'
    else 'No'
  end as has_insurance,
  case
  	when patient_id % 2 = 0 then count(*) * 10
    else count(*) * 50
  end as total_cost
from admissions
group by has_insurance

-- Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

SELECT pr.province_name
FROM province_names pr
INNER JOIN patients pa
    ON pa.province_id = pr.province_id
GROUP BY pr.province_name
having 
	count(case when gender = 'M' then 1 end) > 
  count(case when gender = 'F' then 1 end)
  
-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'

SELECT * 
FROM patients
WHERE first_name like '__r%'
and gender = 'F'
and weight between 60 and 80
and patient_id % 2 != 0 
and city = 'Kingston'
and month(birth_date) in (2, 5, 12)


