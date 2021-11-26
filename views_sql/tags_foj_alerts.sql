SELECT tag
    , alert.*
FROM ${data_rule_tags} AS rule_tag
FULL OUTER JOIN ${data_alerts} AS alert
    ON rule_tag.rule_id = alert.query_id
