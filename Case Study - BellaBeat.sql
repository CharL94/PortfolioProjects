--Overviewing the data we're working with to check for any errors

SELECT *
FROM 
	CaseStudyBellaBeat..DailyActivity

SELECT *
FROM
	CaseStudyBellaBeat..SleepDay
	
SELECT *
FROM
	CaseStudyBellaBeat..WeightLogInfo

SELECT *
FROM
	CaseStudyBellaBeat..DailySteps


--Starting the cleaning process

--Standarizing the date format

UPDATE
	CaseStudyBellaBeat..DailyActivity
SET
	ActivityDate = CONVERT(Date, ActivityDate)

UPDATE
	CaseStudyBellaBeat..SleepDay
SET
	SleepDay = CONVERT(Date, SleepDay)

UPDATE
	CaseStudyBellaBeat..DailySteps
SET
	ActivityDay = CONVERT(Date, ActivityDay)

-- Breaking out the Date and Time before standardizing the date

SELECT
	SUBSTRING(WeighingDate, 1, 12),
	SUBSTRING(WeighingDate, 13, 7)
FROM
	CaseStudyBellaBeat..WeightLogInfo

ALTER TABLE
	WeightLogInfo
ADD WeighingDay Date

UPDATE
	CaseStudyBellaBeat..WeightLogInfo
SET
	WeighingDay = (SUBSTRING(WeighingDate, 1, 12))

ALTER TABLE
	WeightLogInfo
ADD WeighingTime Time

UPDATE
	CaseStudyBellaBeat..WeightLogInfo
SET
	WeighingTime = (SUBSTRING(WeighingDate, 13, 7))

--Continuing with the cleaning up the date and the time in this table

UPDATE
	CaseStudyBellaBeat..WeightLogInfo
SET
	WeighingDay = CONVERT(Date, WeighingDay)

UPDATE
	CaseStudyBellaBeat..WeightLogInfo
SET
	WeighingTime = CONVERT(Time, WeighingTime)

--Checking for data's integrity with seeing the unique Ids in each table

SELECT
	COUNT(DISTINCT(Id))
FROM
	CaseStudyBellaBeat..DailyActivity

SELECT
	COUNT(DISTINCT(Id))
FROM
	CaseStudyBellaBeat..SleepDay

SELECT
	COUNT(DISTINCT(Id))
FROM
	CaseStudyBellaBeat..WeightLogInfo

SELECT
	COUNT(DISTINCT(Id))
FROM
	CaseStudyBellaBeat..DailySteps

--There are more Ids on the dailyactivity and dailysteps tables which means that not all users utilized the other features.
--Let's verify that the Ids are consistent throughout all the tables

SELECT
	Activity.Id
FROM
	CaseStudyBellaBeat..DailyActivity AS Activity
LEFT JOIN
	CaseStudyBellaBeat..SleepDay AS Sleep
	ON Activity.Id = Sleep.Id
LEFT JOIN
	CaseStudyBellaBeat..WeightLogInfo AS Weightlog
	ON Activity.Id = Weightlog.Id
LEFT JOIN
	CaseStudyBellaBeat..DailySteps AS Steps
	ON Activity.Id = Steps.Id
GROUP BY Activity.Id

--Our data is ready to be analyzed as the common cleaning errors such as misspelling or spaces and formats have been checked and cleaned
--Aggregating out data to see the logged activity

SELECT
	DISTINCT Id
FROM
	CaseStudyBellaBeat..DailyActivity
WHERE
	LoggedActivitiesDistance > 0

--For our other 2 tables we know that the users have used the extra features so the Ids should be the same as the total

SELECT
	DISTINCT Id
FROM
	CaseStudyBellaBeat..SleepDay
WHERE
	TotalSleepRecords > 0

SELECT
	DISTINCT Id
FROM
	CaseStudyBellaBeat..WeightLogInfo
WHERE
	IsManualReport > 0

-- Loggedactivity ended up being utilized by 4 users, sleep records by 24 users and weightlog was by 8 users, 5 of which were manually reporting it
-- Using Daily steps to classify activity level and compare it to daily calories and sleep time

SELECT
	DISTINCT Activity.Id,
	AVG(Steps.StepTotal) AS AvgSteps,
	AVG(Activity.Calories) AS AvgCalories,
	AVG(Sleep.TotalMinutesAsleep)/60 AS AvgSleep,
CASE
	WHEN AVG(StepTotal) < 5000 THEN 'Sedentary'
	WHEN AVG(StepTotal) >= 5000 AND AVG(StepTotal) < 7500 THEN 'Lightly Active'
	WHEN AVG(StepTotal) >= 7500 AND AVG(StepTotal) < 10000 THEN 'Fairly Active'
	ELSE 'Very Active'
END AS ActivityLevel
FROM
	CaseStudyBellaBeat..DailyActivity AS Activity
LEFT JOIN
	CaseStudyBellaBeat..DailySteps AS Steps
	ON Activity.Id = Steps.Id
LEFT JOIN
	CaseStudyBellaBeat..SleepDay AS Sleep
	ON Activity.Id = Sleep.Id
WHERE StepTotal > 0
GROUP BY
	Activity.Id
ORDER BY 2 DESC

--Activity level between the users seems to be evenly distributed with FairlyActive level to be the most common one