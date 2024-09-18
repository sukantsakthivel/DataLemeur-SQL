SELECT candidate_id 
FROM candidates 
WHERE skill in('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(candidate_id)=3;