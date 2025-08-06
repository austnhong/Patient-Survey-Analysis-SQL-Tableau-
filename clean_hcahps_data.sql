
-- Step 1: Create hospital_beds table
CREATE TABLE hospital_beds (
    provider_ccn TEXT,
    hospital_name TEXT,
    fiscal_year_begin_date TEXT,
    fiscal_year_end_date TEXT,
    number_of_beds INTEGER
);

-- Step 2: Create hcahps_data table
CREATE TABLE hcahps_data (
    facility_id TEXT,
    facility_name TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    county_or_parish TEXT,
    telephone_number TEXT,
    hcahps_measure_id TEXT,
    hcahps_question TEXT,
    hcahps_answer_description TEXT,
    hcahps_answer_percent INTEGER,
    num_completed_surveys INTEGER,
    survey_response_rate_percent INTEGER,
    start_date TEXT,
    end_date TEXT
);

-- Step 3: Cleaned HCAHPS data
CREATE TABLE hcahps_cleaned AS
SELECT 
    substr('000000' || facility_id, -6, 6) AS hcahps_provider_ccn,
    start_date AS start_date_converted,
    end_date AS end_date_converted,
    *
FROM hcahps_data;

-- Step 4: Cleaned hospital_beds data (no ROW_NUMBER so use GROUP BY)
CREATE TABLE hospital_beds_cleaned AS
SELECT 
    substr('000000' || provider_ccn, -6, 6) AS provider_ccn,
    hospital_name,
    fiscal_year_begin_date,
    fiscal_year_end_date,
    number_of_beds
FROM hospital_beds
GROUP BY provider_ccn;

-- Step 5: Final cleaned HCAHPS with hospital info
CREATE TABLE cleaned_hcahps_data AS
SELECT 
    hcahps.*,
    beds.hospital_name,
    beds.fiscal_year_begin_date,
    beds.fiscal_year_end_date,
    beds.number_of_beds
FROM hcahps_cleaned hcahps
LEFT JOIN hospital_beds_cleaned beds
    ON hcahps.hcahps_provider_ccn = beds.provider_ccn;
