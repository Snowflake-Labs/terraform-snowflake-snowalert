SELECT table_name AS view_name
     , REGEXP_SUBSTR(comment, '^[^\\n]*', 1, 1,  'e') AS title_from_comment
     , REGEXP_SUBSTR(view_definition, ', \'(.*\)\' AS title', 1, 1,  'e') AS title_field
FROM information_schema.views
WHERE table_schema='RULES'
