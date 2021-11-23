SELECT tag
    , violation.*
FROM data.rule_tags AS rule_tag
FULL OUTER JOIN data.violations AS violation
ON rule_tag.rule_id=violation.query_id
