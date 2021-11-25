SELECT tag
    , violation.*
FROM ${data_rule_tags} AS rule_tag
FULL OUTER JOIN ${data_violations} AS violation
    ON rule_tag.rule_id = violation.query_id
