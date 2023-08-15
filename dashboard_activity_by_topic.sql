SELECT
    dashboard.name,
    activity.topic,
    COUNT(*) AS count
FROM activity AS activity
LEFT JOIN core_user ON (activity.user_id = core_user.id)
LEFT JOIN report_dashboard AS dashboard ON (activity.model_id = dashboard.id)
LEFT JOIN report_card AS r_card ON (activity.model_id = r_card.id)
WHERE dashboard.name IS NOT NULL
GROUP BY 1, 2
ORDER BY 1
