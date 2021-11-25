SELECT DATEADD(sec, DATEDIFF(sec, s, e) * ROW_NUMBER() OVER (ORDER BY SEQ4()) / n, s) AS slice_start
    , DATEADD(sec, DATEDIFF(sec, s, e) * 1 / n, slice_start) AS slice_end
FROM TABLE(GENERATOR(ROWCOUNT => n))
