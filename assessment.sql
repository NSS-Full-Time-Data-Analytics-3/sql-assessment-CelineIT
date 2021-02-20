/*q1
The poetry in this database is the work of children in grades 1 through 5.
a. How many poets from each grade are represented in the data?
b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.
c. Do you notice any trends across all grades?*/

-- a. How many poets from each grade are represented in the data?

SELECT grade_id, COUNT(grade_id) AS number_poets_per_grade
FROM author
GROUP BY grade_id
ORDER BY grade_id;
-- 1st grade = 623 poets
-- 2nd grade = 1437 poets
-- 3rd grade = 2344 poets
-- 4th grade = 3288 poets
-- 5th grade = 3464 poets

-- this is just to make sure my total of poets is correct
SELECT grade_id, COUNT(grade_id) AS number_poets_per_grade
FROM author
GROUP BY CUBE (grade_id)
ORDER BY grade_id;
-- total of 11,156 poets

-- b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.
SELECT grade_id, COUNT(grade_id) AS number_poets_per_grade, gender.name
FROM author
INNER JOIN gender ON gender.id = author.gender_id
WHERE gender.name = 'Female' OR gender.name = 'Male'
GROUP BY grade_id, gender.name
ORDER BY grade_id;
-- 1st grade 243 F
-- 1st grade 163 M
-- 2nd grade 605 F
-- 2nd grade 412 M
-- 3rd grade 557 M
-- 3rd grade 948 F
-- 4th grade 723 M
-- 4th grade 1241 F
-- 5th grade 1294 F
-- 5th grade 757 M

--c. Do you notice any trends across all grades? // In each grade, there are more Female than Male



/*q2
Love and death have been popular themes in poetry throughout time. 
Which of these things do children write about more often? 
Which do they have the most to say about when they do? Return the total number of poems, their average character count for poems that mention death and poems that mention love. 
Do this in a single query.*/

SELECT *
FROM poem
WHERE text ILIKE '%lov%' OR title ILIKE '%lov%'
-- 4750 I am using title as well because I found a poem with 'love' in the title but not in the text. Poem id 125 for example

SELECT COUNT (*)
FROM poem
WHERE text ILIKE '%death%' OR title ILIKE '%death%'
--92

-- Final query
SELECT COUNT (*) AS total_number_of_poems,
	(SELECT ROUND(AVG(char_count),2) AS avg_char_count_love
	FROM poem
	WHERE text ILIKE '%lov%' OR title ILIKE '%lov%'),
	(SELECT ROUND(AVG(char_count),2) AS avg_char_count_death
	FROM poem
	WHERE text ILIKE '%death%' OR title ILIKE '%death%')
FROM poem;
-- 32,842 total number of poems
-- average character count for poems that mention death 342.85
-- average character count for poems that mention love 223.40







/*q3
Do longer poems have more emotional intensity compared to shorter poems?*/

-- a. Start by writing a query to return each emotion in the database with it's average intensity and character count.
SELECT emotion.name, count(emotion.name) as count_emotion_name, ROUND(avg(char_count),2) as avg_char_count, ROUND(avg(intensity_percent),2) as avg_intensity_percent
FROM poem_emotion AS pe
INNER JOIN emotion ON emotion.id = pe.emotion_id
INNER JOIN poem ON poem.id = pe.poem_id
GROUP BY emotion.name

-- Which emotion is associated with the longest poems on average? //Same code adding ORDER BY avg_char_count DESC
SELECT emotion.name, count(emotion.name) as count_emotion_name, ROUND(avg(char_count),2) as avg_char_count, ROUND(avg(intensity_percent),2) as avg_intensity_percent
FROM poem_emotion AS pe
INNER JOIN emotion ON emotion.id = pe.emotion_id
INNER JOIN poem ON poem.id = pe.poem_id
GROUP BY emotion.name
ORDER BY avg_char_count DESC
-- Anger

-- Which emotion has the shortest? //Same code adding ORDER BY avg_char_count 
SELECT emotion.name, count(emotion.name) as count_emotion_name, ROUND(avg(char_count),2) as avg_char_count, ROUND(avg(intensity_percent),2) as avg_intensity_percent
FROM poem_emotion AS pe
INNER JOIN emotion ON emotion.id = pe.emotion_id
INNER JOIN poem ON poem.id = pe.poem_id
GROUP BY emotion.name
ORDER BY avg_char_count 
-- Joy


/*b. Convert the query you wrote in part a into a CTE. 
Then find the 5 most intense poems that express joy and whether they are to be longer or shorter than the average joy poem.*/

WITH cte as (
	SELECT emotion.name, count(emotion.name) as count_emotion_name, ROUND(avg(char_count),2) as avg_char_count, ROUND(avg(intensity_percent),2) as avg_intensity_percent, poem.text
	FROM poem_emotion AS pe
	INNER JOIN emotion ON emotion.id = pe.emotion_id
	INNER JOIN poem ON poem.id = pe.poem_id
	WHERE emotion.name ='Joy'
	GROUP BY emotion.name, poem.text
	)
SELECT *
FROM cte
WHERE avg_char_count > (SELECT AVG(avg_char_count) FROM cte)
ORDER BY avg_intensity_percent DESC
LIMIT 5;

--What is the most joyful poem about? 
-- //Butterflies

-- Do you think these are all classified correctly?
-- // no, some poems are not very joyfull









/*q4
Compare the 5 most angry poems by 1st graders to the 5 most angry poems by 5th graders.

a. Which group writes the angreist poems according to the intensity score?
b. Who shows up more in the top five for grades 1 and 5, males or females?
c. Which of these do you like the best?*/

-- a. Which group writes the angreist poems according to the intensity score?
WITH cte_join as (
			SELECT emotion.name, pe.emotion_id, grade.id as grade_id, grade.name as grade_name
			FROM emotion
			INNER JOIN poem_emotion as pe ON pe.emotion_id = emotion.id
			INNER JOIN poem ON poem.id = pe.poem_id
			INNER JOIN author ON author.id = poem.author_id
			INNER JOIN grade ON grade.id = author.grade_id
			WHERE emotion.name = 'Anger')
SELECT grade_name, COUNT(grade_name) as count_angry
FROM cte_join
GROUP BY grade_name
ORDER BY count_angry DESC;
-- 5th graders write the angriest poems with 4,316 poems

-- b. Who shows up more in the top five for grades 1 and 5, males or females?
WITH cte_join as (
			SELECT emotion.name as emotion_name, grade.id as grade_id, gender.name as gender_name
			FROM emotion
			INNER JOIN poem_emotion as pe ON pe.emotion_id = emotion.id
			INNER JOIN poem ON poem.id = pe.poem_id
			INNER JOIN author ON author.id = poem.author_id
			INNER JOIN grade ON grade.id = author.grade_id
			INNER JOIN gender ON gender.id = author.gender_id
			WHERE emotion.name = 'Anger')
SELECT emotion_name, grade_id, gender_name, count(gender_name) as gender_name_count
FROM cte_join
WHERE gender_name = 'Female' OR gender_name = 'Male'
AND grade_id = '1' OR grade_id = '5'
GROUP BY  emotion_name, grade_id, gender_name
ORDER BY gender_name_count

-- I can't get it to work...
WITH cte_join as (
			SELECT emotion.name as emotion_name, grade.id as grade_id
			FROM emotion
			INNER JOIN poem_emotion as pe ON pe.emotion_id = emotion.id
			INNER JOIN poem ON poem.id = pe.poem_id
			INNER JOIN author ON author.id = poem.author_id
			INNER JOIN grade ON grade.id = author.grade_id
			WHERE emotion.name = 'Anger')
SELECT *
FROM cte_join
INNER JOIN gender ON gender.id = author.gender_id
WHERE gender.name = 'Female' OR gender.name = 'Male'
AND grade_id = '1' OR grade_id = '5'
GROUP BY  emotion_name, grade_id, gender_name
ORDER BY gender_name_count
--- not working




/*5.
Emily Dickinson was a famous American poet, who wrote many poems in the 1800s, including one about a caterpillar that begins:

 > A fuzzy fellow, without feet,
 > Yet doth exceeding run!
 > Of velvet, is his Countenance,
 > And his Complexion, dun!
a. Examine the poets in the database with the name emily. 
Create a report showing the count of emilys by grade along with the distribution of emotions that characterize their work.
b. Export this report to Excel and create a visualization that shows what you have found.*/

SELECT name, grade_id, COUNT(name) as count_emily
FROM author
WHERE name = 'emily'
GROUP BY name, grade_id
-- There are 5 Emilys, one in each grade.

SELECT author.name as author_name, author.grade_id,emotion.name as emotion_name
FROM author
LEFT JOIN emotion ON emotion.id = author.id
-- INNER JOIN poem ON poem.author_id = author.id
-- INNER JOIN poem_emotion as pe ON pe.poem_id = poem.id 
-- INNER JOIN emotion ON emotion.id = pe.emotion_id
WHERE author.name = 'emily'

-- a. Examine the poets in the database with the name emily. 
-- Create a report showing the count of emilys by grade along with the distribution of emotions that characterize their work.