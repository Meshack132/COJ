-- Step 1: Create the Home_Loan Table
USE Originex;

CREATE TABLE Home_Loan (
    Buyers_ID INT PRIMARY KEY,
    Buyers_Name VARCHAR(255),
    Salary DECIMAL(10, 2),
    Credit_Score INT,
    Listed_Price DECIMAL(10, 2),
    Year_Built INT,
    Loan_Application_Status VARCHAR(50),
    Maximum_Home_Loan_Instalment DECIMAL(10, 2),
    Percentage_Home_Loan_Granted DECIMAL(5, 2),
    Deposit_Required DECIMAL(10, 2),
    Monthly_Instalment DECIMAL(10, 2)
);

-- Step 2: Insert Data into Home_Loan

INSERT INTO Home_Loan (Buyers_ID, Buyers_Name, Salary, Credit_Score, Listed_Price, Year_Built)
SELECT
    pb.Buyer_ID,
    pb.Name AS Buyers_Name,
    aff.Salary,
    aff.Credit_Score,
    lp.LISTED_PRICE AS Listed_Price,
    lp.YEAR_BUILT AS Year_Built
FROM
    Potential_Buyers pb
JOIN
    Listed_Properties lp ON pb.Buyer_ID = lp.Buyer_ID
JOIN
    Affordability aff ON pb.Buyer_ID = aff.Buyer_ID;

-- Step 3: Update Loan_Application_Status
UPDATE Home_Loan
SET Loan_Application_Status = 
    CASE
        WHEN (Salary * 0.30 >= Monthly_Instalment AND Credit_Score >= 800) THEN 'Approved'
        WHEN (Credit_Score >= 750) THEN 'Pending Approval'
        WHEN (Credit_Score >= 700) THEN 'Pending Approval'
        WHEN (Credit_Score >= 650) THEN 'Pending Approval'
        ELSE 'Rejected'
    END;

-- Step 4: Calculate Maximum_Home_Loan_Instalment
UPDATE Home_Loan
SET Maximum_Home_Loan_Instalment = 
    CASE
        WHEN Credit_Score >= 800 THEN Listed_Price
        WHEN Credit_Score >= 750 THEN Listed_Price * 0.975
        WHEN Credit_Score >= 700 THEN Listed_Price * 0.95
        WHEN Credit_Score >= 650 THEN Listed_Price * 0.90
        ELSE 0
    END;

-- Step 5: Calculate Percentage_Home_Loan_Granted
UPDATE Home_Loan
SET Percentage_Home_Loan_Granted = 
    CASE
        WHEN Credit_Score >= 800 THEN 100
        WHEN Credit_Score >= 750 THEN 97.5
        WHEN Credit_Score >= 700 THEN 95
        WHEN Credit_Score >= 650 THEN 90
        ELSE 0
    END;

-- Step 6: Calculate Deposit_Required
UPDATE Home_Loan
SET Deposit_Required = 
    CASE
        WHEN Percentage_Home_Loan_Granted < 100 THEN Listed_Price * (1 - Percentage_Home_Loan_Granted / 100)
        ELSE 0
    END;

-- Step 7: Calculate Monthly_Instalment
UPDATE Home_Loan
SET Monthly_Instalment = (Listed_Price - Deposit_Required) * 0.00785;
