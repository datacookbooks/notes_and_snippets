-- // -- make fake data (1/2) - personnel

DROP TABLE IF EXISTS personnel;
CREATE TABLE personnel(
  employee_id INT,
  employee_name VARCHAR(50),
  division VARCHAR(50),
  division_hq VARCHAR(50),
  exp_level VARCHAR(50),
  salary INT,
  commute_min INT,
  start_date VARCHAR(50)
);

INSERT INTO personnel (employee_id, employee_name, division, division_hq, exp_level, salary, commute_min, start_date) VALUES
(1, 'Alex', 'marketing', 'Boston, MA', 'junior', 72000, 20, '12/23/1986'),
(1, 'Alex', 'marketing', 'Boston, MA', 'junior', 72000, 20, '12/23/1986'),
(1, 'Alex', 'marketing', 'Boston, MA', 'junior', 72000, 20, '12/23/1986'),
(2, 'Bob', 'sales', 'New York, NY', 'junior', 73000, 45, '12/23/1994'),
(3, 'Barbara', 'sales', 'New York, NY', 'senior', 92000, 33, '12/23/1993'),
(3, 'Barbara', 'sales', 'New York, NY', 'senior', 92000, 33, '12/23/1993'),
(4, 'Susan.', 'marketing', '', 'senior', 95000, 50, '12/23/1991'),
(5, '  Jill', 'sales', NULL, 'mid', 78000, 24, '12/23/1993'),
(6, 'Jack  ', 'sales', NULL, 'mid', 76000, 35, '12/23/1994'),
(7, 'John', 'marketing', '', 'mid', 82000, 35, '12/12/1995');

-- // -- make fake data (2/2) - fav_sports

DROP TABLE IF EXISTS fav_sports;
CREATE TABLE fav_sports(
  employee_id INT,
  sport VARCHAR(50),
  hours_practice DECIMAL(10, 1)
);

INSERT INTO fav_sports (employee_id, sport, hours_practice) VALUES
(1, 'basketball', 1.5),
(2, 'swimming', 0.5),
(3, 'swimming', 1.0),
(4, 'running', 2.0),
(5, 'soccer', 2.5),
(8, 'running', 3.5);

-- // -- view all columns and rows

SELECT *
FROM personnel;

SELECT *
FROM fav_sports;

-- // -- get the number of rows

SELECT COUNT(*)
FROM personnel;

-- // -- view specific columns, only 5 rows

SELECT employee_id, employee_name, division
FROM personnel
LIMIT 5;

-- // -- filter data - only see rows where the division column says "marketing", and the exp_level is "mid" or "junior"

SELECT *
FROM personnel
WHERE
  division = 'marketing'
  AND (exp_level = 'mid' OR exp_level = 'junior')
;

-- // -- Make a new column that can have a variety of values based on many conditions. Use CASE clause within the SELECT statement.

SELECT *,
CASE
  WHEN salary < 74000 THEN 'low'
  WHEN salary BETWEEN 74000 AND 80000 THEN 'middle'
  WHEN salary > 80000 THEN 'high'
END earner_type
FROM personnel;

-- // -- Get the maximum value of a column. Get the mean value of a column. Name them. 
-- -- -- -- note: main aggregation functions are MIN, MAX, SUM, AVG, COUNT, STDEVP (for complete data), STDEV (for just a sample) 

SELECT MAX(salary) max_salary, AVG(salary) mean_salary
FROM personnel;

-- // -- See the unique row values in a column 

SELECT DISTINCT division
FROM personnel;

-- // -- See the unique rows based on all columns

SELECT DISTINCT *
FROM personnel;

-- // -- analyze groups - get mean "salary" column value, per group of "exp_level". Order results by the mean_salary, high to low.

SELECT exp_level, AVG(salary) mean_salary
FROM personnel
GROUP BY exp_level
ORDER BY mean_salary DESC;

-- // -- analyze groups - same as above, but order by an aggregated metric that you don't have in the SELECT clause, low to high.

SELECT exp_level, AVG(salary) mean_salary
FROM personnel
GROUP BY exp_level
ORDER BY AVG(commute_min) ASC;

-- // -- filter after analyzing groups; use HAVING.

SELECT exp_level, AVG(salary) mean_salary
FROM personnel
GROUP BY exp_level
HAVING mean_salary > 80000;

-- // -- string function: TRIM. Remove white space on both sides of text. 

SELECT employee_name, TRIM(employee_name) name_trimmed
FROM personnel;

-- // -- string functions: LEFT and RIGHT. Get the 2 leftmost and rightmost characters. 

SELECT employee_name, LEFT(employee_name, 2) name_left, RIGHT(employee_name, 2) name_right
FROM personnel;

-- // -- string function: SUBSTRING. Example: start at character 7 (7th character), then take 4 characters (left to right)
-- -- -- -- note: the first character is in position 1, not 0. 

SELECT employee_name, start_date, SUBSTRING(start_date, 7, 4) substr_date
FROM personnel;

-- // -- string function: CONCAT. For combining strings. Specify a space if you need it!

SELECT employee_id, employee_name, CONCAT(employee_name, ' ', exp_level, ' ', 'level') as col_concat
FROM personnel;

-- // -- string function: REPLACE. We replace a specific character (case sensitive) with another one.

SELECT employee_id, employee_name, REPLACE(employee_name, 'a','w') as name_mod
FROM personnel;

-- // -- string function: LOCATE. Get the position of a string within a string, if present. Returns 0 if not there. 

SELECT employee_id, employee_name, LOCATE('a', employee_name) as location
FROM personnel;


-- // -- convert a text column to a DATE format. 
-- -- -- -- note: if your column name is "date", which is also a SQL keyword, refer to it using backticks `` just to be safe.
-- -- -- -- not needed in our example, but we will show using backticks anyways. 

UPDATE personnel
SET `start_date` = STR_TO_DATE(start_date, '%m/%d/%Y'); -- format the text differently

ALTER TABLE personnel
MODIFY COLUMN `start_date` DATE; -- convert the text type to date type

-- // -- left join. Expand columns in a table, to include columns in another one. Join on a shared column (the index)
-- -- -- -- for left join, we only include rows that exist in the left table's index.
-- -- -- -- note, this results in two columns with the same name. 

SELECT *
FROM
  personnel LEFT JOIN fav_sports
    ON personnel.employee_id = fav_sports.employee_id
;

-- // -- right join. Same as above, but we only include rows that exist in the right table's index. 
-- -- -- -- note, this results in two columns with the same name. 

SELECT *
FROM
  personnel RIGHT JOIN fav_sports
    ON personnel.employee_id = fav_sports.employee_id
;

-- // -- inner join. Same as above, but we only include rows that exist in both table's shared column. 
-- -- -- -- note, this results in two columns with the same name. 

SELECT *
FROM
  personnel INNER JOIN fav_sports
    ON personnel.employee_id = fav_sports.employee_id
;

-- // -- FULL OUTER JOIN. Same as above, but we include any rows that exist in either table's shared column. 
-- -- -- -- not supported in MySQL. We can emulate it using UNION to stack two query results. 
-- -- -- -- if we use UNION ALL instead, we'll have a lot of duplicate rows from stacking those joins. UNION removes them. 

SELECT *
FROM
  personnel LEFT JOIN fav_sports
    ON personnel.employee_id = fav_sports.employee_id
UNION
SELECT *
FROM
  personnel RIGHT JOIN fav_sports
    ON personnel.employee_id = fav_sports.employee_id
;

-- // -- subquery - reference a query within a query. We can put it in the WHERE clause and reference another table.

SELECT employee_name, division
FROM personnel
WHERE employee_id IN 
(
  SELECT employee_id
  FROM fav_sports
  WHERE hours_practice > 2
);

-- // -- subquery - we can put it in the select statement if we want a calculated value to populate all rows.

SELECT employee_name, salary,
(
  SELECT AVG(salary)
  FROM personnel
) mean_salary
FROM personnel;

-- // -- subquery - we can put it in the FROM clause. This allows us to do one query on the results of another, for example on a GROUP BY query.
-- -- -- -- in our case, we want the max value of the groups' mean values.

SELECT MAX(avg_salary) max_GroupAvg_salary
FROM 
(
  SELECT exp_level, AVG(SALARY) avg_salary
  FROM personnel
  GROUP BY exp_level
) AS p_grouped;

-- // -- CTE - like a subquery but more readable. Need to be used immediately. Example of one in the FROM clause. First, define it. 

WITH cte_example AS
(
  SELECT employee_id, sport, hours_practice
  FROM fav_sports
  WHERE hours_practice > 1.5
)
SELECT sport, AVG(hours_practice) OVER(PARTITION BY sport) as avg_ThisSport
FROM cte_example;

-- // -- CTEs - you can do multiple. But you need to separate them with a comma. 

WITH cte_example_1 AS
(
  SELECT employee_id, sport, hours_practice
  FROM fav_sports
  WHERE hours_practice > 1.5
),
cte_example_2 AS 
(
  SELECT employee_id, sport, hours_practice
  FROM fav_sports
  WHERE hours_practice <= 1.5
)
SELECT *
FROM cte_example_1 
UNION 
SELECT *
FROM cte_example_2
ORDER BY employee_id;

-- // -- OVER and PARTITION BY - for analyzing groups without collapsing rows. Example with finding a group's mean. like pandas groupby.transform("mean")

SELECT
  employee_name,
  exp_level,
  salary,
  AVG(salary) OVER (PARTITION BY exp_level) AS salary_avg_ThisLevel
FROM personnel;

-- // -- OVER and PARTITION BY - example for finding the row_number of each group. 

SELECT
  employee_name,
  exp_level,
  salary,
  row_number() OVER (PARTITION BY exp_level) AS rn
FROM personnel;

-- // -- remove duplicates, based on a subset of columns. Store in new table. 

DROP TABLE IF EXISTS personnel_staging;
CREATE TABLE personnel_staging AS
SELECT *
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER (
			PARTITION BY employee_name, exp_level, salary, commute_min 
			ORDER BY (SELECT NULL)
		) AS `row_number`
	FROM personnel
) p_mod
WHERE `row_number` = 1;

SELECT *
FROM personnel_staging;

-- // -- convert blank values to nulls

UPDATE personnel
SET division_hq = NULL
WHERE division_hq = '';

SELECT *
FROM personnel;

-- // -- suppose every division should have a division_hq. Some rows have division but not hq. Fix this!

UPDATE 
  personnel t1 JOIN personnel t2
    ON t1.division = t2.division -- this join creates a huge table. Twice as many columns, and a lot of rows bc of a lot of overlap with itself!
SET t1.division_hq = t2.division_hq
WHERE 
  t1.division_hq IS NULL -- here we are only modifying the unjoined table. THe first personnel.
  AND t2.division_hq IS NOT NULL;
  
SELECT *
FROM personnel; -- here we view the modified personnel table. 
