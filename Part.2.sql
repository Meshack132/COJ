-- Add new fields if they do not already exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Home_Loan' AND COLUMN_NAME = 'Application_Status')
ALTER TABLE Home_Loan ADD Application_Status VARCHAR(50);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Home_Loan' AND COLUMN_NAME = 'Max_Instalment')
ALTER TABLE Home_Loan ADD Max_Instalment DECIMAL(10, 2);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Home_Loan' AND COLUMN_NAME = 'Percentage_Home_Loan')
ALTER TABLE Home_Loan ADD Percentage_Home_Loan DECIMAL(5, 2);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Home_Loan' AND COLUMN_NAME = 'Deposit_Required')
ALTER TABLE Home_Loan ADD Deposit_Required DECIMAL(10, 2);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Home_Loan' AND COLUMN_NAME = 'Monthly_Instalment')
ALTER TABLE Home_Loan ADD Monthly_Instalment DECIMAL(10, 2);

-- Apply business rules
UPDATE Home_Loan
SET 
    Application_Status = 
        CASE
            WHEN (Salary * 0.30 >= Monthly_Instalment AND Credit_Score >= 800) THEN 'Approved'
            WHEN (Credit_Score BETWEEN 750 AND 799) THEN 'Pending Approval'
            WHEN (Credit_Score BETWEEN 700 AND 749) THEN 'Pending Approval'
            WHEN (Credit_Score BETWEEN 650 AND 699) THEN 'Pending Approval'
            ELSE 'Rejected'
        END,
    Max_Instalment = Salary * 0.30,
    Percentage_Home_Loan = 
        CASE
            WHEN Credit_Score >= 800 THEN 100
            WHEN Credit_Score BETWEEN 750 AND 799 THEN 97.5
            WHEN Credit_Score BETWEEN 700 AND 749 THEN 95
            WHEN Credit_Score BETWEEN 650 AND 699 THEN 90
            ELSE 0
        END,
    Deposit_Required = 
        CASE
            WHEN Percentage_Home_Loan < 100 THEN Listed_Price * (1 - Percentage_Home_Loan / 100)
            ELSE 0
        END,
    Monthly_Instalment = (Listed_Price - Deposit_Required) * 0.00785;