-- Create the call_records table
CREATE TABLE call_records (
    call_time TIMESTAMP,
    agent_name VARCHAR(50)
);

-- Insert sample data into the call_records table
INSERT INTO call_records (call_time, agent_name) VALUES
    ('2022-01-01 08:30:00', 'Agent 1'),
    ('2022-01-01 09:15:00', 'Agent 2'),
    ('2022-01-02 10:00:00', 'Agent 3'),
    ('2022-01-02 11:45:00', 'Agent 2'),
    ('2022-01-03 09:30:00', 'Agent 1'),
    ('2022-01-03 10:15:00', 'Agent 3'),
    ('2022-01-05 11:00:00', 'Agent 1'),
    ('2022-01-05 11:45:00', 'Agent 2'),
    ('2022-01-06 12:30:00', 'Agent 3'),
    ('2022-01-06 13:15:00', 'Agent 2');


/*Test the table is created*/
select * from call_records;

/*Naive Query*/

SELECT
    call_time::date AS call_date,
    COUNT(*) AS call_count
FROM
    call_records
GROUP BY
    call_time::date
ORDER BY
    call_time::date;


/*Advanced query using generate series*/
SELECT
    dates.d::date AS call_date,
    COUNT(call_records.call_time) AS call_count
FROM
    generate_series('2022-01-01'::date, '2022-01-31'::date, '1 day') AS dates(d)
LEFT JOIN
    call_records ON dates.d::date = call_records.call_time::date
GROUP BY
    dates.d::date
ORDER BY
    dates.d::date;

/*Generate series with weekday name*/

SELECT
    TO_CHAR(dates.d, 'Day') AS weekday,
    COUNT(call_records.call_time) AS call_count
FROM
    generate_series('2022-01-01', 
    DATE('2022-01-01') + INTERVAL '6 days', '1 day') AS dates(d)
LEFT JOIN
    call_records ON TO_CHAR(call_records.call_time, 'Day') = 
    TO_CHAR(dates.d, 'Day')
GROUP BY
    TO_CHAR(dates.d, 'Day')
ORDER BY
    MIN(dates.d);


