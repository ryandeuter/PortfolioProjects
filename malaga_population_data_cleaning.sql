SELECT *
FROM malaga_pop

--Converting Spanish thousands to English thousands)

UPDATE malaga_pop
SET Total = 
REPLACE(Total, '.', '')

SELECT * 
FROM malaga_pop

--Renaming "Periodo" to "Period" to have consistent English format

EXEC sp_rename
'malaga_pop.Periodo',
'Period', 'COLUMN'

SELECT * 
FROM malaga_pop

--Also going to convert "Males" and "Females" to "Male" and "Female"

UPDATE malaga_pop
SET Sex = 
REPLACE(REPLACE(Sex, 
'Males', 'Male'),
'Females', 'Female')

SELECT * 
FROM malaga_pop

UPDATE malaga_pop
SET Sex = 
REPLACE(Sex,
'FeMale', 'Female')

SELECT * 
FROM malaga_pop

--Going to seperate post code from Municipality

ALTER TABLE malaga_pop
ADD Postcode VARCHAR(50), Municipality VARCHAR(100)

UPDATE malaga_pop
SET Postcode = LEFT(Municipalities,
CHARINDEX(' ', Municipalities) -1),
	Municipality =
LTRIM(RIGHT(Municipalities,
LEN(Municipalities) - CHARINDEX(' ',
Municipalities)))

SELECT *
FROM malaga_pop

--Drop extraneous Municipalities column

ALTER TABLE malaga_pop
DROP COLUMN Municipalities

SELECT Municipality, Postcode, Sex, Period, Total
FROM malaga_pop
ORDER BY Municipality, Period

--Delete 'Totals' value in Sex column, as I can't aggregate by Sex properly

DELETE FROM malaga_pop where Sex = 'Total'
