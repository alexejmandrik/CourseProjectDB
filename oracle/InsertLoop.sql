BEGIN
    FOR i IN 1..100 LOOP
        REGISTER_USER(
            'user' || i,
            'pass' || i,
            'pass' || i,
            'Пользователь ',
            '+37529' || LPAD(i, 7, '0')
        );
    END LOOP;
END;
/
select * from users;

BEGIN
    FOR i IN 1..200 LOOP
        REGISTER_DRIVER(
            'driver' || i,
            'drv' || i,
            'drv' || i,
            'Водитель ',
            '+37533' || LPAD(i, 7, '0')
        );
    END LOOP;
END;
/
BEGIN
    FOR i IN 1..150 LOOP
        ADD_VEHICLE(
            'AA' || LPAD(i, 3, '0') || '-7',
            'Yutong',
            40 + MOD(i, 10) -- вместимость 40–49
        );
    END LOOP;
END;
/
select * from vehicles;
BEGIN
    FOR i IN 1..150 LOOP
        ADD_ROUTE(
            'Город_' || i,
            'Город_' || (i + 1),
            50 + MOD(i * 7, 900) -- расстояние 50–950 км
        );
    END LOOP;
END;
/
BEGIN
    FOR i IN 1..100 LOOP
        ADD_TRAVEL(
            i,                  -- ROUTE_ID
            i,                  -- VEHICLE_ID
            100 + MOD(i, 100),    -- DRIVER_ID
            TRUNC(SYSDATE) - MOD(i, 30),
            TRUNC(SYSDATE) - MOD(i, 30) + INTERVAL '5' HOUR,
            10 + MOD(i, 15)     -- цена 10–24
        );
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..100 LOOP
        ADD_BOOKING(
            MOD(i, 100) + 1,  -- TRAVEL_ID
            MOD(i, 100) + 1   -- USER_ID
        );
    END LOOP;
END;
/

