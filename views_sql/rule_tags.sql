SELECT type
    , target
    , rule_name
    , rule_id
    , TO_VARCHAR(value) AS tag
FROM (
    SELECT REGEXP_REPLACE(table_name, '.*_([^_]+)_([^_]+)', '\\1') AS target
        , REGEXP_REPLACE(table_name, '.*_([^_]+)_([^_]+)', '\\2') AS type
        , table_name AS rule_name
        , IFF(
            CONTAINS(comment, '@id'),
            REGEXP_REPLACE(comment, '[\\s\\S]*@id ([^\n]*)[\\s\\S]*', '\\1'),
            NULL
        ) AS rule_id
        , IFF(
            CONTAINS(comment, '@tags'),
            SPLIT(REGEXP_REPLACE(comment, '[\\s\\S]*@tags ([^\n]*)[\\s\\S]*', '\\1'), ', '),
            ARRAY_CONSTRUCT()
        ) AS tags
    FROM information_schema.views
    WHERE table_schema='${rules_schema}'
) AS query_tag_list
, LATERAL FLATTEN(input => query_tag_list.tags)
