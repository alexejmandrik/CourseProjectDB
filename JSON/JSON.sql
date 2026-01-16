
CREATE OR REPLACE PROCEDURE EXPORT_STATISTICS IS
    l_json_str VARCHAR2(4000);
    l_file UTL_FILE.FILE_TYPE;
    l_directory CONSTANT VARCHAR2(100) := 'JSON_DIR';
    is_first_record BOOLEAN := TRUE;
BEGIN
    l_file := UTL_FILE.FOPEN(l_directory, 'statistics.json', 'w', 32767);

    UTL_FILE.PUT_LINE(l_file, '[');

    FOR rec IN (
        SELECT stat_id, travel_id, revenue, fuel_used, passengers_count
        FROM statistics
    )
    LOOP
        IF NOT is_first_record THEN
            UTL_FILE.PUT_LINE(l_file, ',');
        ELSE
            is_first_record := FALSE;
        END IF;

        l_json_str :=
              '{"stat_id":' || rec.stat_id
           || ',"travel_id":' || rec.travel_id
           || ',"revenue":' || TO_CHAR(rec.revenue, '9999990.00', 'NLS_NUMERIC_CHARACTERS = ''.,''')
           || ',"fuel_used":' || TO_CHAR(rec.fuel_used, '9990.00', 'NLS_NUMERIC_CHARACTERS = ''.,''')
           || ',"passengers_count":' || rec.passengers_count
           || '}';

        UTL_FILE.PUT_LINE(l_file, l_json_str);
    END LOOP;

    UTL_FILE.PUT_LINE(l_file, ']');
    UTL_FILE.FCLOSE(l_file);

    DBMS_OUTPUT.PUT_LINE('Данные из STATISTICS экспортированы в statistics.json');
END;
/






CREATE OR REPLACE PROCEDURE IMPORT_STATISTICS IS
    l_file UTL_FILE.FILE_TYPE;
    l_json_str VARCHAR2(4000);
    l_travel_id NUMBER;
    l_revenue NUMBER;
    l_fuel_used NUMBER;
    l_passengers_count NUMBER;
    l_directory CONSTANT VARCHAR2(100) := 'JSON_DIR';
    l_count NUMBER := 0;
BEGIN
    l_file := UTL_FILE.FOPEN(l_directory, 'statistics.json', 'r');

    LOOP
        BEGIN
            UTL_FILE.GET_LINE(l_file, l_json_str);

            IF TRIM(l_json_str) IN ('[', ']', ',') THEN
                CONTINUE;
            END IF;

            -- Чтение параметров
            l_travel_id :=
                TO_NUMBER(REGEXP_SUBSTR(l_json_str, '"travel_id":([0-9]+)', 1, 1, NULL, 1));

            l_revenue :=
                TO_NUMBER(
                    REGEXP_SUBSTR(l_json_str, '"revenue":([0-9\.]+)', 1, 1, NULL, 1),
                    '9999990D00',
                    'NLS_NUMERIC_CHARACTERS = ''.,'''
                );

            l_fuel_used :=
                TO_NUMBER(
                    REGEXP_SUBSTR(l_json_str, '"fuel_used":([0-9\.]+)', 1, 1, NULL, 1),
                    '9990D00',
                    'NLS_NUMERIC_CHARACTERS = ''.,'''
                );

            l_passengers_count :=
                TO_NUMBER(REGEXP_SUBSTR(l_json_str, '"passengers_count":([0-9]+)', 1, 1, NULL, 1));

            INSERT INTO STATISTICS (TRAVEL_ID, REVENUE, FUEL_USED, PASSENGERS_COUNT)
            VALUES (l_travel_id, l_revenue, l_fuel_used, l_passengers_count);

            l_count := l_count + 1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Ошибка при обработке строки: ' || l_json_str || ' | ' || SQLERRM);
        END;
    END LOOP;

    UTL_FILE.FCLOSE(l_file);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Импорт завершён. Всего записей: ' || l_count);
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(l_file) THEN
            UTL_FILE.FCLOSE(l_file);
        END IF;
        RAISE;
END;
/



begin
    EXPORT_STATISTICS();
end;

begin
    IMPORT_STATISTICS();
end;
select * from statistics where stat_id = 100002;

select count(*) from Statistics;
delete from statistics