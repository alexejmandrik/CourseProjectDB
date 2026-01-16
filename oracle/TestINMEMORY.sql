set timing on;
 SELECT
    rt.START_POINT || ' → ' || rt.END_POINT        AS ROUTE,
    u.FULL_NAME                                   AS DRIVER,
    v.MODEL                                       AS VEHICLE_MODEL,

    COUNT(DISTINCT t.TRAVEL_ID)                   AS TRAVELS_COUNT,
    SUM(s.PASSENGERS_COUNT)                       AS TOTAL_PASSENGERS,
    SUM(s.REVENUE)                                AS TOTAL_REVENUE,
    SUM(s.FUEL_USED)                              AS TOTAL_FUEL,

    ROUND(SUM(s.REVENUE) / NULLIF(SUM(s.PASSENGERS_COUNT), 0), 2)
                                                   AS REVENUE_PER_PASSENGER,

    ROUND(SUM(s.REVENUE) / NULLIF(SUM(rt.DISTANCE_KM), 0), 2)
                                                   AS REVENUE_PER_KM,

    ROUND(AVG(s.PASSENGERS_COUNT / v.CAPACITY) * 100, 2)
                                                   AS AVG_VEHICLE_LOAD_PERCENT,

    -- Рейтинг маршрутов по выручке
    RANK() OVER (
        ORDER BY SUM(s.REVENUE) DESC
    ) AS ROUTE_REVENUE_RANK,

    -- Рейтинг водителей по пассажирам
    RANK() OVER (
        ORDER BY SUM(s.PASSENGERS_COUNT) DESC
    ) AS DRIVER_POPULARITY_RANK

FROM STATISTICS s
JOIN TRAVELS t        ON t.TRAVEL_ID  = s.TRAVEL_ID
JOIN ROUTES rt        ON rt.ROUTE_ID  = t.ROUTE_ID
JOIN VEHICLES v       ON v.VEHICLE_ID = t.VEHICLE_ID
JOIN USERS u          ON u.USER_ID    = t.DRIVER_ID

WHERE
    t.STATUS = 'OK'
    AND t.DEPARTURE_DATE >= ADD_MONTHS(TRUNC(SYSDATE), -6)

GROUP BY
    rt.START_POINT,
    rt.END_POINT,
    u.FULL_NAME,
    v.MODEL,
    v.CAPACITY

HAVING
    SUM(s.PASSENGERS_COUNT) > 0

ORDER BY
    TOTAL_REVENUE DESC;


SELECT owner, table_name, inmemory, inmemory_priority
FROM dba_tables
WHERE inmemory = 'ENABLED';

SELECT *
FROM v$im_segments;

SHOW PARAMETER inmemory

ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;