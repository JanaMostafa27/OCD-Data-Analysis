USE ABZCompany

--Count of patients by Gender
SELECT Gender, COUNT (*) AS
patient_count
FROM ocd_patient_dataset
GROUP BY Gender

--Severity of ocd symptoms by age 
SELECT 
    CASE
       WHEN age < 20 THEN 'Under 20'
	   WHEN age BETWEEN 20 AND 29 
THEN '20-29'
	   WHEN age BETWEEN 30 AND 39
THEN '30-39'
	   WHEN age BETWEEN 40 AND 49 
THEN '40-49'
	   ELSE '50 and above'
	END AS age_group,
	AVG(Y_BOCS_Score_Obsessions) AS 
average_ybocs_score 
FROM ocd_patient_dataset
GROUP BY CASE
       WHEN age < 20 THEN 'Under 20'
	   WHEN age BETWEEN 20 AND 29 
THEN '20-29'
	   WHEN age BETWEEN 30 AND 39
THEN '30-39'
	   WHEN age BETWEEN 40 AND 49 
THEN '40-49'
	   ELSE '50 and above'
	END


--Family History	
SELECT Family_History_of_OCD, COUNT(*) AS 
family_history_count
FROM ocd_patient_dataset
GROUP BY Family_History_of_OCD


--Distribution of marital status
SELECT marital_status, COUNT (*) AS
count_marital_status
FROM ocd_patient_dataset
GROUP BY marital_status


--Patients with depression or anxiety
SELECT 
     COUNT(*) AS total_patients,
	 SUM(CASE  WHEN Depression_Diagnosis
= 1 THEN 1 ELSE 0 END) AS
patients_with_depression,
     SUM(CASE  WHEN Anxiety_Diagnosis
= 1 THEN 1 ELSE 0 END) AS
patients_with_anxiety
FROM ocd_patient_dataset


--Patients with previous diagnosis
SELECT Previous_Diagnoses, COUNT(*) AS
previous_diagnosis_count
FROM ocd_patient_dataset
GROUP BY Previous_Diagnoses
ORDER BY previous_diagnosis_count desc


--Education level and Obsession type with score of obsession
SELECT 
    COUNT(*) AS NumberOfPatients,
    Education_Level,
    Obsession_Type,
    AVG(Y_BOCS_Score_Obsessions) AS Avg_Y_BOCS_Score_Obsessions
FROM ocd_patient_dataset
GROUP BY Education_Level, Obsession_Type
ORDER BY Education_Level, Obsession_Type;


--Most Common Obsession Type Based On Age
WITH ObsessionCounts AS (
    SELECT Obsession_Type,
        CASE
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+' 
        END AS AgeRange,COUNT(*) AS numberOfPatient
    FROM ocd_patient_dataset
    GROUP BY Obsession_Type,
        CASE
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+' 
        END
)
SELECT 
    AgeRange,
    Obsession_Type,
    numberOfPatient
FROM (
    SELECT 
        AgeRange,
        Obsession_Type,
        numberOfPatient,
        ROW_NUMBER() OVER (PARTITION BY AgeRange ORDER BY numberOfPatient DESC) AS RowNum
    FROM ObsessionCounts
) RankedObsessions
WHERE RowNum = 1
ORDER BY AgeRange; 


--Most Common Compulsion Type Based On Age
WITH CompulsionCounts AS(
    SELECT 
        Compulsion_Type,
        CASE
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+' 
        END AS AgeRange,
        COUNT(*) AS numberOfPatient
    FROM ocd_patient_dataset
    GROUP BY Compulsion_Type,
        CASE
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+' 
        END
)
SELECT 
    AgeRange,
    Compulsion_Type,
    numberOfPatient
FROM (
    SELECT 
        AgeRange,
        Compulsion_Type,
        numberOfPatient,
        ROW_NUMBER() OVER (PARTITION BY AgeRange ORDER BY numberOfPatient DESC) AS RowNum
    FROM CompulsionCounts
) RankedCompulsions
WHERE RowNum = 1
ORDER BY AgeRange; 


--Y_BOCS(Obsession) Ranges -With Symptoms Duration
  SELECT 
    CASE 
        WHEN Y_BOCS_Score_Obsessions BETWEEN 0 AND 15 THEN 'Low'
        WHEN Y_BOCS_Score_Obsessions BETWEEN 16 AND 25 THEN 'Moderate'
        ELSE 'High'
    END AS ObsessionScoreRange,
    AVG(Duration_of_Symptoms_months) AS AvgDurationMonths,
    COUNT(*) AS NumberOfPatients
FROM ocd_patient_dataset
GROUP BY 
    CASE 
        WHEN Y_BOCS_Score_Obsessions BETWEEN 0 AND 15 THEN 'Low'
        WHEN Y_BOCS_Score_Obsessions BETWEEN 16 AND 25 THEN 'Moderate'
        ELSE 'High'
    END
ORDER BY ObsessionScoreRange;


--Y_BOCS(Compulsion) Ranges -With Symptoms Duration
  SELECT 
    CASE 
        WHEN Y_BOCS_Score_Compulsions BETWEEN 0 AND 15 THEN 'Low'
        WHEN Y_BOCS_Score_Compulsions BETWEEN 16 AND 25 THEN 'Moderate'
        ELSE 'High'
    END AS CompulsionScoreRange,
    AVG(Duration_of_Symptoms_months) AS AvgDurationMonths,
    COUNT(*) AS NumberOfPatients
FROM ocd_patient_dataset
GROUP BY 
    CASE 
        WHEN Y_BOCS_Score_Compulsions BETWEEN 0 AND 15 THEN 'Low'
        WHEN Y_BOCS_Score_Compulsions BETWEEN 16 AND 25 THEN 'Moderate'
        ELSE 'High'
    END
ORDER BY CompulsionScoreRange;


--Number Of Patients Based On Obsession And Anxiety
  SELECT Depression_Diagnosis, Anxiety_Diagnosis, COUNT(*) AS numberOfPatient
  FROM ocd_patient_dataset
  GROUP BY Depression_Diagnosis, Anxiety_Diagnosis;


--Medication Based On Duration Of Symptoms
  SELECT Medications, AVG(Duration_of_Symptoms_months) AS SymptomDuration 
  FROM ocd_patient_dataset 
  GROUP BY Medications;


--Medication Based On Age: 
 WITH MedicationCounts AS (
    SELECT 
        Medications, 
        CASE 
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+' 
        END AS AgeRange,
        COUNT(*) AS numberOfPatient
    FROM ocd_patient_dataset
    GROUP BY 
        Medications,
        CASE 
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '45+' 
        END
)
SELECT 
    AgeRange,
    Medications,
    numberOfPatient
FROM (
    SELECT 
        AgeRange,
        Medications,
        numberOfPatient,
        ROW_NUMBER() OVER (PARTITION BY AgeRange ORDER BY numberOfPatient DESC) AS RowNum
    FROM MedicationCounts
) RankedMedications
WHERE RowNum = 1
ORDER BY AgeRange;






