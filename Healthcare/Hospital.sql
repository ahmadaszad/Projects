create database if not exists hospital;   # Hospital database created
Use hospital;

CREATE TABLE hospitlization_details (
    customer_id VARCHAR(10) PRIMARY KEY,
    year INT,
    month VARCHAR(3),
    date INT,
    children INT,
    charges DECIMAL(8,2),
    hospital_tier INT,
    city_tier INT,
    state_id VARCHAR(5)
);

CREATE TABLE medical_examination (
    customer_id VARCHAR(10) PRIMARY KEY,
    bmi DECIMAL(5,2),
    hba1c DECIMAL(4,2),
    heart_issues VARCHAR(3),
    any_transplants VARCHAR(3),
    cancer_history VARCHAR(3),
    num_major_surgeries VARCHAR(20),
    smoker VARCHAR(3)
);

CREATE TABLE names (
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50)
);

# importing data to all 3 tables from table data import 

select * from hospitlization_details;   # viewing hospitlizaation details
select * from medical_examination;      # viewing medical examination details
select * from names;                    # viewing paitent details

SELECT customer_id, COUNT(*) as count   # To view dublicate data in hospitlization_details table
FROM hospitlization_details
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) as count   # To view dublicate data medical_examination table
FROM medical_examination
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) as count   # To view dublicate data paitent name table
FROM names
GROUP BY customer_id
HAVING COUNT(*) > 1;

/* Retrieve information about people who are diabetic and have heart problems with their 
 average age, the average number of dependent children, average BMI, and average 
 hospitalization costs */
 
 SELECT AVG(YEAR(CURDATE()) - YEAR(CONCAT(hd.year, '-', hd.month, '-', hd.date))) AS avg_age,
       AVG(hd.children) AS avg_children,
       AVG(me.bmi) AS avg_bmi,
       AVG(hd.charges) AS avg_charges
FROM hospitlization_details hd
JOIN medical_examination me ON hd.`customer_id` = me.`customer_id`
WHERE me.`hba1c` > 6.5 AND me.`heart_issues` = 'Yes';

/* Find the average hospitalization cost for each hospital tier and each city level */

SELECT `hospital_tier`, `city_tier`, AVG(`charges`) AS avg_cost
FROM hospitlization_details
GROUP BY `hospital_tier`, `city_tier`;

/* Determine the number of people who have had major surgery with a history of cancer */

SELECT COUNT(*) AS num_people
FROM hospitlization_details hd
JOIN medical_examination me ON hd.`customer_id` = me.`customer_id`
WHERE me.`cancer_history` = 'Yes' AND me.`num_major_surgeries` > 0;

/* Determine the number of tier-1 hospitals in each state. */

SELECT `state_id`, COUNT(*) AS num_hospitals
FROM hospitlization_details
WHERE `hospital_tier` = 'tier - 1'
GROUP BY `state_id`;
