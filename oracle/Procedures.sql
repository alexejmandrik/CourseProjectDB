-- Хеширование пароля
CREATE OR REPLACE FUNCTION HASH_PASSWORD(p_password VARCHAR2)
RETURN VARCHAR2
AS
    l_hash RAW(256);
BEGIN
    l_hash := DBMS_CRYPTO.HASH(
                   UTL_RAW.CAST_TO_RAW(p_password),
                   DBMS_CRYPTO.HASH_SH256
             );

    RETURN RAWTOHEX(l_hash);
END;
/

-- Регистрация администратора 
CREATE OR REPLACE PROCEDURE REGISTER_ADMIN (
    p_login          IN USERS.LOGIN%TYPE,
    p_password       IN VARCHAR2,
    p_password_conf  IN VARCHAR2,
    p_full_name      IN USERS.FULL_NAME%TYPE,
    p_phone          IN USERS.PHONE%TYPE
)
AS
    l_exists NUMBER;
    l_admin_role_id NUMBER;
BEGIN
    -- Проверка совпадения паролей
    IF p_password <> p_password_conf THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароли не совпадают.');
        RETURN;
    END IF;
    -- Проверка длины пароля
    IF LENGTH(p_password) < 4 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароль должен содержать минимум 4 символа.');
        RETURN;
    END IF;
    -- Проверка уникальности логина
    SELECT COUNT(*) INTO l_exists FROM USERS WHERE LOGIN = p_login;

    IF l_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь с таким логином уже существует.');
        RETURN;
    END IF;
    
    -- Проверка корректности ФИО 
    IF NOT REGEXP_LIKE(p_full_name, '^[[:alpha:] ]{2,100}$') THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ФИО должно содержать только буквы и пробелы (2-100 символов).');
    RETURN;
    END IF;

    -- Проверка корректности телефона
    IF NOT REGEXP_LIKE(p_phone, '^\+?\d{12,12}$') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Номер телефона должен содержать только цифры (12 цифр), + в начале.');
        RETURN;
    END IF;
    
    -- Получение ID роли ADMIN
    BEGIN
        SELECT ROLE_ID INTO l_admin_role_id FROM ROLES WHERE ROLE_NAME = 'ADMIN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль ADMIN не найдена в таблице ROLES.');
            RETURN;
    END;
    -- Добавление администратора
    INSERT INTO USERS (LOGIN, PASSWORD_HASH, FULL_NAME, PHONE, ROLE_ID)
    VALUES (
        p_login,
        HASH_PASSWORD(p_password),
        p_full_name,
        p_phone,
        l_admin_role_id
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Администратор успешно зарегистрирован: ' || p_login);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Неизвестная ошибка при регистрации администратора: ' || SQLERRM);
END;
/

-- Регистрация водителя
CREATE OR REPLACE PROCEDURE REGISTER_DRIVER (
    p_login          IN USERS.LOGIN%TYPE,
    p_password       IN VARCHAR2,
    p_password_conf  IN VARCHAR2,
    p_full_name      IN USERS.FULL_NAME%TYPE,
    p_phone          IN USERS.PHONE%TYPE
)
AS
    l_exists NUMBER;
    l_driver_role_id NUMBER;
BEGIN
    -- Проверка совпадения паролей
    IF p_password <> p_password_conf THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароли не совпадают.');
        RETURN;
    END IF;
    -- Проверка длины пароля
    IF LENGTH(p_password) < 4 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароль должен содержать минимум 4 символа.');
        RETURN;
    END IF;
    -- Проверка уникальности логина
    SELECT COUNT(*) INTO l_exists FROM USERS WHERE LOGIN = p_login;

    IF l_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь с таким логином уже существует.');
        RETURN;
    END IF;
   -- Проверка корректности ФИО 
    IF NOT REGEXP_LIKE(p_full_name, '^[[:alpha:] ]{2,100}$') THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ФИО должно содержать только буквы и пробелы (2-100 символов).');
    RETURN;
    END IF;

    -- Проверка корректности телефона
    IF NOT REGEXP_LIKE(p_phone, '^\+?\d{12,12}$') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Номер телефона должен содержать только цифры (12 цифр), + в начале.');
        RETURN;
    END IF;
    -- Получение ID роли DRIVER
    BEGIN
        SELECT ROLE_ID INTO l_driver_role_id FROM ROLES WHERE ROLE_NAME = 'DRIVER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль DRIVER не найдена в таблице ROLES.');
            RETURN;
    END;
    -- Добавление водителя
    INSERT INTO USERS (LOGIN, PASSWORD_HASH, FULL_NAME, PHONE, ROLE_ID)
    VALUES (
        p_login,
        HASH_PASSWORD(p_password),
        p_full_name,
        p_phone,
        l_driver_role_id
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Водитель успешно зарегистрирован: ' || p_login);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Неизвестная ошибка при регистрации водителя: ' || SQLERRM);
END;
/

-- Регистрация пользователя 
CREATE OR REPLACE PROCEDURE REGISTER_USER (
    p_login          IN USERS.LOGIN%TYPE,
    p_password       IN VARCHAR2,
    p_password_conf  IN VARCHAR2,
    p_full_name      IN USERS.FULL_NAME%TYPE,
    p_phone          IN USERS.PHONE%TYPE
)
AS
    l_exists NUMBER;
    l_user_role_id NUMBER;
BEGIN
    -- Проверка совпадения паролей
    IF p_password <> p_password_conf THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароли не совпадают.');
        RETURN;
    END IF;
    -- Проверка длины пароля
    IF LENGTH(p_password) < 4 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароль должен содержать минимум 4 символа.');
        RETURN;
    END IF;
    -- Проверка уникальности логина
    SELECT COUNT(*) INTO l_exists FROM USERS WHERE LOGIN = p_login;

    IF l_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь с таким логином уже существует.');
        RETURN;
    END IF;
    -- Проверка корректности ФИО 
    IF NOT REGEXP_LIKE(p_full_name, '^[[:alpha:] ]{2,100}$') THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ФИО должно содержать только буквы и пробелы (2-100 символов).');
    RETURN;
    END IF;

    -- Проверка корректности телефона
    IF NOT REGEXP_LIKE(p_phone, '^\+?\d{12,12}$') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Номер телефона должен содержать только цифры (12 цифр), + в начале.');
        RETURN;
    END IF;
    -- Получение ID роли USER
    BEGIN
        SELECT ROLE_ID INTO l_user_role_id FROM ROLES WHERE ROLE_NAME = 'USER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль USER не найдена в таблице ROLES.');
            RETURN;
    END;
    -- Добавление пользователя
    INSERT INTO USERS (LOGIN, PASSWORD_HASH, FULL_NAME, PHONE, ROLE_ID)
    VALUES (
        p_login,
        HASH_PASSWORD(p_password),
        p_full_name,
        p_phone,
        l_user_role_id
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Пользователь успешно зарегистрирован: ' || p_login);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Неизвестная ошибка при регистрации пользователя: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE UPDATE_USER (
    p_login             IN USERS.LOGIN%TYPE,
    p_old_password      IN VARCHAR2,
    p_full_name         IN USERS.FULL_NAME%TYPE,
    p_phone             IN USERS.PHONE%TYPE,
    p_new_password      IN VARCHAR2,
    p_new_password_conf IN VARCHAR2
)
AS
    l_exists NUMBER;
    l_role_id NUMBER;
    l_user_role_id NUMBER;
    l_status VARCHAR2(20);
    l_current_hash VARCHAR2(256);
BEGIN
    -- Получаем ID роли USER
    BEGIN
        SELECT ROLE_ID INTO l_user_role_id FROM ROLES WHERE ROLE_NAME = 'USER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль USER не найдена в таблице ROLES.');
            RETURN;
    END;

    -- Проверка существования пользователя и получение роли, статуса и текущего хеша пароля
    BEGIN
        SELECT COUNT(*), ROLE_ID, STATUS, PASSWORD_HASH 
        INTO l_exists, l_role_id, l_status, l_current_hash
        FROM USERS
        WHERE LOGIN = p_login
        GROUP BY ROLE_ID, STATUS, PASSWORD_HASH;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь с таким логином не существует.');
            RETURN;
    END;

    IF l_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь с таким логином не существует.');
        RETURN;
    END IF;

    -- Проверка, что пользователь имеет роль USER
    IF l_role_id != l_user_role_id THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Обновлять можно только пользователей с ролью USER.');
        RETURN;
    END IF;

    -- Проверка статуса пользователя
    IF l_status = 'BLOCKED' THEN
        DBMS_OUTPUT.PUT_LINE('Пользователь заблокирован.');
        RETURN;
    END IF;

    -- Проверка старого пароля
    IF HASH_PASSWORD(p_old_password) != l_current_hash THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Старый пароль неверный.');
        RETURN;
    END IF;

    -- Проверка корректности ФИО
    IF NOT REGEXP_LIKE(p_full_name, '^[[:alpha:] ]{2,100}$') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ФИО должно содержать только буквы и пробелы (2-100 символов).');
        RETURN;
    END IF;

    -- Проверка корректности телефона
    IF NOT REGEXP_LIKE(p_phone, '^\+?\d{12,12}$') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Номер телефона должен содержать только цифры (12 цифр), + в начале.');
        RETURN;
    END IF;

    -- Проверка обязательности ввода нового пароля
    IF p_new_password IS NULL OR p_new_password_conf IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Для обновления данных необходимо ввести новый пароль и его подтверждение.');
        RETURN;
    END IF;

    -- Проверка совпадения нового пароля
    IF p_new_password <> p_new_password_conf THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароли не совпадают.');
        RETURN;
    END IF;

    -- Проверка длины нового пароля
    IF LENGTH(p_new_password) < 4 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пароль должен содержать минимум 4 символа.');
        RETURN;
    END IF;

    -- Обновление данных и пароля
    UPDATE USERS
    SET FULL_NAME = p_full_name,
        PHONE = p_phone,
        PASSWORD_HASH = HASH_PASSWORD(p_new_password)
    WHERE LOGIN = p_login;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Данные пользователя обновлены: ' || p_login);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении данных: ' || SQLERRM);
END;
/


--Блокировка/Разблокировка пользователя
CREATE OR REPLACE PROCEDURE SET_USER_STATUS (
    p_login  IN USERS.LOGIN%TYPE,
    p_status IN VARCHAR2
)
AS
    l_exists NUMBER;
    l_status_clean VARCHAR2(20);
    l_role_name VARCHAR2(50);
BEGIN
    -- Убираем пробелы и приводим к верхнему регистру
    l_status_clean := UPPER(TRIM(p_status));

    -- Проверка существования пользователя и получение его роли
    SELECT COUNT(*), r.ROLE_NAME
    INTO l_exists, l_role_name
    FROM USERS u
    JOIN ROLES r ON u.ROLE_ID = r.ROLE_ID
    WHERE u.LOGIN = p_login
    GROUP BY r.ROLE_NAME;

    IF l_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь с таким логином не существует.');
        RETURN;
    END IF;

    -- Проверка корректности статуса
    IF l_status_clean NOT IN ('ACTIVE', 'BLOCKED') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Статус должен быть ACTIVE или BLOCKED.');
        RETURN;
    END IF;

    -- Проверка роли администратора
    IF l_role_name = 'ADMIN' AND l_status_clean = 'BLOCKED' THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Нельзя заблокировать администратора.');
        RETURN;
    END IF;

    -- Обновление статуса
    UPDATE USERS
    SET STATUS = l_status_clean
    WHERE LOGIN = p_login;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Статус пользователя изменён: ' || p_login ||
                         ' → ' || l_status_clean);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка изменения статуса пользователя: ' || SQLERRM);
END;
/







-- Добавление роли
CREATE OR REPLACE PROCEDURE ADD_ROLE(
    p_role_name IN ROLES.ROLE_NAME%TYPE
) AS
    v_new_id   ROLES.ROLE_ID%TYPE;
    v_exists   NUMBER;
    v_role_clean ROLES.ROLE_NAME%TYPE;
BEGIN
    -- Очистка имени роли
    v_role_clean := UPPER(TRIM(p_role_name));

    -- Проверка на пустое значение
    IF v_role_clean IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Имя роли не может быть пустым.');
        RETURN;
    END IF;

    -- Проверка, существует ли роль
    SELECT COUNT(*)
    INTO v_exists
    FROM ROLES
    WHERE UPPER(TRIM(ROLE_NAME)) = v_role_clean;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Роль "' || v_role_clean || '" уже существует.');
        RETURN;
    END IF;

    -- Добавление роли
    INSERT INTO ROLES (ROLE_NAME)
    VALUES (v_role_clean)
    RETURNING ROLE_ID INTO v_new_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Role added: ID=' || v_new_id || ', Name=' || v_role_clean);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка добавления роли: ' || SQLERRM);
END;
/



-- Добавление маршрута
CREATE OR REPLACE PROCEDURE ADD_ROUTE(
    p_start_point IN ROUTES.START_POINT%TYPE,
    p_end_point   IN ROUTES.END_POINT%TYPE,
    p_distance_km IN ROUTES.DISTANCE_KM%TYPE
) AS
    v_new_id   ROUTES.ROUTE_ID%TYPE;
    v_exists   NUMBER;
BEGIN
    -- Проверка: начальная и конечная точки не должны совпадать
    IF TRIM(UPPER(p_start_point)) = TRIM(UPPER(p_end_point)) THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: START_POINT и END_POINT не могут быть одинаковыми.');
        RETURN;
    END IF;

    -- Проверка: расстояние должно быть больше 0
    IF p_distance_km IS NULL OR p_distance_km <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: DISTANCE_KM должно быть больше 0.');
        RETURN;
    END IF;

    -- Проверка: маршрут уже существует
    SELECT COUNT(*)
    INTO v_exists
    FROM ROUTES
    WHERE TRIM(UPPER(START_POINT)) = TRIM(UPPER(p_start_point))
      AND TRIM(UPPER(END_POINT))   = TRIM(UPPER(p_end_point));

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Маршрут "' || p_start_point || ' → ' || p_end_point || '" уже существует.'
        );
        RETURN;
    END IF;

    -- Добавление маршрута
    INSERT INTO ROUTES (START_POINT, END_POINT, DISTANCE_KM)
    VALUES (p_start_point, p_end_point, p_distance_km)
    RETURNING ROUTE_ID INTO v_new_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Route added: ID=' || v_new_id ||
        ', From=' || p_start_point ||
        ' To=' || p_end_point
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка создания маршрута: ' || SQLERRM);
END;
/



-- Изменение маршрута
CREATE OR REPLACE PROCEDURE UPDATE_ROUTE(
    p_route_id    IN ROUTES.ROUTE_ID%TYPE,
    p_start_point IN ROUTES.START_POINT%TYPE,
    p_end_point   IN ROUTES.END_POINT%TYPE,
    p_distance_km IN ROUTES.DISTANCE_KM%TYPE
) AS
    v_exists NUMBER;
BEGIN
    -- Проверка существования маршрута
    SELECT COUNT(*)
    INTO v_exists
    FROM ROUTES
    WHERE ROUTE_ID = p_route_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Маршрут с ID=' || p_route_id || ' не существует.');
        RETURN;
    END IF;

    -- Проверка: начальная и конечная точки не должны совпадать
    IF TRIM(UPPER(p_start_point)) = TRIM(UPPER(p_end_point)) THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: START_POINT и END_POINT не могут быть одинаковыми.');
        RETURN;
    END IF;

    -- Проверка: расстояние должно быть больше 0
    IF p_distance_km IS NULL OR p_distance_km <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: DISTANCE_KM должно быть больше 0.');
        RETURN;
    END IF;

    -- Проверка: маршрут с такими точками уже существует (кроме текущего)
    SELECT COUNT(*)
    INTO v_exists
    FROM ROUTES
    WHERE TRIM(UPPER(START_POINT)) = TRIM(UPPER(p_start_point))
      AND TRIM(UPPER(END_POINT))   = TRIM(UPPER(p_end_point))
      AND ROUTE_ID <> p_route_id;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Маршрут "' || p_start_point || ' → ' || p_end_point || '" уже существует.'
        );
        RETURN;
    END IF;

    -- Обновление маршрута
    UPDATE ROUTES
    SET START_POINT = p_start_point,
        END_POINT   = p_end_point,
        DISTANCE_KM = p_distance_km
    WHERE ROUTE_ID = p_route_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Маршрут обновлен: ID=' || p_route_id ||
        ', From=' || p_start_point ||
        ' To=' || p_end_point ||
        ', Distance=' || p_distance_km || ' km'
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка обновления маршрута: ' || SQLERRM);
END;
/


-- Добавление поездки с полной валидацией
CREATE OR REPLACE PROCEDURE ADD_TRAVEL(
    p_route_id    IN TRAVELS.ROUTE_ID%TYPE,
    p_vehicle_id  IN TRAVELS.VEHICLE_ID%TYPE,
    p_driver_id   IN TRAVELS.DRIVER_ID%TYPE,
    p_departure   IN TRAVELS.DEPARTURE_DATE%TYPE,
    p_arrival     IN TRAVELS.ARRIVAL_DATE%TYPE,
    p_price       IN NUMBER,
    p_status      IN TRAVELS.STATUS%TYPE DEFAULT 'OK'
) AS
    v_new_id          TRAVELS.TRAVEL_ID%TYPE;
    v_exists          NUMBER;
    v_driver_role_id  NUMBER;
BEGIN
    -- 0. Проверка, что дата отправления не в прошлом
    IF p_departure < SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Дата отправления не может быть в прошлом.');
        RETURN;
    END IF;

    -- 1. Проверка корректности временного интервала
    IF p_arrival <= p_departure THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Время прибытия должно быть позже времени отправления.');
        RETURN;
    END IF;

    -- 2. Проверка на полностью одинаковую поездку
    SELECT COUNT(*)
    INTO v_exists
    FROM TRAVELS
    WHERE ROUTE_ID = p_route_id
      AND VEHICLE_ID = p_vehicle_id
      AND DRIVER_ID = p_driver_id
      AND DEPARTURE_DATE = p_departure
      AND ARRIVAL_DATE = p_arrival
      AND STATUS = p_status
      AND PRICE = p_price;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Такая поездка уже существует.');
        RETURN;
    END IF;

    -- 3. Проверка занятости транспортного средства
    SELECT COUNT(*)
    INTO v_exists
    FROM TRAVELS
    WHERE VEHICLE_ID = p_vehicle_id
      AND STATUS = 'OK'
      AND DEPARTURE_DATE < p_arrival
      AND ARRIVAL_DATE   > p_departure;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Транспортное средство занято в указанный период.');
        RETURN;
    END IF;

    -- 4. Проверка статуса и роли водителя
    BEGIN
        SELECT ROLE_ID INTO v_driver_role_id
        FROM ROLES
        WHERE ROLE_NAME = 'DRIVER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль DRIVER не найдена.');
            RETURN;
    END;

    SELECT COUNT(*)
    INTO v_exists
    FROM USERS
    WHERE USER_ID = p_driver_id
      AND STATUS = 'ACTIVE'
      AND ROLE_ID = v_driver_role_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Водитель не активен, не существует или не имеет роль DRIVER.');
        RETURN;
    END IF;

    -- 5. Проверка занятости водителя
    SELECT COUNT(*)
    INTO v_exists
    FROM TRAVELS
    WHERE DRIVER_ID = p_driver_id
      AND STATUS = 'OK'
      AND DEPARTURE_DATE < p_arrival
      AND ARRIVAL_DATE   > p_departure;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Водитель занят в указанный период.');
        RETURN;
    END IF;

    -- 6. Добавление поездки
    INSERT INTO TRAVELS(
        ROUTE_ID, VEHICLE_ID, DRIVER_ID,
        DEPARTURE_DATE, ARRIVAL_DATE,
        STATUS, PRICE
    )
    VALUES (
        p_route_id, p_vehicle_id, p_driver_id,
        p_departure, p_arrival,
        p_status, p_price
    )
    RETURNING TRAVEL_ID INTO v_new_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Поездка успешно добавлена: ID=' || v_new_id ||
        ', Маршрут=' || p_route_id ||
        ', Транспорт=' || p_vehicle_id ||
        ', Водитель=' || p_driver_id ||
        ', Цена=' || p_price
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении поездки: ' || SQLERRM);
END;
/





--ИЗМЕНЕНИЕ ПОЕЗДКИ
CREATE OR REPLACE PROCEDURE UPDATE_TRAVEL(
    p_travel_id   IN TRAVELS.TRAVEL_ID%TYPE,
    p_route_id    IN TRAVELS.ROUTE_ID%TYPE,
    p_vehicle_id  IN TRAVELS.VEHICLE_ID%TYPE,
    p_driver_id   IN TRAVELS.DRIVER_ID%TYPE,
    p_departure   IN TRAVELS.DEPARTURE_DATE%TYPE,
    p_arrival     IN TRAVELS.ARRIVAL_DATE%TYPE,
    p_price       IN NUMBER,
    p_status      IN TRAVELS.STATUS%TYPE
) AS
    v_exists        NUMBER;
    v_duplicate     NUMBER;
    v_driver_role_id NUMBER;
    v_current_departure TRAVELS.DEPARTURE_DATE%TYPE;
BEGIN

    -- 0. Проверка, что дата начала поездки ещё не наступила
    SELECT DEPARTURE_DATE
    INTO v_current_departure
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    IF v_current_departure < SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Нельзя изменять поездку, которая уже началась.');
        RETURN;
    END IF;

    -- 1. Проверка существования поездки
    SELECT COUNT(*) INTO v_exists
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Поездка с ID=' || p_travel_id || ' не найдена.');
        RETURN;
    END IF;

    -- 2. Проверка водителя: активен и имеет роль DRIVER
    BEGIN
        SELECT ROLE_ID INTO v_driver_role_id
        FROM ROLES
        WHERE ROLE_NAME = 'DRIVER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль DRIVER не найдена.');
            RETURN;
    END;

    SELECT COUNT(*) INTO v_exists
    FROM USERS
    WHERE USER_ID = p_driver_id
      AND STATUS = 'ACTIVE'
      AND ROLE_ID = v_driver_role_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Водитель не найден, не активен или не имеет роль DRIVER.');
        RETURN;
    END IF;

    -- 3. Проверка корректности временного интервала
    IF p_arrival <= p_departure THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Время прибытия должно быть позже времени отправления.');
        RETURN;
    END IF;

    -- 4. Проверка на дубликат поездки (кроме текущей)
    SELECT COUNT(*) INTO v_duplicate
    FROM TRAVELS
    WHERE ROUTE_ID = p_route_id
      AND VEHICLE_ID = p_vehicle_id
      AND DRIVER_ID = p_driver_id
      AND DEPARTURE_DATE = p_departure
      AND ARRIVAL_DATE = p_arrival
      AND STATUS = p_status
      AND PRICE = p_price
      AND TRAVEL_ID <> p_travel_id;

    IF v_duplicate > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Такая поездка уже существует.');
        RETURN;
    END IF;

    -- 5. Проверка занятости транспортного средства
    SELECT COUNT(*) INTO v_exists
    FROM TRAVELS
    WHERE VEHICLE_ID = p_vehicle_id
      AND STATUS = 'OK'
      AND TRAVEL_ID <> p_travel_id
      AND DEPARTURE_DATE < p_arrival
      AND ARRIVAL_DATE   > p_departure;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Транспортное средство занято в указанный период.');
        RETURN;
    END IF;

    -- 6. Проверка занятости водителя
    SELECT COUNT(*) INTO v_exists
    FROM TRAVELS
    WHERE DRIVER_ID = p_driver_id
      AND STATUS = 'OK'
      AND TRAVEL_ID <> p_travel_id
      AND DEPARTURE_DATE < p_arrival
      AND ARRIVAL_DATE   > p_departure;

    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Водитель занят в указанный период.');
        RETURN;
    END IF;

    -- 7. Обновление поездки
    UPDATE TRAVELS
    SET ROUTE_ID       = p_route_id,
        VEHICLE_ID     = p_vehicle_id,
        DRIVER_ID      = p_driver_id,
        DEPARTURE_DATE = p_departure,
        ARRIVAL_DATE   = p_arrival,
        STATUS         = p_status,
        PRICE          = p_price
    WHERE TRAVEL_ID = p_travel_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Поездка успешно обновлена: ID=' || p_travel_id ||
        ', Маршрут=' || p_route_id ||
        ', Транспорт=' || p_vehicle_id ||
        ', Водитель=' || p_driver_id ||
        ', Отправление=' || TO_CHAR(p_departure, 'YYYY-MM-DD HH24:MI') ||
        ', Прибытие='   || TO_CHAR(p_arrival, 'YYYY-MM-DD HH24:MI') ||
        ', Статус='    || p_status ||
        ', Цена='      || p_price
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении поездки: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE DELETE_TRAVEL(
    p_travel_id IN TRAVELS.TRAVEL_ID%TYPE
) AS
    v_travel_exists   NUMBER;
    v_booking_count   NUMBER;
    v_travel_status   TRAVELS.STATUS%TYPE;
BEGIN
    -- 1. Проверяем существование поездки
    SELECT COUNT(*)
    INTO v_travel_exists
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    IF v_travel_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Поездка с ID=' || p_travel_id || ' не найдена.');
        RETURN;
    END IF;

    -- 2. Получаем статус поездки
    SELECT STATUS
    INTO v_travel_status
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    -- 3. Считаем бронирования
    SELECT COUNT(*)
    INTO v_booking_count
    FROM BOOKINGS
    WHERE TRAVEL_ID = p_travel_id;

    -- 4. Если есть бронирования и поездка активна → отменяем
    IF v_booking_count > 0 AND v_travel_status = 'OK' THEN

        UPDATE TRAVELS
        SET STATUS = 'CANCELED'
        WHERE TRAVEL_ID = p_travel_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Поездка ID=' || p_travel_id ||
            ' отменена (есть бронирования).'
        );

    -- 5. Если бронирований нет → удаляем
    ELSIF v_booking_count = 0 THEN

        DELETE FROM TRAVELS
        WHERE TRAVEL_ID = p_travel_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Поездка ID=' || p_travel_id ||
            ' успешно удалена (бронирований нет).'
        );

    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'Поездка ID=' || p_travel_id ||
            ' уже имеет статус: ' || v_travel_status
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении поездки: ' || SQLERRM);
END;
/

--Добавление ТС
CREATE OR REPLACE PROCEDURE ADD_VEHICLE(
    p_reg_number IN VEHICLES.REG_NUMBER%TYPE,
    p_model      IN VEHICLES.MODEL%TYPE,
    p_capacity   IN VEHICLES.CAPACITY%TYPE,
    p_status     IN VEHICLES.STATUS%TYPE DEFAULT 'OK'
) AS
    v_new_id VEHICLES.VEHICLE_ID%TYPE;
BEGIN
    -- Проверка на дублирование регистрационного номера
    FOR v_dup IN (SELECT 1 FROM VEHICLES WHERE REG_NUMBER = p_reg_number) LOOP
        DBMS_OUTPUT.PUT_LINE('Ошибка: Транспорт с регистрационным номером "' || p_reg_number || '" уже существует.');
        RETURN;
    END LOOP;

    INSERT INTO VEHICLES(REG_NUMBER, MODEL, CAPACITY, STATUS)
    VALUES (p_reg_number, p_model, p_capacity, p_status)
    RETURNING VEHICLE_ID INTO v_new_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Транспорт успешно добавлен: ID=' || v_new_id || ', Рег.номер=' || p_reg_number || ', Модель=' || p_model);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении транспорта: ' || SQLERRM);
END;
/

--Изменение ТС
CREATE OR REPLACE PROCEDURE UPDATE_VEHICLE(
    p_vehicle_id IN VEHICLES.VEHICLE_ID%TYPE,
    p_reg_number IN VEHICLES.REG_NUMBER%TYPE,
    p_model      IN VEHICLES.MODEL%TYPE,
    p_capacity   IN VEHICLES.CAPACITY%TYPE
) AS
    v_exists NUMBER;
BEGIN
    -- Проверка существования транспорта
    SELECT COUNT(*) INTO v_exists
    FROM VEHICLES
    WHERE VEHICLE_ID = p_vehicle_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Транспорт с ID=' || p_vehicle_id || ' не найден.');
        RETURN;
    END IF;

    -- Обновление транспорта
    UPDATE VEHICLES
    SET REG_NUMBER = p_reg_number,
        MODEL      = p_model,
        CAPACITY   = p_capacity,
        STATUS     = 'OK'  -- Статус всегда OK
    WHERE VEHICLE_ID = p_vehicle_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Транспорт успешно обновлен: ID=' || p_vehicle_id || 
                         ', Рег.номер=' || p_reg_number || 
                         ', Модель=' || p_model);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении транспорта: ' || SQLERRM);
END;
/


--Удаление ТС
CREATE OR REPLACE PROCEDURE DELETE_VEHICLE(
    p_vehicle_id IN VEHICLES.VEHICLE_ID%TYPE
) AS
    v_exists        NUMBER;
    v_active_travel NUMBER;
BEGIN
    -- 1. Проверка существования транспорта
    SELECT COUNT(*)
    INTO v_exists
    FROM VEHICLES
    WHERE VEHICLE_ID = p_vehicle_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Транспорт с ID=' || p_vehicle_id || ' не найден.'
        );
        RETURN;
    END IF;

    -- 2. Проверка активных поездок
    SELECT COUNT(*)
    INTO v_active_travel
    FROM TRAVELS
    WHERE VEHICLE_ID = p_vehicle_id
      AND ARRIVAL_DATE > SYSDATE;

    IF v_active_travel > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Данное транспортное средство принадлежит к активным TRAVELS. ' ||
            'Измените данные TRAVELS.'
        );
        RETURN;
    END IF;

    -- 3. Удаление транспорта
    DELETE FROM VEHICLES
    WHERE VEHICLE_ID = p_vehicle_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Транспорт успешно удалён: ID=' || p_vehicle_id
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка при удалении транспорта: ' || SQLERRM
        );
END;
/


-- Изменение статуса транспортного средства
CREATE OR REPLACE PROCEDURE SET_VEHICLE_STATUS (
    p_vehicle_id IN VEHICLES.VEHICLE_ID%TYPE,
    p_status     IN VARCHAR2
)
AS
    v_exists        NUMBER;
    v_active_travels NUMBER;
    v_status_clean  VARCHAR2(20);
BEGIN
    -- Нормализация статуса
    v_status_clean := UPPER(TRIM(p_status));

    -- Проверка существования ТС
    SELECT COUNT(*) INTO v_exists
    FROM VEHICLES
    WHERE VEHICLE_ID = p_vehicle_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Транспорт с ID=' || p_vehicle_id || ' не найден.');
        RETURN;
    END IF;

    -- Проверка корректности статуса
    IF v_status_clean NOT IN ('OK', 'IN_SERVICE', 'REPAIR') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Статус должен быть OK, IN_SERVICE или REPAIR.');
        RETURN;
    END IF;

    -- Если хотим поставить IN_SERVICE — проверяем активные рейсы
    IF v_status_clean = 'IN_SERVICE' THEN
        SELECT COUNT(*) INTO v_active_travels
        FROM TRAVELS
        WHERE VEHICLE_ID = p_vehicle_id
          AND STATUS = 'OK';

        IF v_active_travels > 0 THEN
            DBMS_OUTPUT.PUT_LINE(
                'Ошибка: За данным транспортом закреплены активные рейсы.' ||
                ' Сначала измените транспортное средство в рейсах.'
            );
            RETURN;
        END IF;
    END IF;

    -- Обновление статуса
    UPDATE VEHICLES
    SET STATUS = v_status_clean
    WHERE VEHICLE_ID = p_vehicle_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Статус транспорта изменён: ID=' || p_vehicle_id ||
        ' → ' || v_status_clean
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка изменения статуса транспорта: ' || SQLERRM);
END;
/




CREATE OR REPLACE PROCEDURE ADD_BOOKING(
    p_travel_id IN BOOKINGS.TRAVEL_ID%TYPE,
    p_user_id   IN BOOKINGS.USER_ID%TYPE
) AS
    v_new_id        BOOKINGS.BOOKING_ID%TYPE;
    v_exists        NUMBER;
    v_capacity      NUMBER;
    v_booked_count  NUMBER;
    v_departure_date  TRAVELS.ARRIVAL_DATE%TYPE;
BEGIN
    -- 1. Проверка существования рейса
    SELECT COUNT(*) INTO v_exists
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Рейс с ID=' || p_travel_id || ' не существует.');
        RETURN;
    END IF;

    -- 2. Проверка существования пользователя и его статуса
    SELECT COUNT(*) INTO v_exists
    FROM USERS
    WHERE USER_ID = p_user_id
      AND STATUS = 'ACTIVE';

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь не существует или заблокирован.');
        RETURN;
    END IF;

    -- 3. Проверяем, что рейс ещё не завершён
    SELECT DEPARTURE_DATE
    INTO v_departure_date
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    IF SYSDATE > v_departure_date THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Транспортное средство уже отправилось.');
        RETURN;
    END IF;

    -- 4. Проверка вместимости транспортного средства
    SELECT v.CAPACITY
    INTO v_capacity
    FROM TRAVELS t
    JOIN VEHICLES v ON t.VEHICLE_ID = v.VEHICLE_ID
    WHERE t.TRAVEL_ID = p_travel_id;

    SELECT COUNT(*) 
    INTO v_booked_count
    FROM BOOKINGS
    WHERE TRAVEL_ID = p_travel_id
      AND STATUS = 'BOOKED';

    IF v_booked_count >= v_capacity THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Рейс полностью забронирован. Вместимость: ' || v_capacity
        );
        RETURN;
    END IF;

    -- 5. Добавление бронирования
    INSERT INTO BOOKINGS(TRAVEL_ID, USER_ID, STATUS)
    VALUES (p_travel_id, p_user_id, 'BOOKED')
    RETURNING BOOKING_ID INTO v_new_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Бронирование успешно добавлено: ID=' || v_new_id ||
        ', Рейс=' || p_travel_id ||
        ', Пользователь=' || p_user_id
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении бронирования: ' || SQLERRM);
END;
/




drop procedure update_booking




CREATE OR REPLACE PROCEDURE DELETE_BOOKING(
    p_booking_id IN BOOKINGS.BOOKING_ID%TYPE,
    p_user_id    IN BOOKINGS.USER_ID%TYPE
) AS
    v_booking_status BOOKINGS.STATUS%TYPE;
    v_owner_id       BOOKINGS.USER_ID%TYPE;
BEGIN
    -- 1. Получаем статус и владельца бронирования
    SELECT STATUS, USER_ID
    INTO v_booking_status, v_owner_id
    FROM BOOKINGS
    WHERE BOOKING_ID = p_booking_id;

    -- 2. Проверяем владельца
    IF v_owner_id <> p_user_id THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Бронирование не принадлежит пользователю ID=' || p_user_id
        );
        RETURN;
    END IF;

    -- 3. Проверяем статус
    IF v_booking_status <> 'BOOKED' THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Нельзя удалить бронирование со статусом "' ||
            v_booking_status || '".'
        );
        RETURN;
    END IF;

    -- 4. Удаляем бронирование
    DELETE FROM BOOKINGS
    WHERE BOOKING_ID = p_booking_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Бронирование ID=' || p_booking_id ||
        ' пользователя ID=' || p_user_id ||
        ' успешно удалено.'
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Бронирование не найдено.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении бронирования: ' || SQLERRM);
END;
/




--Получение всех
CREATE OR REPLACE PROCEDURE GET_ALL_ROLES AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ALL ROLES ===');

    FOR r IN (SELECT ROLE_ID, ROLE_NAME FROM ROLES ORDER BY ROLE_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('ID=' || r.ROLE_ID || ', Name=' || r.ROLE_NAME);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка получения ролей: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE GET_ALL_USERS AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== USERS  ===');

    FOR u IN (
        SELECT U.USER_ID,
               U.LOGIN,
               U.FULL_NAME,
               U.PHONE,
               U.STATUS,
               R.ROLE_NAME
        FROM USERS U
        JOIN ROLES R ON U.ROLE_ID = R.ROLE_ID
        WHERE R.ROLE_NAME = 'USER' 
        ORDER BY U.USER_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || u.USER_ID ||
            ', Login=' || u.LOGIN ||
            ', Name=' || u.FULL_NAME ||
            ', Phone=' || u.PHONE ||
            ', Status=' || u.STATUS ||
            ', Role=' || u.ROLE_NAME
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка получения пользователей: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE GET_ALL_ADMINS AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ADMINS  ===');

    FOR u IN (
        SELECT U.USER_ID,
               U.LOGIN,
               U.FULL_NAME,
               U.PHONE,
               U.STATUS,
               R.ROLE_NAME
        FROM USERS U
        JOIN ROLES R ON U.ROLE_ID = R.ROLE_ID
        WHERE R.ROLE_NAME = 'ADMIN'
        ORDER BY U.USER_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || u.USER_ID ||
            ', Login=' || u.LOGIN ||
            ', Name=' || u.FULL_NAME ||
            ', Phone=' || u.PHONE ||
            ', Status=' || u.STATUS ||
            ', Role=' || u.ROLE_NAME
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка получения администраторов: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE GET_ALL_DRIVERS AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== DRIVERS ===');

    FOR u IN (
        SELECT U.USER_ID,
               U.LOGIN,
               U.FULL_NAME,
               U.PHONE,
               U.STATUS,
               R.ROLE_NAME
        FROM USERS U
        JOIN ROLES R ON U.ROLE_ID = R.ROLE_ID
        WHERE R.ROLE_NAME = 'DRIVER'   -- ✔ Только обычные пользователи
        ORDER BY U.USER_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || u.USER_ID ||
            ', Login=' || u.LOGIN ||
            ', Name=' || u.FULL_NAME ||
            ', Phone=' || u.PHONE ||
            ', Status=' || u.STATUS ||
            ', Role=' || u.ROLE_NAME
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка получения водителей: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE GET_ALL_VEHICLES AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ALL VEHICLES ===');

    FOR v IN (
        SELECT VEHICLE_ID, REG_NUMBER, MODEL, CAPACITY, STATUS
        FROM VEHICLES ORDER BY VEHICLE_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || v.VEHICLE_ID ||
            ', Reg=' || v.REG_NUMBER ||
            ', Model=' || v.MODEL ||
            ', Capacity=' || v.CAPACITY ||
            ', Status=' || v.STATUS
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка получения транспорта: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE GET_ALL_ROUTES AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ALL ROUTES ===');

    FOR r IN (
        SELECT ROUTE_ID, START_POINT, END_POINT, DISTANCE_KM
        FROM ROUTES ORDER BY ROUTE_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || r.ROUTE_ID ||
            ', From=' || r.START_POINT ||
            ', To=' || r.END_POINT ||
            ', Distance=' || r.DISTANCE_KM || ' km'
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка получения маршрутов: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE GET_ALL_TRAVELS AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ALL TRAVELS ===');

    FOR t IN (
        SELECT tr.TRAVEL_ID, 
               r.START_POINT || ' → ' || r.END_POINT AS ROUTE_NAME,
               v.MODEL || ' (' || v.REG_NUMBER || ')' AS VEHICLE_INFO,
               u.FULL_NAME AS DRIVER_NAME,
               tr.DEPARTURE_DATE, tr.ARRIVAL_DATE, tr.STATUS, tr.PRICE
        FROM TRAVELS tr
        JOIN ROUTES r ON tr.ROUTE_ID = r.ROUTE_ID
        JOIN VEHICLES v ON tr.VEHICLE_ID = v.VEHICLE_ID
        JOIN USERS u ON tr.DRIVER_ID = u.USER_ID
        ORDER BY tr.TRAVEL_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || t.TRAVEL_ID ||
            ', Route=' || t.ROUTE_NAME ||
            ', Vehicle=' || t.VEHICLE_INFO ||
            ', Driver=' || t.DRIVER_NAME ||
            ', Departure=' || TO_CHAR(t.DEPARTURE_DATE, 'YYYY-MM-DD HH24:MI') ||
            ', Arrival=' || TO_CHAR(t.ARRIVAL_DATE, 'YYYY-MM-DD HH24:MI') ||
            ', Status=' || t.STATUS ||
            ', Price=' || NVL(TO_CHAR(t.PRICE, '999999.99'), 'N/A')
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при получении списка поездок: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE GET_ALL_BOOKINGS AS
BEGIN
    UPDATE_EXPIRED_BOOKINGS();
    DBMS_OUTPUT.PUT_LINE('=== ALL BOOKINGS ===');

    FOR b IN (
        SELECT BOOKING_ID, TRAVEL_ID, USER_ID, BOOKING_DATE, STATUS
        FROM BOOKINGS ORDER BY BOOKING_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || b.BOOKING_ID ||
            ', Travel=' || b.TRAVEL_ID ||
            ', User=' || b.USER_ID ||
            ', Date=' || TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD HH24:MI:SS') ||
            ', Status=' || b.STATUS
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error fetching bookings: ' || SQLERRM);
END;
/



---------------------------------------------------------------------------



--ВОДИТЕЛЬ
--ОБНОВЛЕНИЕ СТАТУСОВ БРОНИРОВАНИЙ ЛОГИКА
CREATE OR REPLACE PROCEDURE UPDATE_EXPIRED_BOOKINGS AS
BEGIN
    -- BOOKED → NO_SHOW, если время отправления прошло
    UPDATE BOOKINGS b
    SET b.STATUS = 'NO_SHOW'
    WHERE b.STATUS = 'BOOKED'
      AND EXISTS (
            SELECT 1
            FROM TRAVELS t
            WHERE t.TRAVEL_ID = b.TRAVEL_ID
              AND t.DEPARTURE_DATE <= SYSDATE
      );

    -- SHOW → COMPLETED, если время прибытия прошло
    UPDATE BOOKINGS b
    SET b.STATUS = 'COMPLETED'
    WHERE b.STATUS = 'SHOW'
      AND EXISTS (
            SELECT 1
            FROM TRAVELS t
            WHERE t.TRAVEL_ID = b.TRAVEL_ID
              AND t.ARRIVAL_DATE <= SYSDATE
      );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении статусов бронирований: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE GET_TRAVELS_BY_DRIVER(
    p_driver_id IN TRAVELS.DRIVER_ID%TYPE
) AS
    v_exists         NUMBER;
    v_driver_role_id NUMBER;
BEGIN
    -- Проверка роли DRIVER
    BEGIN
        SELECT ROLE_ID
        INTO v_driver_role_id
        FROM ROLES
        WHERE ROLE_NAME = 'DRIVER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка: Роль DRIVER не найдена.');
            RETURN;
    END;

    SELECT COUNT(*)
    INTO v_exists
    FROM USERS
    WHERE USER_ID = p_driver_id
      AND STATUS = 'ACTIVE'
      AND ROLE_ID = v_driver_role_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь не существует, заблокирован или не является водителем.');
        RETURN;
    END IF;

    -- Проверяем, есть ли поездки у водителя
    SELECT COUNT(*)
    INTO v_exists
    FROM TRAVELS
    WHERE DRIVER_ID = p_driver_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Поездки для водителя с ID=' || p_driver_id || ' не найдены.');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== Поездки водителя ID=' || p_driver_id || ' ===');

    FOR t IN (
        SELECT TRAVEL_ID, ROUTE_ID, VEHICLE_ID,
               DEPARTURE_DATE, ARRIVAL_DATE,
               STATUS, PRICE
        FROM TRAVELS
        WHERE DRIVER_ID = p_driver_id
        ORDER BY DEPARTURE_DATE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID=' || t.TRAVEL_ID ||
            ', Маршрут=' || t.ROUTE_ID ||
            ', Транспорт=' || t.VEHICLE_ID ||
            ', Отправление=' || TO_CHAR(t.DEPARTURE_DATE, 'YYYY-MM-DD HH24:MI') ||
            ', Прибытие=' || TO_CHAR(t.ARRIVAL_DATE, 'YYYY-MM-DD HH24:MI') ||
            ', Статус=' || t.STATUS ||
            ', Цена=' || t.PRICE
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при получении поездок водителя: ' || SQLERRM);
END;
/


--Изменение статуса БРОНИРОВАНИЯ
CREATE OR REPLACE PROCEDURE UPDATE_BOOKING_STATUS(
    p_booking_id  IN BOOKINGS.BOOKING_ID%TYPE,
    p_new_status  IN BOOKINGS.STATUS%TYPE
) AS
    v_exists NUMBER;
BEGIN
    UPDATE_EXPIRED_BOOKINGS();
    
    -- 1. Проверяем, существует ли бронирование
    SELECT COUNT(*) INTO v_exists
    FROM BOOKINGS
    WHERE BOOKING_ID = p_booking_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Бронирование с ID=' || p_booking_id || ' не найдено.');
        RETURN;
    END IF;

    -- 2. Проверяем корректность статуса (табличное ограничение уже есть)
    IF p_new_status NOT IN ('BOOKED', 'SHOW') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимый статус бронирования: ' || p_new_status);
        RETURN;
    END IF;

    -- 3. Обновляем статус
    UPDATE BOOKINGS
    SET STATUS = p_new_status
    WHERE BOOKING_ID = p_booking_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Статус бронирования ID=' || p_booking_id ||
        ' успешно изменён на: ' || p_new_status
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при изменении статуса бронирования: ' || SQLERRM);
END;
/

--Получение списка ПАССАЖИРОВ
CREATE OR REPLACE PROCEDURE GET_USERS_BY_TRAVEL(
    p_travel_id IN BOOKINGS.TRAVEL_ID%TYPE
) AS
    v_exists NUMBER;
BEGIN
    -- 1. Проверяем, существуют ли бронирования на эту поездку
    SELECT COUNT(*)
    INTO v_exists
    FROM BOOKINGS
    WHERE TRAVEL_ID = p_travel_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'На поездку ID=' || p_travel_id || ' никто не забронировал билеты.'
        );
        RETURN;
    END IF;

    -- 2. Вывод всех пользователей, забронировавших поездку
    DBMS_OUTPUT.PUT_LINE('=== USERS FOR TRAVEL ID=' || p_travel_id || ' ===');

    FOR r IN (
        SELECT 
            b.BOOKING_ID,
            u.USER_ID,
            u.FULL_NAME,
            u.PHONE,
            b.STATUS,
            TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD HH24:MI') AS BOOKED_AT
        FROM BOOKINGS b
        JOIN USERS u ON u.USER_ID = b.USER_ID
        WHERE b.TRAVEL_ID = p_travel_id
        ORDER BY b.BOOKING_DATE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'BookingID=' || r.BOOKING_ID ||
            ', UserID=' || r.USER_ID ||
            ', Name=' || r.FULL_NAME ||
            ', Phone=' || r.PHONE ||
            ', Status=' || r.STATUS ||
            ', BookingDate=' || r.BOOKED_AT
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при получении пользователей: ' || SQLERRM);
END;
/


---------------------------------------------------------------------

-- ПОЛЬЗОВАТЕЛИ
CREATE OR REPLACE PROCEDURE GET_USER_BOOKINGS(
    p_user_id IN USERS.USER_ID%TYPE
) AS
    v_count NUMBER;
BEGIN
    UPDATE_EXPIRED_BOOKINGS();
    -- Проверка: пользователь существует и не заблокирован
    SELECT COUNT(*)
    INTO v_count
    FROM USERS
    WHERE USER_ID = p_user_id
      AND STATUS = 'ACTIVE';

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Пользователь не существует или заблокирован.');
        RETURN;
    END IF;

    -- Проверка наличия активных бронирований
    SELECT COUNT(*)
    INTO v_count
    FROM BOOKINGS
    WHERE USER_ID = p_user_id
      AND STATUS IN ('BOOKED', 'SHOW');

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('У пользователя нет активных бронирований.');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== ACTIVE BOOKINGS FOR USER ID=' || p_user_id || ' ===');

    FOR r IN (
        SELECT 
            b.BOOKING_ID,
            b.STATUS AS BOOKING_STATUS,
            TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD HH24:MI') AS BOOKED_AT,

            t.TRAVEL_ID,
            TO_CHAR(t.DEPARTURE_DATE, 'YYYY-MM-DD HH24:MI') AS DEP_TIME,
            TO_CHAR(t.ARRIVAL_DATE, 'YYYY-MM-DD HH24:MI') AS ARR_TIME,
            t.STATUS AS TRAVEL_STATUS,
            t.PRICE,

            rt.START_POINT,
            rt.END_POINT,
            rt.DISTANCE_KM,

            u.FULL_NAME AS DRIVER_NAME,
            v.MODEL AS VEHICLE_MODEL,
            v.REG_NUMBER
        FROM BOOKINGS b
        JOIN TRAVELS t ON t.TRAVEL_ID = b.TRAVEL_ID
        JOIN ROUTES rt ON rt.ROUTE_ID = t.ROUTE_ID
        LEFT JOIN USERS u ON u.USER_ID = t.DRIVER_ID
        LEFT JOIN VEHICLES v ON v.VEHICLE_ID = t.VEHICLE_ID
        WHERE b.USER_ID = p_user_id
          AND b.STATUS IN ('BOOKED', 'SHOW')
        ORDER BY b.BOOKING_DATE DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'BookingID=' || r.BOOKING_ID ||
            ', Status=' || r.BOOKING_STATUS ||
            ', Date=' || r.BOOKED_AT ||
            ', TravelID=' || r.TRAVEL_ID ||
            ', Route=' || r.START_POINT || ' → ' || r.END_POINT ||
            ', Departure=' || r.DEP_TIME ||
            ', Arrival=' || r.ARR_TIME ||
            ', TravelStatus=' || r.TRAVEL_STATUS ||
            ', Price=' || r.PRICE ||
            ', Driver=' || NVL(r.DRIVER_NAME, 'N/A') ||
            ', Vehicle=' || NVL(r.VEHICLE_MODEL, 'N/A') || ' #' || NVL(r.REG_NUMBER, '-')
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/

-- Истроия бронирований конкретного пользователя
CREATE OR REPLACE PROCEDURE GET_HISTORY_USER_BOOKINGS(
    p_user_id IN USERS.USER_ID%TYPE
) AS
    v_count NUMBER;
BEGIN
    UPDATE_EXPIRED_BOOKINGS();
    -- Проверяем существование отменённых бронирований
    SELECT COUNT(*) INTO v_count
    FROM BOOKINGS
    WHERE USER_ID = p_user_id;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('История пуста.');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== История брониорваний для пользователя ID=' || p_user_id || ' ===');

    FOR r IN (
        SELECT 
            b.BOOKING_ID,
            b.STATUS AS BOOKING_STATUS,
            TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD HH24:MI') AS BOOKED_AT,
            
            t.TRAVEL_ID,
            TO_CHAR(t.DEPARTURE_DATE, 'YYYY-MM-DD HH24:MI') AS DEP_TIME,
            TO_CHAR(t.ARRIVAL_DATE, 'YYYY-MM-DD HH24:MI') AS ARR_TIME,
            t.STATUS AS TRAVEL_STATUS,
            t.PRICE,

            rt.START_POINT,
            rt.END_POINT,
            rt.DISTANCE_KM,

            u.FULL_NAME AS DRIVER_NAME,
            v.MODEL AS VEHICLE_MODEL,
            v.REG_NUMBER
        FROM BOOKINGS b
        JOIN TRAVELS t ON t.TRAVEL_ID = b.TRAVEL_ID
        JOIN ROUTES rt ON rt.ROUTE_ID = t.ROUTE_ID
        LEFT JOIN USERS u ON u.USER_ID = t.DRIVER_ID
        LEFT JOIN VEHICLES v ON v.VEHICLE_ID = t.VEHICLE_ID
        WHERE b.USER_ID = p_user_id
          AND b.STATUS IN ('NO_SHOW', 'COMPLETED')
        ORDER BY b.BOOKING_DATE DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'BookingID=' || r.BOOKING_ID ||
            ', Status=' || r.BOOKING_STATUS ||
            ', Date=' || r.BOOKED_AT ||
            ', TravelID=' || r.TRAVEL_ID ||
            ', Route=' || r.START_POINT || ' → ' || r.END_POINT ||
            ', Departure=' || r.DEP_TIME ||
            ', Arrival=' || r.ARR_TIME ||
            ', TravelStatus=' || r.TRAVEL_STATUS ||
            ', Price=' || r.PRICE ||
            ', Driver=' || NVL(r.DRIVER_NAME, 'N/A') ||
            ', Vehicle=' || NVL(r.VEHICLE_MODEL, 'N/A') || ' #' || NVL(r.REG_NUMBER, '-')
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE SORT_TRAVELS_BY_DATE_ROUTE_A(
    p_date_from   IN DATE,
    p_date_to     IN DATE,
    p_start_point IN ROUTES.START_POINT%TYPE DEFAULT NULL,
    p_end_point   IN ROUTES.END_POINT%TYPE DEFAULT NULL,
    p_order       IN VARCHAR2 DEFAULT 'ASC'
) AS
    v_order VARCHAR2(4);
BEGIN
    -- Проверка корректности диапазона
    IF p_date_from > p_date_to THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: p_date_from не может быть больше p_date_to');
        RETURN;
    END IF;

    -- Проверка направления сортировки
    v_order := UPPER(p_order);
    IF v_order NOT IN ('ASC', 'DESC') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: p_order должен быть ASC или DESC');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== TRAVELS FROM ' ||
        TO_CHAR(p_date_from, 'YYYY-MM-DD HH24:MI') ||
        ' TO ' ||
        TO_CHAR(p_date_to, 'YYYY-MM-DD HH24:MI') ||
        ' ORDER ' || v_order ||
        NVL2(p_start_point, ', Start=' || p_start_point, '') ||
        NVL2(p_end_point, ', End=' || p_end_point, '') ||
        ' ===');

    FOR r IN (
        SELECT 
            t.TRAVEL_ID,
            TO_CHAR(t.DEPARTURE_DATE, 'YYYY-MM-DD HH24:MI') AS DEP_TIME,
            TO_CHAR(t.ARRIVAL_DATE, 'YYYY-MM-DD HH24:MI') AS ARR_TIME,
            rt.START_POINT,
            rt.END_POINT,
            t.STATUS,
            t.PRICE
        FROM TRAVELS t
        JOIN ROUTES rt ON rt.ROUTE_ID = t.ROUTE_ID
        WHERE t.STATUS = 'OK'
          AND t.DEPARTURE_DATE BETWEEN p_date_from AND p_date_to
          AND (p_start_point IS NULL OR rt.START_POINT = p_start_point)
          AND (p_end_point IS NULL OR rt.END_POINT = p_end_point)
        ORDER BY 
            CASE WHEN v_order = 'ASC'  THEN t.DEPARTURE_DATE END ASC,
            CASE WHEN v_order = 'DESC' THEN t.DEPARTURE_DATE END DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'TravelID=' || r.TRAVEL_ID ||
            ', ' || r.START_POINT || ' → ' || r.END_POINT ||
            ', Departure=' || r.DEP_TIME ||
            ', Arrival=' || r.ARR_TIME ||
            ', Status=' || r.STATUS ||
            ', Price=' || r.PRICE
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при сортировке рейсов: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE SORT_TRAVELS_BY_DATE_ROUTE(
    p_date_from   IN DATE,
    p_date_to     IN DATE,
    p_start_point IN ROUTES.START_POINT%TYPE DEFAULT NULL,
    p_end_point   IN ROUTES.END_POINT%TYPE DEFAULT NULL,
    p_order       IN VARCHAR2 DEFAULT 'ASC'
) AS
    v_order VARCHAR2(4);
BEGIN
    -- Проверка корректности диапазона
    IF p_date_from > p_date_to THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: p_date_from не может быть больше p_date_to');
        RETURN;
    END IF;

    -- Проверка направления сортировки
    v_order := UPPER(p_order);
    IF v_order NOT IN ('ASC', 'DESC') THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: p_order должен быть ASC или DESC');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== TRAVELS FROM ' ||
        TO_CHAR(p_date_from, 'YYYY-MM-DD HH24:MI') ||
        ' TO ' ||
        TO_CHAR(p_date_to, 'YYYY-MM-DD HH24:MI') ||
        ' ORDER ' || v_order ||
        NVL2(p_start_point, ', Start=' || p_start_point, '') ||
        NVL2(p_end_point, ', End=' || p_end_point, '') ||
        ' ===');

    FOR r IN (
        SELECT 
            t.TRAVEL_ID,
            TO_CHAR(t.DEPARTURE_DATE, 'YYYY-MM-DD HH24:MI') AS DEP_TIME,
            TO_CHAR(t.ARRIVAL_DATE, 'YYYY-MM-DD HH24:MI') AS ARR_TIME,
            rt.START_POINT,
            rt.END_POINT,
            t.STATUS,
            t.PRICE
        FROM TRAVELS t
        JOIN ROUTES rt ON rt.ROUTE_ID = t.ROUTE_ID
        WHERE t.STATUS = 'OK'
          AND t.DEPARTURE_DATE >= SYSDATE            -- ⬅ не в прошлом
          AND t.DEPARTURE_DATE BETWEEN p_date_from AND p_date_to
          AND (p_start_point IS NULL OR rt.START_POINT = p_start_point)
          AND (p_end_point IS NULL OR rt.END_POINT = p_end_point)
        ORDER BY 
            CASE WHEN v_order = 'ASC'  THEN t.DEPARTURE_DATE END ASC,
            CASE WHEN v_order = 'DESC' THEN t.DEPARTURE_DATE END DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'TravelID=' || r.TRAVEL_ID ||
            ', ' || r.START_POINT || ' → ' || r.END_POINT ||
            ', Departure=' || r.DEP_TIME ||
            ', Arrival=' || r.ARR_TIME ||
            ', Status=' || r.STATUS ||
            ', Price=' || r.PRICE
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при сортировке рейсов: ' || SQLERRM);
END;
/

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- СТАТИСТИКА

CREATE OR REPLACE PROCEDURE GET_MOST_POPULAR_ROUTES AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== MOST POPULAR ROUTES ===');

    FOR r IN (
        SELECT 
            rt.START_POINT,
            rt.END_POINT,
            SUM(s.PASSENGERS_COUNT) AS TOTAL_PASSENGERS
        FROM STATISTICS s
        JOIN TRAVELS t ON t.TRAVEL_ID = s.TRAVEL_ID
        JOIN ROUTES rt ON rt.ROUTE_ID = t.ROUTE_ID
        GROUP BY rt.START_POINT, rt.END_POINT
        ORDER BY TOTAL_PASSENGERS DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            r.START_POINT || ' → ' || r.END_POINT || 
            ', Total Passengers=' || r.TOTAL_PASSENGERS
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при определении популярных маршрутов: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE CALCULATE_REVENUE_BY_PERIOD(
    p_date_from IN DATE,
    p_date_to   IN DATE
) AS
    v_total_revenue NUMBER(12,2);
BEGIN
    -- Проверка корректности диапазона
    IF p_date_from > p_date_to THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Дата начала больше даты окончания.');
        RETURN;
    END IF;

    -- Подсчёт выручки из таблицы STATISTICS
    SELECT NVL(SUM(s.REVENUE), 0) INTO v_total_revenue
    FROM STATISTICS s
    JOIN TRAVELS t ON t.TRAVEL_ID = s.TRAVEL_ID
    WHERE t.DEPARTURE_DATE BETWEEN p_date_from AND p_date_to;

    DBMS_OUTPUT.PUT_LINE(
        'Общая выручка за период с ' ||
        TO_CHAR(p_date_from, 'YYYY-MM-DD') || ' по ' ||
        TO_CHAR(p_date_to, 'YYYY-MM-DD') || ' = ' || v_total_revenue
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при подсчёте выручки: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE CALCULATE_FUEL_BY_MONTH(
    p_year  IN NUMBER,
    p_month IN NUMBER
) AS
    v_total_fuel NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(FUEL_USED), 0)
    INTO v_total_fuel
    FROM STATISTICS s
    JOIN TRAVELS t ON t.TRAVEL_ID = s.TRAVEL_ID
    WHERE EXTRACT(YEAR FROM t.DEPARTURE_DATE) = p_year
      AND EXTRACT(MONTH FROM t.DEPARTURE_DATE) = p_month;

    DBMS_OUTPUT.PUT_LINE(
        'Общий расход топлива за ' || TO_CHAR(TO_DATE(p_month,'MM'),'Month') || ' ' || p_year || ' = ' || v_total_fuel || ' литров'
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при расчёте расхода топлива: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE ADD_STATISTIC(
    p_travel_id    IN STATISTICS.TRAVEL_ID%TYPE,
    p_fuel_used    IN STATISTICS.FUEL_USED%TYPE
) AS
    v_passengers_count NUMBER;
    v_exists NUMBER;
    v_stat_id STATISTICS.STAT_ID%TYPE;
    v_price NUMBER;
    v_revenue NUMBER;
BEGIN
    -- Проверка существования рейса и получение цены
    SELECT PRICE INTO v_price
    FROM TRAVELS
    WHERE TRAVEL_ID = p_travel_id;

    IF v_price IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Рейс с ID=' || p_travel_id || ' не существует.');
        RETURN;
    END IF;

    -- Проверка на отрицательное количество топлива
    IF p_fuel_used < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Расход топлива не может быть отрицательным.');
        RETURN;
    END IF;

    -- Подсчёт пассажиров со статусом COMPLETED
    SELECT COUNT(*) INTO v_passengers_count
    FROM BOOKINGS
    WHERE TRAVEL_ID = p_travel_id
      AND STATUS = 'COMPLETED';

    -- Расчёт дохода
    v_revenue := v_passengers_count * v_price;

    -- Вставка в таблицу STATISTICS
    INSERT INTO STATISTICS(
        TRAVEL_ID,
        REVENUE,
        FUEL_USED,
        PASSENGERS_COUNT
    ) VALUES (
        p_travel_id,
        v_revenue,
        p_fuel_used,
        v_passengers_count
    )
    RETURNING STAT_ID INTO v_stat_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Статистика успешно добавлена: STAT_ID=' || v_stat_id ||
                         ', TRAVEL_ID=' || p_travel_id ||
                         ', Passengers=' || v_passengers_count ||
                         ', Revenue=' || v_revenue ||
                         ', Fuel Used=' || p_fuel_used);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Рейс с ID=' || p_travel_id || ' не найден.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении статистики: ' || SQLERRM);
END;
/





CREATE OR REPLACE PROCEDURE GET_AVG_PASSENGERS_BY_ROUTE (
    p_route_id IN ROUTES.ROUTE_ID%TYPE
) AS
    v_avg_passengers NUMBER;
    v_exists         NUMBER;
BEGIN
    -- 1. Проверка существования маршрута
    SELECT COUNT(*)
    INTO v_exists
    FROM ROUTES
    WHERE ROUTE_ID = p_route_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка: Маршрут с ID=' || p_route_id || ' не существует.'
        );
        RETURN;
    END IF;

    -- 2. Расчёт среднего количества пассажиров и округление до целого
    SELECT ROUND(AVG(s.PASSENGERS_COUNT))
    INTO v_avg_passengers
    FROM STATISTICS s
    JOIN TRAVELS t ON t.TRAVEL_ID = s.TRAVEL_ID
    WHERE t.ROUTE_ID = p_route_id;

    -- 3. Если статистики нет
    IF v_avg_passengers IS NULL THEN
        DBMS_OUTPUT.PUT_LINE(
            'Для маршрута ID=' || p_route_id || ' отсутствует статистика.'
        );
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        'Среднее количество пассажиров на маршруте ID=' ||
        p_route_id || ' = ' || v_avg_passengers
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ошибка при вычислении среднего количества пассажиров: ' || SQLERRM
        );
END;
/




