--АДМИНИСТРАТОР
--РЕГИСТРАЦИЯ
-----------------------------
EXEC ADMINCP.GET_ALL_ADMINS();
EXEC ADMINCP.REGISTER_ADMIN('ADMIN_TEST', '1234', '1234', 'Mandryk Aliaksei', '+375336717655');
EXEC ADMINCP.GET_ALL_ADMINS();
--CRYPTO
SELECT * FROM USERS;

-----------------------------
--РОЛИ
EXEC ADMINCP.GET_ALL_ROLES();

-----------------------------
--ПОЛЬЗОВАТЕЛИ
EXEC ADMINCP.GET_ALL_USERS();
EXEC ADMINCP.GET_ALL_DRIVERS();
EXEC ADMINCP.SET_USER_STATUS('user5', 'BLOCKED');
EXEC ADMINCP.SET_USER_STATUS('user5', 'ACTIVE');
EXEC ADMINCP.GET_ALL_USERS();

-----------------------------
--МАРШРУТЫ
EXEC ADMINCP.GET_ALL_ROUTES();
EXEC ADMINCP.ADD_ROUTE('Минск', 'Несвиж', 120);
EXEC ADMINCP.ADD_ROUTE('Несвиж', 'Минск', 110);
EXEC ADMINCP.GET_ALL_ROUTES();
--
EXEC ADMINCP.UPDATE_ROUTE(8,'Несвиж', 'Минск', 120); 
EXEC ADMINCP.ADD_ROUTE('Несвиж', 'Минск', 110);
EXEC ADMINCP.GET_ALL_ROUTES();

-----------------------------
--ТРАНСПОРТ
EXEC ADMINCP.GET_ALL_VEHICLES();
EXEC ADMINCP.ADD_VEHICLE('GG008-5', 'Volvo', 2);
EXEC ADMINCP.ADD_VEHICLE('HH008-5', 'Scania', 50);
EXEC ADMINCP.ADD_VEHICLE('JJ008-5', 'MAN', 45);
EXEC ADMINCP.GET_ALL_VEHICLES();
--
EXEC ADMINCP.UPDATE_VEHICLE(6, 'GG007-8', 'Volvo', 3);
EXEC ADMINCP.GET_ALL_VEHICLES();
--
EXEC ADMINCP.DELETE_VEHICLE(7);
EXEC ADMINCP.GET_ALL_VEHICLES();
--
EXEC ADMINCP.SET_VEHICLE_STATUS(8, 'IN_SERVICE');
EXEC ADMINCP.GET_ALL_VEHICLES();

------------------------------
--РЕЙСЫ
--route vehicle driver
EXEC ADMINCP.SORT_TRAVELS_BY_DATE_ROUTE_A(TO_DATE('2025-12-01','YYYY-MM-DD'), TO_DATE('2026-12-31','YYYY-MM-DD'), '', '','DESC');
EXEC ADMINCP.GET_ALL_TRAVELS();
EXEC ADMINCP.ADD_TRAVEL(8, 6, 8, TO_DATE('2025-12-24 13:15','YYYY-MM-DD HH24:MI'), TO_DATE('2025-12-24 15:30','YYYY-MM-DD HH24:MI'), 10, 'OK');
EXEC ADMINCP.ADD_TRAVEL(8, 6, 8, TO_DATE('2025-12-25 13:15','YYYY-MM-DD HH24:MI'), TO_DATE('2025-12-25 15:30','YYYY-MM-DD HH24:MI'), 10, 'OK');
EXEC ADMINCP.GET_ALL_TRAVELS();
--Времечко обнова
EXEC ADMINCP.UPDATE_TRAVEL(14, 8, 6, 8, TO_DATE('2025-12-24 14:30','YYYY-MM-DD HH24:MI'), TO_DATE('2025-12-24 16:40','YYYY-MM-DD HH24:MI'), 10, 'OK');
EXEC ADMINCP.GET_ALL_TRAVELS();
--
EXEC ADMINCP.DELETE_TRAVEL(15);
EXEC ADMINCP.GET_ALL_TRAVELS();

--------------------------------
--БРОНИРОВАНИЯ
EXEC ADMINCP.GET_ALL_BOOKINGS();

--------------------------------
--СТАТИТСИКА
EXEC ADMINCP.GET_ALL_TRAVELS();
EXEC ADMINCP.GET_MOST_POPULAR_ROUTES();
EXEC ADMINCP.CALCULATE_REVENUE_BY_PERIOD(TO_DATE('2025-12-03','YYYY-MM-DD'), TO_DATE('2025-12-04','YYYY-MM-DD'));
EXEC ADMINCP.GET_AVG_PASSENGERS_BY_ROUTE(5);
EXEC ADMINCP.CALCULATE_FUEL_BY_MONTH(2025, 12);







--ПОЛЬЗОВАТЕЛЬ
------------------------------------
--ПОЛЬЗОВАТЕЛЬ
------------------------------------
--ПОЛЬЗОВАТЕЛЬ
------------------------------------
--ПОЛЬЗОВАТЕЛЬ
------------------------------------
--ПОЛЬЗОВАТЕЛЬ
------------------------------------
--ПОЛЬЗОВАТЕЛЬ


EXEC ADMINCP.REGISTER_USER('Bogdan2005', '12345', '12345', 'Kavetski Bogdan', '+375331234322');
EXEC ADMINCP.UPDATE_USER('Bogdan2005', '12345', 'Kavetski Bogdan', '+375331111111', '12345', '12345');
--
EXEC ADMINCP.SORT_TRAVELS_BY_DATE_ROUTE(TO_DATE('2025-12-01','YYYY-MM-DD'), TO_DATE('2026-12-31','YYYY-MM-DD'), '', '','DESC');

EXEC ADMINCP.ADD_BOOKING(14, 13 ); 
EXEC ADMINCP.GET_USER_BOOKINGS(13);
EXEC ADMINCP.DELETE_BOOKING(6, 13);
EXEC ADMINCP.GET_HISTORY_USER_BOOKINGS(13);




--ВОДИТЕЛЬ
------------------------------------
--ВОДИТЕЛЬ
------------------------------------
--ВОДИТЕЛЬ
------------------------------------
--ВОДИТЕЛЬ
------------------------------------
--ВОДИТЕЛЬ
------------------------------------
--ВОДИТЕЛЬ

EXEC ADMINCP.REGISTER_DRIVER('Huletski2006', '1234', '1234', 'Huletski Prochor', '+375332233453');

EXEC ADMINCP.GET_TRAVELS_BY_DRIVER(10);
EXEC ADMINCP.GET_USERS_BY_TRAVEL(13);
EXEC ADMINCP.UPDATE_BOOKING_STATUS(6, 'SHOW');
EXEC ADMINCP.ADD_STATISTIC(3, 25);
EXEC ADMINCP.SET_VEHICLE_STATUS(8, 'IN_SERVICE');




