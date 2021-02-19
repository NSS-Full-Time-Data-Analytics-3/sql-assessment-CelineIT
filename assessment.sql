/*q1
The poetry in this database is the work of children in grades 1 through 5.
a. How many poets from each grade are represented in the data?
b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.
c. Do you notice any trends across all grades?*/

--a.
SELECT grade_id, COUNT(grade_id) AS number_poets_per_grade
FROM author
GROUP BY grade_id
ORDER BY grade_id;

--b.
SELECT grade_id, COUNT(grade_id) AS number_poets_per_grade, gender.name
FROM author
INNER JOIN gender ON gender.id = author.gender_id
WHERE gender.name = 'Female' OR gender.name = 'Male'
GROUP BY grade_id, gender.name
ORDER BY grade_id;

--c.
-- In each grade, there are more Female than Male



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


/*q4
Compare the 5 most angry poems by 1st graders to the 5 most angry poems by 5th graders.

a. Which group writes the angreist poems according to the intensity score?
b. Who shows up more in the top five for grades 1 and 5, males or females?
c. Which of these do you like the best?*/

SELECT * FROM grade
-- id 12345 // name 1st etc...
SELECT * FROM author
--id, name of the kid, grade_id, gender_id

SELECT * FROM emotion
-- id 1234 // name Anger, Fear, Sadness, Joy
SELECT * FROM poem_emotion
--id, inten, poem_id, emotion_id 1234



-- a. Which group writes the angreist poems according to the intensity score?
SELECT *
FROM emotion
INNER JOIN poem_emotion AS pe ON pe.emotion_id = emotion.id
INNER JOIN
INNER JOIN author ON author.grade_id = grade.id
WHERE emotion.name = 'Anger' 
AND 

SELECT *
FROM grade

