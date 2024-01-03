1.SELECT TOP 10 Buyers_Name
FROM Home_Loan
WHERE Percentage_Home_Loan_Granted = 100
ORDER BY Listed_Price DESC;

2.SELECT COUNT(*) AS QualifiedCustomersWithDeposit
FROM Home_Loan
WHERE Percentage_Home_Loan_Granted < 100 AND Deposit_Required = 20;


3.SELECT TOP 5 Buyers_Name
FROM Home_Loan
WHERE Percentage_Home_Loan_Granted = 100
ORDER BY Listed_Price DESC;

4.SELECT Buyers_Name
FROM Home_Loan
WHERE Percentage_Home_Loan_Granted < 100
  AND (Listed_Price - (Listed_Price * Percentage_Home_Loan_Granted / 100)) BETWEEN Listed_Price * 0.01 AND Listed_Price * 0.20;
