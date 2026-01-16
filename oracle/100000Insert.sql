--100 000 строк в статистику
CREATE OR REPLACE PROCEDURE FILL_STATISTICS
AS
    l_max_travel_id NUMBER;
    v_price         NUMBER;
    v_passengers    NUMBER;
    v_route_id      NUMBER;
    v_distance      NUMBER;
    v_fuel_used     NUMBER;
BEGIN
    -- Определяем максимальный ID поездки
    SELECT NVL(MAX(TRAVEL_ID), 0) INTO l_max_travel_id FROM TRAVELS;

    IF l_max_travel_id = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Нет доступных поездок для заполнения статистики.');
        RETURN;
    END IF;

    -- Генерация 100000 записей
    FOR i IN 1 .. 100000 LOOP
        DECLARE
            v_travel_id NUMBER := TRUNC(DBMS_RANDOM.VALUE(1, l_max_travel_id + 1));
        BEGIN
            -- Получаем цену и маршрут
            SELECT PRICE, ROUTE_ID INTO v_price, v_route_id
            FROM TRAVELS
            WHERE TRAVEL_ID = v_travel_id;

            -- Получаем расстояние маршрута
            SELECT DISTANCE_KM INTO v_distance
            FROM ROUTES
            WHERE ROUTE_ID = v_route_id;

            -- Расчёт расхода топлива
            v_fuel_used := ROUND(v_distance / 100 * 20, 2);

            -- Генерация количества пассажиров (до 50)
            v_passengers := TRUNC(DBMS_RANDOM.VALUE(1, 51));

            -- Вставка записи
            INSERT INTO STATISTICS (
                TRAVEL_ID,
                REVENUE,
                FUEL_USED,
                PASSENGERS_COUNT
            ) VALUES (
                v_travel_id,
                ROUND(v_passengers * v_price, 2),
                v_fuel_used,
                v_passengers
            );
        END;

        -- Коммит каждые 10000 записей
        IF MOD(i, 10000) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE(i || ' записей добавлено...');
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Заполнение STATISTICS завершено: 100000 записей добавлено.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при заполнении статистики: ' || SQLERRM);
END;
/





begin
    FILL_STATISTICS;
end;
select count(*) from statistics;

select count(*) from statistics;
delete from statistics
