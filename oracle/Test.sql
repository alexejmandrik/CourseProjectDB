exec get_all_users();
exec get_all_drivers();
select * from bookings
exec get_all_vehicles;

select * from Statistics order by REVENUE DESC;

















































show con_name;
alter session set container = XEPDB1;

begin
    REGISTER_ADMIN('ADMINTEST1221', '1234', '1234', 'Mandryk Aliaksei', '+375336717655');
end;

begin
    GET_ALL_DRIVERS();
end;


begin
    ADMINCP.REGISTER_DRIVER('DRIVERTEST', '1234', '1234', 'Mandryk Aliaksei Ivanovich', '+375336717655');
end;

begin
    GET_ALL_USERS();
end;

begin
    ADMINCP.UPDATE_USER('user1', 'password', 'Мандрик Алексей', '+375336717655', 'password', 'password');
end;

begin
    ADMINCP.SET_USER_STATUS('admin', 'BLOCKED');
end;
 -----------------------------------------------------------------------------------------------------
-- ADMIN USECASE
-- Действия с пользователями

begin
    GET_ALL_USERS;
end;
begin
    ADMINCP.SET_USER_STATUS('user2', 'BLOCKED');
end;
begin
    ADMINCP.SET_USER_STATUS('user2', 'ACTIVE');
end;

--Действия с ВОДИТЕЛЯМИ
begin
    GET_ALL_DRIVERS;
end;
begin
    ADMINCP.SET_USER_STATUS('driver2', 'BLOCKED');
end;
begin
    ADMINCP.SET_USER_STATUS('driver2', 'ACTIVE');
end;

begin
    ADMINCP.REGISTER_DRIVER('DRIVERTEST', '1234', '1234', 'Mandryk Aliaksei Ivanovich', '+375336717655');
end;

-------------------------------------
--Дейтсвия с маршрутами
begin
    ADMINCP.GET_ALL_ROUTES();
end;
begin
    ADMINCP.ADD_ROUTE('Минск', 'Несвиж', 120);
end;
begin
    ADMINCP.UPDATE_ROUTE(41, 'Несвиж', 'Минск', 120);
end;
begin
    ADMINCP.DELETE_ROUTE(61);
end;

----Действия с РЕЙСАМИ
begin
    GET_ALL_TRAVELS;
end;
begin
    GET_ALL_ROUTES;
end;
begin
    GET_ALL_VEHICLES;
end;
begin
    GET_ALL_DRIVERS;
end;
begin
    GET_ALL_bookings;
end;
begin
    DELETE_TRAVEL(1);
end;
SELECT * FROM BOOKINGS
BEGIN
    ADD_TRAVEL(1, 10, 8, TO_DATE('2026-12-24 13:15','YYYY-MM-DD HH24:MI'), TO_DATE('2026-12-24 15:30','YYYY-MM-DD HH24:MI'), 10, 'OK');
END;
BEGIN
GET_ALL_ROUTES;
GET_AVG_PASSENGERS_BY_ROUTE(5);
END;
/
select * from statistics
BEGIN
    UPDATE_TRAVEL(14, 5, 5, 1, TO_DATE('2025-12-24 14:30','YYYY-MM-DD HH24:MI'), TO_DATE('2025-12-24 16:40','YYYY-MM-DD HH24:MI'), 10, 'OK');
END;
/
BEGIN
    DELETE_TRAVEL(2);
END;


----Действия с ТРАНСПОРТОМ

begin
    GET_ALL_VEHICLES;
end;

BEGIN
    EXEC ADD_VEHICLE('GG008-5', 'Volvo', 2);
    ADD_VEHICLE('HH008-5', 'Scania', 50);
    ADD_VEHICLE('II009-5', 'MAN', 42);
END;
/

BEGIN
    UPDATE_VEHICLE(6, 'GG007-7', 'MERCEDES', 40, 'OK');
END;
/

BEGIN
    DELETE_VEHICLE(9);
END;
BEGIN
    GET_ALL_users;
END;
SELECT * FROM USERS

BEGIN
    ADD_VEHICLE('EE123-5', 'Yutong', 40);
END;

BEGIN
    ADMINCP.SET_VEHICLE_STATUS(5, 'IN_SERVICE');
END;



----Действия с БРОНИРОВАНИЯМИ

begin
    ADD_STATISTIC(1, 50);
end;
select * from statistics
begin
    DELETE_TRAVEL(19);
end;
BEGIN
    SORT_TRAVELS_BY_DATE_ROUTE(
        TO_DATE('2025-12-1','YYYY-MM-DD'),
        TO_DATE('2026-12-31','YYYY-MM-DD'),
        'Молодечно',
        'Минск',
        'DESC'
    );
END;












































































begin
    GET_ALL_USERS;
end;

BEGIN
    ADD_BOOKING(17,2);
END;

BEGIN
    GET_USER_BOOKINGS(3);
END;

BEGIN
    UPDATE_BOOKING(2,2,3);
END;

BEGIN
    DELETE_BOOKING(200);
END;

--ТЕСТ ВСЕХ GET_ALL
begin
    GET_ALL_ROLES;
end;
begin
    GET_ALL_USERS;
end;
begin
    GET_ALL_DRIVERS;
end;
begin
    GET_ALL_ADMINS;
end;
begin
    GET_ALL_TRAVELS;
end;
begin
    GET_ALL_VEHICLES;
end;
begin
    GET_ALL_ROUTES;
end;
begin
    GET_ALL_BOOKINGS;
end;
BEGIN
DELETE_VEHICLE(1);
END;

---------
--ВОДИТЕЛЬ
begin
GET_ALL_DRIVERS();
end;
begin
GET_ALL_USERS();
end;
begin
GET_ALL_TRAVELS();
end;

begin
    ADMINCP.GET_TRAVELS_BY_DRIVER(6);
end;

begin
GET_ALL_TRAVELS();
end;

begin
    GET_ALL_BOOKINGS();
end;

BEGIN
    GET_USERS_BY_TRAVEL(1);
END;
BEGIN
    GET_ALL_BOOKINGS;
END;
begin
UPDATE_BOOKING_STATUS(6, 'SHOW');
end;
SELECT * FROM BOOKINGS
BEGIN
    SET_VEHICLE_STATUS(5, 'IN_SERVICE');
END;




----------------------------------------------------------------------------------------------

-- ПОЛЬЗВОВАТЕЛИ
BEGIN
    GET_ALL_USERS();
END;
BEGIN
    GET_ALL_TRAVELS();
END;
BEGIN
    GET_USER_BOOKINGS(3);
END;

BEGIN
    GET_HISTORY_USER_BOOKINGS(1);
END;

BEGIN
    ADD_BOOKING(44,1);
END;
/


/

BEGIN
    DELETE_BOOKING(61);
END;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- СТАТИСТИКА
begin
    GET_MOST_POPULAR_ROUTES();
end;

BEGIN
    CALCULATE_REVENUE_BY_PERIOD(
        TO_DATE('2025-12-03','YYYY-MM-DD'),
        TO_DATE('2025-12-04','YYYY-MM-DD')
    );
END;
/
SELECT * FROM STATISTICS
BEGIN
    CALCULATE_FUEL_BY_MONTH(2025, 12);
END;
/
BEGIN
    get_all_travels();
END;
