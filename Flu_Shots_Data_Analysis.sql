/*
Objectives 
Come up with Flu shots dashboard for 2022 that does the following

1). Total % of patterns getting Flu shots arranged by
	a). Age
	b). Race
	c). County (On a Map)
	d). Overall
2). Running Total of Flu shots over the cours of 2022
3). Total number of Flu shots given in 2022
4). A list of patterns that show whether or not they recieved the Flu shots

Requirements:

Patients must have been "Active at our hospital"
*/

WITH active_patients AS
(
	SELECT DISTINCT patient
	FROM encounters AS encounters
	JOIN patients AS patients
		ON encounters.patient = patients.id
	WHERE start BETWEEN '2020-01-01 00:00' AND '2022-12-31 23:59'
		AND patients.deathdate is null
		AND EXTRACT(month FROM age ('2022-12-31', patients.birthdate)) >= 6
),

flu_shot_2022 AS
(
SELECT patient, MIN(date) AS earliest_flu_shot_2022
FROM immunizations
WHERE code = '5302'
	AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
GROUP BY patient
)

SELECT 	patients.birthdate, 
		patients.race, 
		patients.county,
		patients.id,
		patients.first,
		patients.last,
		flu.earliest_flu_shot_2022,
		flu.patient,
		CASE WHEN flu.patient IS NOT null THEN 1
		ELSE 0
		END AS flu_shot_2022
FROM patients as patients
LEFT JOIN flu_shot_2022 as flu
	ON patients.id = flu.patient
WHERE 1=1
	AND patients.id IN (SELECT patient FROM active_patients)
	
	