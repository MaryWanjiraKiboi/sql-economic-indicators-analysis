
-- Absolute Growth

SELECT 
  indicator_name,
 COALESCE( MAX(CASE WHEN year=2024 THEN value END),0) -
 COALESCE( MAX(CASE WHEN year=2020 THEN value END),0) AS increase_2020_2024
  FROM indicators
  GROUP BY indicator_name
  ORDER BY increase_2020_2024 DESC;

  
  -- Ranking

  SELECT
  indicator_name,
  COALESCE(MAX(CASE WHEN year=2024 THEN value END),0) -
  COALESCE(MAX(CASE WHEN year=2020 THEN value END),0)
  As increase,
  RANK() OVER(
  ORDER BY
  COALESCE(MAX(CASE WHEN year=2024 THEN value END),0) -
  COALESCE(MAX(CASE WHEN year=2020 THEN value END),0)DESC
  ) As rank_position
  FROM indicators
  GROUP BY indicator_name;


  -- Percentage Growth
  
  SELECT
  indicator_name,
  COALESCE(MAX(CASE WHEN year=2024 THEN value END), 0) AS value_2024,
  COALESCE(MAX(CASE WHEN year=2020 THEN value END), 0) AS value_2020,
  CASE
  WHEN COALESCE(MAX(CASE WHEN year=2020 THEN value END), 0) =0 THEN NULL
  ELSE
  (COALESCE(MAX(CASE WHEN year = 2024 THEN value END),0) -
    COALESCE(MAX(CASE WHEN year = 2020 THEN value END),0) 
  )*100.0/
  COALESCE(MAX(CASE WHEN year = 2020 THEN value END),0) 
  END AS percentage_growth
  FROM indicators
  GROUP BY indicator_name
  ORDER BY percentage_growth DESC;
  
  
 -- Contribution Analysis
 
 WITH growth AS(
  SELECT 
  indicator_name,
  COALESCE(MAX(CASE WHEN year=2024 THEN value END),0)-
  COALESCE(MAX(CASE WHEN year=2020 THEN value END),0) AS INCREASE
  FROM indicators
  GROUP BY indicator_name
  )
  
SELECT 
    indicator_name,
    increase,
    SUM(increase) OVER () AS total_growth,
    
    CASE 
        WHEN SUM(increase) OVER () = 0 THEN NULL
        ELSE (increase * 100.0) / SUM(increase) OVER ()
    END AS contribution_percentage

FROM growth
ORDER BY contribution_percentage DESC;
  


  
  
  
  
  
  
  
  
  
  
  