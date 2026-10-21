
-- create DATABASE hospital_readmission;
-- USE hospital_readmission;
-- TRUNCATE TABLE diabetic_data_raw;




--  USE hospital_readmission;
-- select count(*) FROM ids_mapping_raw;
-- select * FROM ids_mapping_raw limit 10;
-- select count(*) FROM diabetic_data_raw;
-- UPDATE diabetic_data_raw set 
-- diag_1 = NULLIF(diag_1, "?");
-- select * FROM diabetic_data_raw limit 150;
-- SELECT patient_nbr, COUNT(*) AS encounter_count FROM diabetic_data_raw GROUP BY patient_nbr HAVING COUNT(*) > 9
-- ORDER BY encounter_count DESC;
-- SELECT ROUND(SUM(weight IS NULL)/COUNT(*) * 100,1) AS perctn_of_null FROM diabetic_data_raw;



-- CREATE TABLE diabetic_data_dedup AS SELECT t.*
-- FROM diabetic_data_raw as t 
-- INNER JOIN (SELECT 
-- patient_nbr,MIN(encounter_id) as first_encounter
-- FROM diabetic_data_raw
-- GROUP BY pateint_nbr) first_enc
-- ON t.patient_nbr = first_enc.patient_nbr
-- AND t.encounter_id = first_enc.first_encounter;


-- USE hospital_readmission;
-- CREATE TABLE diabetic_data_dedup AS SELECT j.* FROM diabetic_data_raw
-- AS j
-- INNER JOIN (SELECT patient_nbr, MIN(encounter_id) AS first_encounter FROM diabetic_data_raw
-- GROUP BY patient_nbr) first_enc 
-- ON j.patient_nbr = first_enc.patient_nbr
-- AND j.encounter_id = first_enc.first_encounter;
--  SELECT * FROM diabetic_data_raw;
-- SELECT COUNT(*) FROM diabetic_data_dedup;
-- SELECT * FROM ids_mapping_raw;
-- SELECT * FROM diabetic_data_dedup;
-- SELECT discharge_disposition_id, COUNT(*) AS encounter_count from diabetic_data_raw
-- GROUP BY discharge_disposition_id
-- ORDER BY encounter_count DESC;
-- SELECT * FROM ids_mapping_raw
-- WHERE description LIKE '%Expired%' OR DESCRIPTION LIKE '%Hospice%' OR DESCRIPTION LIKE '%Deceased%';

-- DELETE FROM diabetic_data_dedup WHERE discharge_disposition_id IN (11, 13, 14, 19, 20, 21, 26);


-- CREATE TABLE discharge_disposition_map (
-- discharge_disposition_id INT,
-- description VARCHAR(150)
-- );
-- CREATE TABLE admission_source_map (
--  admission_souce_id INT,
-- description VARCHAR(150)
-- );


-- INSERT INTO discharge_disposition_map (discharge_disposition_id, description) VALUES
-- (1,'Discharged to home'),
-- (2,'Discharged/transferred to another short term hospital'),
-- (3, 'Discharged/transferred to SNF'),
-- (4, 'Discharged/transferred to ICF'),
-- (5,'Discharged/transferred to another type of inpatient care institution'),
-- (6, 'Discharged/transferred to home with home health service'),
-- (7, 'Left AMA'),
-- (8, 'Discharged/transferred to home under care of Home IV provider'),
-- (9, 'Admitted as an inpatient to this hospital'),
-- (10, 'Neonate discharged to another hospital for neonatal aftercare'),
-- (11, 'Expired'),
-- (12, 'Still patient or expected to return for outpatient services'),
-- (13, 'Hospice / home'),
-- (14, 'Hospice / medical facility'),
-- (15, 'Discharged/transferred within this institution to Medicare approved swing bed'),
-- (16, 'Discharged/transferred/referred another institution for outpatient services'),
-- (17, 'Discharged/transferred/referred to this institution for outpatient services'),
-- (18, 'NULL'),
-- (19,'Expired at home. Medicaid only, hospice.'),
-- (20, 'Expired in a medical facility. Medicaid only, hospice.'),
-- (21, 'Expired, place unknown. Medicaid only, hospice.'),
-- (22, 'Discharged/transferred to another rehab fac including rehab units of a hospital.'),
-- (23, 'Discharged/transferred to a long term care hospital.'),
-- (24, 'Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare.'),
-- (25, 'Not Mapped'),
-- (26, 'Unknown/Invalid'),
-- (27, 'Discharged/transferred to a federal health care facility.'),
-- (28, 'Discharged/transferred/referred to a psychiatric hospital of psychiatric distinct part unit of a hospital'),
-- (29, 'Discharged/transferred to a Critical Access Hospital (CAH).'),
-- (30, 'Discharged/transferred to another Type of Health Care Institution not Defined Elsewhere');

-- INSERT INTO admission_source_map (admission_souce_id, description) VALUES
-- (1,	 'Physician Referral'),
-- (2,	'Clinic Referral'),
-- (3,	'HMO Referral'),
-- (4,	'Transfer from a hospital'),
-- (5, 'Transfer from a Skilled Nursing Facility (SNF)'),
-- (6,	 'Transfer from another health care facility'),
-- (7,	 'Emergency Room'),
-- (8,	 'Court/Law Enforcement'),
-- (9,	 'Not Available'),
-- (10,	 'Transfer from critial access hospital'),
-- (11,'Normal Delivery'),
-- (12,'Premature Delivery'),
-- (13,	 'Sick Baby'),
-- (14,	 'Extramural Birth'),
-- (15,	'Not Available'),
-- (17,	'NULL'),
-- (18,	 'Transfer From Another Home Health Agency'),
-- (19,	'Readmission to Same Home Health Agency'),
-- (20,	 'Not Mapped');
-- SELECT * FROM admission_source_map;
-- SELECT * FROM discharge_disposition_map;


-- ALTER TABLE diabetic_data_dedup ADD COLUMN age_midpoint INT;
-- UPDATE diabetic_data_dedup SET age_midpoint = CASE
-- WHEN age = '[0-10)' THEN 5
-- WHEN age = '[10-20)' THEN 15
-- WHEN age = '[20-30)' THEN 25
-- WHEN age = '[30-40)' THEN 35
-- WHEN age = '[40-50)' THEN 45
-- WHEN age = '[50-60)' THEN 55
-- WHEN age = '[60-70)' THEN 65
-- WHEN age = '[70-80)' THEN 75
-- WHEN age = '[80-90)' THEN 85
-- WHEN age = '[90-100)' THEN 95
-- END;


-- SELECT readmitted, 
-- COUNT(*) AS encounter_count,
-- (COUNT(*) /(SELECT COUNT(*) FROM diabetic_data_dedup)*100) AS percnt_of_total
--  FROM diabetic_data_dedup
-- GROUP BY readmitted 
-- ORDER BY encounter_count DESC;



-- SELECT age, age_midpoint,
-- COUNT(*) as total_encounters,
-- SUM(readmitted = '<30') AS readmitted_under_30_days,
-- (SUM(readmitted = '<30')/(SELECT COUNT(*) FROM diabetic_data_dedup)*100) AS percnt_of_readmit
-- FROM diabetic_data_dedup
-- GROUP BY age, age_midpoint
-- ORDER BY total_encounters DESC;


USE hospital_readmission;
SELECT * FROM diabetic_data_dedup;
SELECT * FROM admission_source_map;
SELECT * FROM ids_mapping_raw;

-- SELECT m.description AS admission_type,
-- COUNT(*) as total_encounters,
-- ROUND(SUM(d.readmitted = '<30') / COUNT(*) * 100 ,1) as readmission_rate_pct
-- FROM diabetic_data_dedup AS d
-- JOIN ids_mapping_raw AS m ON d.admission_type_id = m.admission_type_id
-- GROUP BY m.description 
-- ORDER BY admission_rate_pct DESC;




-- SELECT description AS description_type,
-- COUNT(*) AS encounter_count,
-- SUM( readmitted = '<30') AS total_readmission_under_30_days,
-- (SUM( readmitted = '<30')/ COUNT(*))*100 AS readmission_rate_prcnt
-- FROM diabetic_data_dedup INNER JOIN ids_mapping_raw ON diabetic_data_dedup.admission_type_id =ids_mapping_raw.admission_type_id
-- GROUP BY description
-- ORDER BY total_readmission_under_30_days desc;

WITH patient_risk_base AS (
SELECT encounter_id, patient_nbr, age_midpoint, time_in_hospital, num_lab_procedures, num_medications, number_diagnoses, number_inpatient, number_emergency,
number_outpatient, diag_1, readmitted,
  CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS is_readmitted_30 FROM diabetic_data_dedup)
SELECT * FROM patient_risk_base LIMIT 100;

WITH patient_risk_base AS (
SELECT encounter_id, age_midpoint, num_medications, readmitted,
CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS is_readmitted_30
FROM diabetic_data_dedup)
SELECT encounter_id, 
age_midpoint,
num_medications,
RANK() OVER ( PARTITION BY age_midpoint ORDER BY num_medications DESC) AS med_rank_age_grp
FROM patient_risk_base ORDER BY age_midpoint, med_rank_age_grp
LIMIT 700;

WITH patient_risk_base AS (
SELECT encounter_id, number_inpatient, readmitted,
CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS is_readmitted_30
 FROM diabetic_data_dedup)
 SELECT encounter_id, number_inpatient, readmitted,
 NTILE(4) OVER(ORDER BY number_inpatient desc) AS risk_quartile
 FROM patient_risk_base;


SELECT 
encounter_id,
num_medications,
CASE 
WHEN num_medications <= 10 THEN 'Low'
WHEN num_medications BETWEEN 11 AND 20 THEN 'Medium'
ELSE 'High' END AS medical_burden_tier,
CASE 
WHEN number_diagnoses <=5 THEN 'LOW COMPLEXCITY'
WHEN number_diagnoses BETWEEN 6 AND 9 THEN 'MODERATE COMPLEXCITY'
ELSE 'HIGH COMPLEXCITY' END AS diagnosis_complex_tier
FROM diabetic_data_dedup;


WITH diag_categorized AS(
SELECT encounter_id, readmitted,
CASE WHEN diag_1 LIKE'250%' THEN'Diabetes'
WHEN CAST(LEFT(diag_1,3) AS UNSIGNED) BETWEEN 390 AND 459 THEN 'Circulatory'
WHEN CAST(LEFT(diag_1,3) AS UNSIGNED) BETWEEN 460 AND 519 THEN 'Respiratory'
WHEN CAST(LEFT(diag_1,3) AS UNSIGNED) BETWEEN 520 AND 579 THEN 'Digestive'
WHEN CAST(LEFT(diag_1,3) AS UNSIGNED) BETWEEN 580 AND 629 THEN 'Genitourinary'
WHEN CAST(LEFT(diag_1,3) AS UNSIGNED) BETWEEN 800 AND 999 THEN 'Injury' ELSE 'Other'
END AS diagnosis_category,
CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS is_readmitted_30 FROM diabetic_data_dedup WHERE diag_1 IS NOT NULL)
SELECT diagnosis_category, COUNT(*) AS total_encounters, ROUND(AVG(is_readmitted_30) * 100, 1) AS readmission_rate_pct FROM diag_categorized
GROUP BY diagnosis_category HAVING AVG (is_readmitted_30) > ( SELECT AVG(is_readmitted_30) FROM diag_categorized
)ORDER BY readmission_rate_pct DESC; 

SELECT 
`change`, COUNT(*) ,
(SUM(readmitted = '<30') / COUNT(*)) * 100 AS readmission_rate_pct
FROM diabetic_data_dedup GROUP BY `change` ORDER BY readmission_rate_pct DESC;

SELECT description AS discharge_type,
COUNT(*),
ROUND((SUM(readmitted = '<30') / COUNT(*)) * 100,1) AS readmission_rate_pct
FROM diabetic_data_dedup JOIN discharge_disposition_map ON 
diabetic_data_dedup.discharge_disposition_id = discharge_disposition_map.discharge_disposition_id
GROUP BY discharge_type HAVING COUNT(*) > 1000 ORDER BY COUNT(*) DESC;


SELECT 
A1Cresult,
COUNT(*),
ROUND((SUM(readmitted = '<30') / COUNT(*)) * 100,1) AS readmission_rate_pct
FROM diabetic_data_dedup GROUP BY A1Cresult;



