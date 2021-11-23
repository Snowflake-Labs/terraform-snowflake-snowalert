SELECT tag
    , alert.*
FROM data.rule_tags AS rule_tag
FULL OUTER JOIN data.alerts AS alert
    ON rule_tag.rule_id=alert.query_id
