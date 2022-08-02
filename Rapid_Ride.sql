--Set server output on 
SET SERVEROUTPUT ON;
--Drop All the tables
DROP TABLE PAYMENT;
DROP TABLE TRIPS;
DROP TABLE Distances;
DROP TABLE Vehicles;
DROP TABLE Vehicle_Owners;
DROP TABLE Vehicle_Types;
DROP TABLE Customers;

--Drop sequence for all the table
Drop SEQUENCE Owner_id;
Drop SEQUENCE Vehicle_id;
Drop SEQUENCE Distance_ID;
DROP SEQUENCE customer_seq;
DROP SEQUENCE Trip_ID_seq;
DROP SEQUENCE Payment_seq;

--Create all the tables--
CREATE TABLE Vehicle_Types(
Model VARCHAR(25),
Rate NUMBER,
PRIMARY KEY (Model)
);
--Insert Vehicle Type table
insert into Vehicle_Types values('Sedan',1);
insert into Vehicle_Types values('Truck',1);
insert into Vehicle_Types values('SUV',2);
insert into Vehicle_Types values('Crossover',1.5);
insert into Vehicle_Types values('Minivan',2);
insert into Vehicle_Types values('Bus',5);

--Create Vehicle Owner
CREATE TABLE Vehicle_Owners(
Vehicle_Owner_ID INT,
Owner_Name VARCHAR(40),
Owner_Email VARCHAR(50),
Owner_Credit_Card_Number NUMBER,
Active varchar(5),
PRIMARY KEY (Vehicle_Owner_ID )
);
--Create Vehicle table
CREATE TABLE Vehicles(
Vehicle_Id int,
Vehicle_Owner_ID int,
Model Varchar(25),
Make VARCHAR(30),
Year NUMBER,
Tag_Number varchar2(50),
State varchar(25),
Seating_Capacity int,
Luggage_Capacity int,
Latest_Location varchar(50),
Active varchar(5),
Primary key (Vehicle_Id),
foreign key (Vehicle_Owner_ID) references Vehicle_Owners(Vehicle_Owner_ID),
foreign key (Model) references Vehicle_Types(Model)
);
--Create Distance table
CREATE TABLE Distances(
Distance_ID INT,
Source_Town VARCHAR2(50),
Source_State VARCHAR2(50),
Destination_Town VARCHAR2(50),
Destination_State VARCHAR2(50),
Travelled_Distance NUMBER,
States_Crossed int,
PRIMARY KEY (Distance_ID)
);
--Create Customer
CREATE TABLE Customers(
Customer_ID INT,
Customer_Name VARCHAR(40),
Customer_Email VARCHAR(50),
Customer_Credit_Card_Number NUMBER,
ACTIVE VARCHAR(5),
PRIMARY KEY (Customer_ID)
);
----Creating Triple Table-----
CREATE TABLE Trips(
Trip_ID              Int,
Customer_ID          Int,
Vehicle_Owner_ID     Int,
Model                Varchar(20),
Distance_ID          Int,
Source_Town         VARCHAR(50),
Source_State        VARCHAR(50),
Destination_Town    VARCHAR(50),
Destination_State   VARCHAR(50),
Travel_Date         date,
Vehicle_tag         Varchar(20),
NO_of_Luggage       INT,
passangers_travelling Int,
Payment_Amount         Number,
Primary key (Trip_ID),
foreign key (Customer_ID) references Customers(Customer_ID),
foreign key (Distance_ID) references Distances(Distance_ID),
foreign key (Vehicle_Owner_ID ) references Vehicle_Owners(Vehicle_Owner_ID )
);
--Create Payment table--
CREATE TABLE Payment(
Payment_ID int,
Trip_ID int,
Customer_ID int,
Vehicle_Owner_ID int,
Customer_Credit_Card_Number int,
Owner_Credit_Card_Number int,
Owner_Name VARCHAR(40),
Customer_Name VARCHAR(40),
Payment_Amount Number,
Customer_Money Number,
Owenr_Money Number,
Primary key (Payment_ID),
foreign key (Trip_ID) references Trips(Trip_ID),
foreign key (Vehicle_Owner_ID ) references Vehicle_Owners(Vehicle_Owner_ID ),
foreign key (Customer_ID) references Customers(Customer_ID)
);

--Create sequence for all the table
CREATE SEQUENCE Owner_id START WITH  200;
CREATE SEQUENCE Vehicle_id START WITH 300;
CREATE SEQUENCE customer_seq START WITH 400;
Create SEQUENCE Distance_ID start with 500;
Create SEQUENCE Trip_ID_seq  start with 600;
Create SEQUENCE Payment_seq start with 700;


--Procedure to insert values in Vehicle Owner table 
Begin
dbms_output.put_line('Add Owner ');
End;
/
Create or Replace Procedure AddOwner(
Ownr_ID IN Vehicle_Owners.Vehicle_Owner_ID%type,
Ownr_Name IN Vehicle_Owners.Owner_Name%type,
Ownr_Email IN Vehicle_Owners.Owner_Email%type,
Ownr_Credit_Card_Number IN Vehicle_Owners.Owner_Credit_Card_Number%type,
Acvt IN Vehicle_Owners.Active %type)
IS 
Begin 
Insert into Vehicle_Owners (Vehicle_Owner_ID,Owner_Name,Owner_Email,Owner_Credit_Card_Number,Active)
Values (Ownr_ID,Ownr_Name,Ownr_Email,Ownr_Credit_Card_Number,Acvt);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.Put_line('Error adding desired customer.');
DBMS_OUTPUT.Put_line ('An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
End;
/

----Create procedure to add vehicle
Begin
dbms_output.put_line('-Add new vehicle ');
End;
/
Create or Replace Procedure AddVehicle(
Vehi_ID IN Vehicles.Vehicle_Id%type,
Vehicle_Ownr_ID IN Vehicles.Vehicle_Owner_ID%type,
Modl IN Vehicles.Model%type,
Mke IN Vehicles.Make%type,
Yer IN Vehicles.Year%type,
Tag IN Vehicles.Tag_Number%type,
Stet IN Vehicles.State%type,
Seat_Capacity IN Vehicles.Seating_Capacity%type,
Lugg_Capacity IN Vehicles.Luggage_Capacity%type,
Lst_location IN Vehicles.Latest_Location%type,
Acvt IN Vehicles.Active%type)
IS 
Begin 
Insert into Vehicles (Vehicle_Id,Vehicle_Owner_ID,Model,Make,Year,Tag_Number,State,Seating_Capacity,Luggage_Capacity,Latest_Location,Active)
Values (Vehi_ID,Vehicle_Ownr_ID,Modl,Mke,Yer,Tag,Stet,Seat_Capacity,Lugg_Capacity,Lst_location,Acvt);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.Put_line('Error adding desired customer.');
DBMS_OUTPUT.Put_line ('An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;
/
--Display Vehicle procedure 
Begin
dbms_output.put_line('Display Vehicle ');
End;
/
CREATE OR REPLACE PROCEDURE displayVehicle(veh_type Vehicle_Types.Model%type)
IS
curr_vehicles Vehicles%ROWTYPE;
curr_owners Vehicle_Owners.owner_name%TYPE;
CURSOR A IS
SELECT VO.owner_name, V.vehicle_id, V.vehicle_owner_id, V.Model, V.make, V.year, V.tag_number, V.state, V.seating_capacity, V.luggage_capacity, V.latest_location, V.active
INTO curr_owners, curr_vehicles.vehicle_id, curr_vehicles.vehicle_owner_id, curr_vehicles.Model, curr_vehicles.make, curr_vehicles.year, curr_vehicles.tag_number, curr_vehicles.state, curr_vehicles.seating_capacity, curr_vehicles.luggage_capacity, curr_vehicles.latest_location, curr_vehicles.active
FROM Vehicle_Owners VO
JOIN Vehicles V
ON VO.vehicle_owner_id = V.vehicle_owner_id
WHERE V.model = veh_type;
BEGIN
OPEN A;
LOOP
FETCH A INTO curr_owners, curr_vehicles.vehicle_id, curr_vehicles.vehicle_owner_id, curr_vehicles.Model, curr_vehicles.make, curr_vehicles.year, curr_vehicles.tag_number, curr_vehicles.state, curr_vehicles.seating_capacity, curr_vehicles.luggage_capacity, curr_vehicles.latest_location, curr_vehicles.active;
EXIT WHEN A%NOTFOUND;
dbms_output.put_line(curr_owners || ' ' || curr_vehicles.vehicle_id || ' ' || curr_vehicles.vehicle_owner_id || ' ' || curr_vehicles.model || ' ' || curr_vehicles.make || ' ' || curr_vehicles.year || ' ' || curr_vehicles.tag_number || ' ' || curr_vehicles.state || ' ' || curr_vehicles.seating_capacity || ' ' || curr_vehicles.luggage_capacity || ' ' || curr_vehicles.latest_location || ' ' || curr_vehicles.active);
END LOOP;
END;
/
--Delete Vehicle procedure
Begin 
dbms_output.put_line('delete Vehicle ');
End;
/
CREATE OR REPLACE PROCEDURE delete_vehicle(p_owner_email vehicle_owners.owner_email%type)
IS
begin
update vehicle_owners
set active='N'
where vehicle_owners.owner_email=p_owner_email;
UPDATE vehicles set ACTIVE = 'N' where VEHICLE_OWNER_ID = (SELECT VEHICLE_OWNER_ID FROM vehicle_owners where OWNER_EMAIL = p_owner_email );
Exception
when no_data_found then
Dbms_output.put_line('no rows found');
when too_many_rows then
dbms_output.put_line('too many rows');
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('error');
end;

/
CREATE OR REPLACE PROCEDURE displayStates
AS
p_state vehicles.state%TYPE;
p_count int;
CURSOR C IS
select state,count(*) from vehicles group by state;
BEGIN
OPEN C;
LOOP
FETCH C INTO p_state,p_count;
EXIT WHEN C%NOTFOUND;
dbms_output.put_line(p_state ||': '|| p_count);
END LOOP;
END;
/

Begin
dbms_output.put_line(Adding customer ');
End;
/
CREATE OR REPLACE PROCEDURE add_Customer
(Cus_id IN Customers.Customer_ID%TYPE,
Cus_name IN Customers.Customer_Name%TYPE,
Cus_email IN Customers.Customer_Email%TYPE,
Cus_card IN Customers.Customer_Credit_Card_Number%TYPE,
Cus_Act IN Customers.Active%TYPE)
 IS
BEGIN
INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Credit_Card_Number,ACTIVE )
VALUES(
Cus_id,
Cus_name,
Cus_email,
Cus_card,
Cus_Act 
);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.Put_line('Error adding desired customer.');
DBMS_OUTPUT.Put_line ('An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;
/
Begin
dbms_output.put_line('\Find customer ID ');
End;
/
Create or replace
PROCEDURE cust_info (cust_email in varchar) IS
Cursor c1 is Select customer_id from Customers where customer_email = cust_email;
cust_id number;
BEGIN
Open c1;
Loop
fetch c1 into cust_id;
exit when c1%notfound;
dbms_output.put_line(cust_id);
End loop;
if c1%rowcount = 0 then
Dbms_output.put_line('no rows found');
end if;
close c1;
END;
/
Begin
dbms_output.put_line('show all customers ');
End;
/
Create or replace procedure selectcustomer
is
cust_id customers.Customer_id%type;
cust_name customers.Customer_NAME%type;
cust_email customers.Customer_Email%type;
cust_CC_no customers.Customer_Credit_card_number%type;
Acvt customers.ACTIVE%type;
cursor show is select Customer_id,Customer_NAME,Customer_Email,Customer_Credit_card_number,ACTIVE from CUSTOMERS;
begin
open show;
LOOP
FETCH show INTO cust_id,cust_name,cust_email,cust_CC_no,Acvt;
exit when show%notfound;
DBMS_OUTPUT.PUT_LINE('Customer_id :'||cust_id||' Customer_NAME :'||cust_name||' Customer_Email :'||cust_email||' Customer_Credit_card_number :'||cust_CC_no ||  'ACTIVE: '||Acvt);
end loop;
close show;
exception 
    when no_data_found then
    dbms_output.put_line('No such customer to delete');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE ('exception occured');
end;

/
Begin
dbms_output.put_line('Update credit card number ');
End;
/
Create or replace procedure update_card(cust_name in varchar, new_card_number in number) IS
new_card number;
Begin
update customers set Customer_Credit_Card_Number = new_card_number where customer_name =cust_name;
dbms_output.put_line('updated card number is:' || new_card_number);
Exception
when no_data_found then
Dbms_output.put_line('no rows found');
END;
/

Begin
dbms_output.put_line('Find best and worst customer based on the payment ');
End;
/
create or replace procedure nameofcustomer(id in customers.CUSTOMER_ID%type)
is
custname customers.CUSTOMER_NAME%type;
cursor n is select CUSTOMER_NAME from CUSTOMERS where CUSTOMER_ID = id;
--get name of customer on the base of customer id
begin
open n;
loop
fetch n into custname;
exit when n%notfound;
dbms_output.put_line(custname);
end loop;
close n;
exception
when no_data_found then
dbms_output.put_line('No customer');
end;
/
create or replace procedure GOODCUSTOMERS
is
id CUSTOMERS.CUSTOMER_ID%type;
cursor m is select CUSTOMER_ID from TRIPS group by CUSTOMER_ID order by sum(PAYMENT_Amount) desc;
begin
dbms_output.put_line('Report: Top 3 GOOD CUSTOMERS based on money they spent');
open m;
loop
fetch m into id;
exit when m%rowcount=4 or m%notfound;
NAMEOFCUSTOMER(id);
end loop;
close m;
exception
when no_data_found then
dbms_output.put_line('No customer');
end;
/
Create or replace procedure WORSTCUSTOMERS
is
id CUSTOMERS.CUSTOMER_ID%type;
cursor m is select CUSTOMER_ID from TRIPS group by CUSTOMER_ID order by sum(PAYMENT_Amount) ASC;
begin
dbms_output.put_line('Report: Top 3 WORST CUSTOMERS based on money they spent');
open m;
loop
fetch m into id;
exit when m%rowcount=4 or m%notfound;
NAMEOFCUSTOMER(id);
end loop;
close m;
exception
when no_data_found then
dbms_output.put_line('No customer');
end;
/


Begin
dbms_output.put_line('Add distance ');
End;
/
Create or Replace Procedure AddNewDistance(
Dis_ID IN distances.distance_id%type,
S_Town IN distances.source_town%type,
S_State IN distances.source_state%type,
D_Town IN distances.destination_town%type,
D_State IN distances.destination_state%type,
Trvl_Dis IN distances.travelled_distance%type,
Sts_crossed IN distances.States_Crossed%type)
IS 
Begin 
Insert into distances (Distance_ID,Source_Town,Source_State,Destination_Town,Destination_State,Travelled_Distance,States_Crossed)
Values (Dis_ID,S_Town,S_State,D_Town,D_State,Trvl_Dis,Sts_crossed);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.Put_line('Error adding desired customer.');
DBMS_OUTPUT.Put_line ('An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
End;
/
--Procedure to check available rides 
Begin
dbms_output.put_line('-Show available rides ');
End;
/
create or replace procedure check_available_rides(starting_point in varchar2, ending_point in varchar2, no_of_people in int, no_of_luggage in int)
as
record_found boolean:=false;
cursor c1 is select v.Model, v.seating_capacity, v.luggage_capacity from vehicles v, distances d
where v.latest_location = starting_point and v.seating_capacity >= no_of_people and v.luggage_capacity >= no_of_luggage and v.active='y'
and v.latest_location = d.source_town
and d.destination_town = ending_point;
begin
    dbms_output.put_line('Input Data -  Starting_point :' || starting_point||' , Ending point: '|| ending_point ||' , Num of people:'||no_of_people||' , Num of luggage:'||no_of_luggage);
    dbms_output.put_line('List of Available Vehicles : ');

for r_vehicles in c1 loop
    record_found:=true;
    dbms_output.put_line('Vehicle Type : '|| r_vehicles.Model ||', -- Seating Capacity : '|| r_vehicles.seating_capacity||', -- Luggage Capacity : '|| r_vehicles.luggage_capacity);
end loop;
if record_found=false then
      dbms_output.put_line('No rides available for the given input data');
end if;
exception
when no_data_found then
   dbms_output.put_line('No vehicles available for the given criteria');
when others then
   dbms_output.put_line('exception occured');
end;
/
--Procedure for one leg distance 
Begin
dbms_output.put_line('One leg destination-->  ');
End;
/
Create or replace procedure report_one_leg_destinations(starting_point in varchar)
as
record_found boolean :=false;
cursor c1 is SELECT * FROM DISTANCES WHERE SOURCE_TOWN = starting_point;
begin
dbms_output.put_line('Report: One-Leg Destinations');
for r_distances in c1 loop
record_found := true;
dbms_output.put_line('Source Town : '|| r_distances.source_town ||', Source State : '|| r_distances.source_state ||', Destination Town : '|| r_distances.destination_town||
', Destination State : '|| r_distances.destination_state||', Distance in Miles : '|| r_distances.Travelled_Distance);
end loop;
if record_found=false then
dbms_output.put_line('No data available for the given source town');
end if;
exception
when no_data_found then
dbms_output.put_line('No data available for the given source town');
when others then
dbms_output.put_line('exception occured');
end;

/
--Find Trips
Begin
dbms_output.put_line('Record a trip');
end;
/
create or replace PROCEDURE RECORD_A_TRIP(
   cust_name                 customers.customer_name%type,
    veh_owner_name             Vehicle_owners.Owner_name%type,
    Mdl_id                      Trips.Model%type,
   sou_town                    distances.Source_Town%type,
   sou_state                   distances.Source_State%type,
   dest_town                    distances.Destination_Town%type,
   dest_state                   distances.Destination_State%type,
   date_of_travel               Trips.Travel_Date%type,
   veh_tag                       Trips.Vehicle_tag%type,
   no_of_Luggage_bags           Trips.No_of_Luggage%type,
   No_of_passengers_travelling  Trips.passangers_travelling%type,
   bill_payment_Amount          Trips.payment_Amount%type
   )
 IS
   Begin
   INSERT INTO trips VALUES (
        Trip_ID_seq.NEXTVAL,
        (select customer_id from customers where customer_name = cust_name),
        (select Vehicle_Owner_ID  from vehicle_owners where Owner_name=veh_owner_name),
        Mdl_id,
       ( select distance_id from distances where
                   source_town = sou_town  and source_state = sou_state  and destination_town = dest_town
                  AND destination_state = dest_state ),
        sou_town,
        sou_state,
        dest_town,
        dest_state,
        date_of_travel,
        veh_tag,
     --   ( select vehicle_id from vehicles where vehicle_id = veh_id),
        no_of_Luggage_bags,
   No_of_passengers_travelling,
   bill_payment_Amount );
     

 Exception
    when others then
    dbms_output.put_line('data mismatch');

END;
/

Begin
dbms_output.put_line('Find trip');
End;
/
Create or replace procedure find_trip_id (
    t_Customer_name       customers.Customer_name%type,
    t_Owner_name         vehicle_owners.owner_name%type,
    t_Source_town       distances.source_town%type,
 --   t_Source_state      distances.source_state%type,
    t_Destination_Town  distances.destination_town%type,
  --  t_Destination_state  distances.destination_state%type,
    t_dateoftrip         trips.travel_date%type)
IS
t_id trips.trip_id%type;
BEGIN
select trip_id into t_id from trips where customer_id=(select customer_id from customers where customer_name=t_customer_name)
                 and vehicle_owner_id=(select vehicle_Owner_id from vehicle_owners where owner_name= t_owner_name)
                 and Source_town=t_Source_town  
        and Destination_Town=t_Destination_Town
            and travel_date=t_dateoftrip;
   dbms_output.put_line('TRIP_ID is: ' || t_id);
   EXCEPTION
   when no_data_found then
   dbms_output.put_line('no such trip found');
   end;
/


Begin
dbms_output.put_line('Calculate payment');
end;
/
CREATE OR REPLACE PROCEDURE CALCULATEPAYMENT(TID IN INT)
AS
MILES DISTANCES.TRAVELLED_DISTANCE%TYPE;
VTYPE VEHICLE_TYPES.MODEL%TYPE;
BASERATE VEHICLE_TYPES.RATE%TYPE;
BAGGAGE TRIPS.NO_of_Luggage%TYPE;
S TRIPS.SOURCE_STATE%TYPE;
D TRIPS.DESTINATION_STATE%TYPE;
NUMBEROFTRAVELERS TRIPS.PASSANGERS_TRAVELLING%TYPE;
ADDEDFEE int;
BASEFARE INT;
PAYMENT int;
OID INT;
CID INT;
MID varchar(25);
BEGIN
SELECT PASSANGERS_TRAVELLING , VEHICLE_OWNER_ID, Model INTO NUMBEROFTRAVELERS, OID, MID FROM TRIPS WHERE TRIP_ID = TID;

SELECT TRAVELLED_DISTANCE INTO MILES FROM DISTANCES, TRIPS WHERE DISTANCES.SOURCE_TOWN=TRIPS.SOURCE_TOWN AND DISTANCES.DESTINATION_TOWN = trips.destination_town AND TRIPS.TRIP_ID = TID;

SELECT RATE INTO BASERATE FROM VEHICLES,VEHICLE_TYPES WHERE VEHICLES.Model = VEHICLE_TYPES.Model AND VEHICLES.vehicle_owner_id = OID AND VEHICLES.Model = MID;

BASEFARE:=MILES*BASERATE*NUMBEROFTRAVELERS;

SELECT NO_of_Luggage INTO BAGGAGE FROM TRIPS WHERE TRIP_ID=TID;
IF BAGGAGE>0 THEN
ADDEDFEE:=BAGGAGE*5;
ELSE
ADDEDFEE:=0;
END IF;

SELECT SOURCE_STATE, DESTINATION_STATE INTO S, D  FROM TRIPS WHERE TRIP_ID=TID;
IF S != D THEN
ADDEDFEE:=ADDEDFEE+20;
END IF;

PAYMENT:= BASEFARE+ADDEDFEE;
DBMS_OUTPUT.PUT_LINE ('TOTALPAYMENT = '|| PAYMENT);
UPDATE TRIPS SET PAYMENT_AMOUNT = PAYMENT WHERE TRIP_ID = TID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('NO SUCH TRIP');
END;
/
--Procedure to find Payments
Begin
dbms_output.put_line('Make payment ');
End;
/
CREATE OR REPLACE FUNCTION  FINDPAYMENTS (TID IN INT, CID IN INT,OID IN INT)
RETURN NUMBER
IS
PAYMENT_AMOUNTS  NUMBER;

BEGIN

SELECT PAYMENT_AMOUNT INTO PAYMENT_AMOUNTS FROM TRIPS 
WHERE VEHICLE_OWNER_ID=OID AND CUSTOMER_ID=CID AND TRIP_ID=TID;

RETURN PAYMENT_AMOUNTS;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE ('NO SUCH TRIP EXIT');
RETURN -1;

END;
/


CREATE OR REPLACE PROCEDURE MAKE_PAYMENT(TID IN INT, CID IN INT, OID IN INT)
IS 
PAYMENT_AMOUNTS NUMBER;
BEGIN
PAYMENT_AMOUNTS := FINDPAYMENTS(TID,CID,OID);
IF 
    PAYMENT_AMOUNTS > 0 THEN
    DBMS_OUTPUT.PUT_LINE(' TOTAL PAYMENT IS '|| PAYMENT_AMOUNTS);

    INSERT INTO Payment (Payment_ID, Trip_ID, Customer_ID, Vehicle_Owner_ID,Payment_Amount,Customer_Money,Owenr_Money)
    VALUES (payment_seq.nextval,TID,CID,OID,Payment_Amounts,-PAYMENT_AMOUNTS,PAYMENT_AMOUNTS);
    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE(' CUSTOMER DEDUCTED BY '|| -PAYMENT_AMOUNTS);
    DBMS_OUTPUT.PUT_LINE('DRIVER INCOME FOR TRIP '  || PAYMENT_AMOUNTS);
ELSE 
    DBMS_OUTPUT.PUT_LINE('NO SUCH TRIP EXIST');
END IF;
Exception
        when no_data_found then
        Dbms_output.put_line('no rows found');
        when too_many_rows then
        dbms_output.put_line('too  many rows');
--WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('error');
END;

/
CREATE OR REPLACE PROCEDURE GetDestTownIncome (v_cursor out SYS_REFCURSOR) 
as
begin
dbms_output.put_line('Report:TOTAL INCOME BY DESTINATION TOWN');
open v_cursor for
SELECT D.DESTINATION_TOWN, SUM (PAYMENT_AMOUNT)
FROM DISTANCES D
INNER JOIN TRIPS TP ON TP.SOURCE_TOWN = d.source_town AND TP.DESTINATION_TOWN = D.DESTINATION_TOWN
GROUP BY D.DESTINATION_TOWN;
end;
/


---------Adding records in Vehicle_Owners table---------------
Begin
dbms_output.put_line('adding users Joe, Kathy, and Pat.');
AddOwner(Owner_id.nextval,'Joe','joe@umbc.edu',123456,'Y');
AddOwner(Owner_id.nextval,'Kathy','kathy@abc.com',234567,'Y');
AddOwner(Owner_id.nextval,'Pat','pat@yahoo.com',123234,'Y');
End;
/
Select * from Vehicle_owners;
/
------Adding records in Vehicles table--------------
Begin
dbms_output.put_line('adding vehciles for Joe, Kathy, and Pat.');
AddVehicle(Vehicle_id.nextval,200,'SUV','Honda',2018,'ABC12M3','MD',7,5,'Baltimore','y');
AddVehicle(Vehicle_id.nextval,201,'Minivan','Chrysler',2019,'AAA123','MD',7,7,'Baltimore','y');
AddVehicle(Vehicle_id.nextval,201,'Bus','GMC',2010,'AAA555','MD',55,100,'Baltimore','y');
AddVehicle(Vehicle_id.nextval,202,'Sedan','Ford',2015,'ZZZ12M3','VA',5,5,'Baltimore','y');
End;
/
Select * from Vehicles;
/
----------------Deleting Pat's car by calling procedure delete_Vehicle---------------
BEGIN
dbms_output.put_line('A vehicle belonging to Pat was removed from to the Vehicles table.');
delete_Vehicle('pat@yahoo.com');
END;
/
select * from vehicles;
/
-------------Display all Sedan Vehicles by calling procedure displayVehicle-----------
BEGIN
dbms_output.put_line('Report for Member 1' );
displayVehicle('Sedan');
END;
/



-----Adding Customers in the Customer table by calling procedure add_Customer-------------
BEGIN

add_Customer(customer_seq.nextval,'Messi','messi@psg.com',777222,'Y');
add_Customer(customer_seq.nextval,'Ronaldo','ronaldo@manu.com',777111,'Y');
add_Customer(customer_seq.nextval,'Mia Hamm','hamm@usa.com',777333,'Y');
add_Customer(customer_seq.nextval,'Rapinoe','rapinoe@usa.com',777444,'Y');
END;
/

Select * from Customers;

/

-----Find customer ID by calling procedure cust_info--------
BEGIN 

cust_info('hamm@usa.com');
End;
/
--------Find Customer ID by calling cust_info--------
Set serveroutput on;
BEGIN

cust_info('messi@psg.com');
End;
/
-----Show all the customers by calling selectcustomer-------
Begin 

selectcustomer;
End;
/

----Update the cc number by calling procedure update_card-----
Begin 
update_card('Ronaldo',777777);
End;
/
Select * from Customers;


----Adding Records in display table by calling procedure AddNewDistance-------
Begin

AddNewDistance(Distance_ID.nextval,'Baltimore','MD','College Park','MD',28,0);
AddNewDistance(Distance_ID.nextval,'Alexandria','VA','College Park','MD',14,1);
AddNewDistance(Distance_ID.nextval,'Baltimore','MD','New York','NY',170,1);
AddNewDistance(Distance_ID.nextval,'Baltimore','MD','Philadelphia','PA',90,1);
AddNewDistance(Distance_ID.nextval,'Olney','MD','Arbutus','MD',21,0);
AddNewDistance(Distance_ID.nextval,'College Park','MD','Olney','MD',14,0);
AddNewDistance(Distance_ID.nextval,'Olney','MD','Ellicott City','MD',16,0);
AddNewDistance(Distance_ID.nextval,'Ellicott City','MD','Baltimore','MD',12,0);
AddNewDistance(Distance_ID.nextval,'Baltimore','MD','Towson','MD',8,0);
AddNewDistance(Distance_ID.nextval,'Towson','MD','College Park','MD',34,0);
AddNewDistance(Distance_ID.nextval,'College Park','MD','Baltimore','MD',28,0);
AddNewDistance(Distance_ID.nextval,'College Park','MD','Alexandria','VA',14,1);
AddNewDistance(Distance_ID.nextval,'New York','NY','Baltimore','MD',170,1);
AddNewDistance(Distance_ID.nextval,'Philadelphia','PA','Baltimore','MD',90,1);
AddNewDistance(Distance_ID.nextval,'Arbutus','MD','Olney','MD',21,0);
AddNewDistance(Distance_ID.nextval,'Olney','MD','College Park','MD',14,0);
AddNewDistance(Distance_ID.nextval,'Ellicott City','MD','Olney','MD',16,0);
AddNewDistance(Distance_ID.nextval,'Baltimore','MD','Ellicott City','MD',12,0);
AddNewDistance(Distance_ID.nextval,'Towson','MD','Baltimore','MD',8,0);
AddNewDistance(Distance_ID.nextval,'College Park','MD','Towson','MD',34,0);
End;
/
Select * from Distances;
/
--Show available rides for customers:
-- 'Mia Ham'
EXEC check_available_rides('Baltimore', 'Philadelphia', 2, 3);
-- 'Messi'
EXEC check_available_rides('Baltimore', 'New York', 25, 50);
-- 'Megan Rapinoe'
EXEC check_available_rides('Baltimore', 'College Park', 1, 0);
-- 'Megan Rapinoe'
EXEC check_available_rides('College Park','Olney', 1, 0);
/


-----Adding Records in Trips table by calling Record_a_trip---------
   begin
    Record_a_trip('Ronaldo', 'Joe','SUV', 'Alexandria', 'VA', 'College Park','MD', DATE '2021-11-20', 'ABC12M3', 1, 1, 0);
    Record_a_trip('Ronaldo', 'Pat','Sedan', 'College Park', 'MD', 'Olney','MD', DATE '2021-11-20', 'ZZZ12M3', 2, 1, 0);
    Record_a_trip('Ronaldo', 'Joe','SUV', 'Olney', 'MD', 'Ellicott City','MD', DATE '2021-11-20', 'ABC12M3', 1, 1, 0);
    Record_a_trip('Ronaldo', 'Joe','SUV', 'Ellicott City', 'MD', 'Baltimore','MD', DATE '2021-11-20', 'ABC12M3', 3, 1, 0);
    Record_a_trip('Ronaldo', 'Joe','SUV', 'Baltimore', 'MD', 'New York','NY', DATE '2021-11-20', 'ABC12M3', 3, 1, 0);
    Record_a_trip('Mia Hamm', 'Joe','SUV', 'Baltimore', 'MD', 'Philadelphia','PA', DATE '2021-12-01','ABC12M3', 3, 2, 0);
    Record_a_trip('Messi', 'Kathy','Bus', 'Baltimore', 'MD', 'New York','NY', DATE '2021-05-31', 'AAA555', 50,25, 0);
    Record_a_trip('Ronaldo', 'Kathy','Bus', 'New York', 'NY', 'Baltimore','MD', DATE '2021-11-20', 'AAA555', 80, 30, 0);
    Record_a_trip('Rapinoe', 'Pat','Sedan', 'Baltimore', 'MD', 'College Park','MD', DATE '2021-12-02', 'ZZZ12M3', 1, 1, 0);
    Record_a_trip('Rapinoe', 'Pat','Sedan', 'College Park', 'MD', 'Olney','MD', DATE '2020-12-02', 'ZZZ12M3', 2, 1, 0);
    Record_a_trip('Rapinoe', 'Pat','Sedan', 'Olney', 'MD', 'Arbutus','MD', DATE '2021-12-02', 'ZZZ12M3', 1, 1, 0);
    Record_a_trip('Ronaldo', 'Joe','SUV', 'Alexandria', 'VA', 'College Park','MD', DATE '2021-12-03', 'ABC12M3', 2, 1, 0);
    Record_a_trip('Ronaldo', 'Joe','SUV', 'College Park', 'MD', 'Baltimore','MD', DATE '2021-12-03', 'ABC12M3', 1, 1, 0);
    Record_a_trip('Ronaldo', 'Joe','SUV', 'Baltimore', 'MD', 'New York','NY', DATE '2021-12-04', 'ABC12M3', 1, 1, 0);        

end;
/

Select * from Trips;
/

---Find Trip id by calling find_trip_id---------
begin

    find_trip_id('Rapinoe', 'Pat', 'Baltimore','College Park', DATE '2021-12-02');
    find_trip_id('Ronaldo', 'Pat', 'College Park','Olney', DATE '2021-11-20');
    find_trip_id('Ronaldo', 'Joe', 'Olney','Ellicott City', DATE '2021-11-20');
    find_trip_id('Ronaldo', 'Joe', 'Ellicott City','Baltimore', DATE '2021-11-20');
    find_trip_id('Mia Hamm', 'Joe','Baltimore','Philadelphia', DATE '2021-12-01');
    find_trip_id('Messi',   'Kathy', 'Baltimore','New York', DATE '2021-05-31');
    find_trip_id('Ronaldo', 'Kathy', 'New York', 'Baltimore', DATE '2021-11-20');
    find_trip_id('Rapinoe', 'Pat', 'Baltimore','College Park', DATE '2021-12-02');
    find_trip_id('Rapinoe', 'Pat', 'College Park','Olney',DATE '2020-12-02');
    find_trip_id('Rapinoe', 'Pat', 'Olney','Arbutus', DATE '2021-12-02');
    find_trip_id('Ronaldo', 'Joe', 'Alexandria','College Park', DATE '2021-12-03');
    find_trip_id('Ronaldo', 'Joe', 'College Park','Baltimore', DATE '2021-12-03');
    find_trip_id('Ronaldo', 'Joe', 'Baltimore','New York',DATE '2021-12-04');     
 end;
/


-- Calculate payment by calling CALCULATEPAYMENT---
EXEC CALCULATEPAYMENT(600);
EXEC CALCULATEPAYMENT(601);
EXEC CALCULATEPAYMENT(602);
EXEC CALCULATEPAYMENT(603);
EXEC CALCULATEPAYMENT(604);
EXEC CALCULATEPAYMENT(605);
EXEC CALCULATEPAYMENT(606);
EXEC CALCULATEPAYMENT(607);
EXEC CALCULATEPAYMENT(608);
EXEC CALCULATEPAYMENT(609);
EXEC CALCULATEPAYMENT(610);
EXEC CALCULATEPAYMENT(611);
EXEC CALCULATEPAYMENT(612);
EXEC CALCULATEPAYMENT(613);

---make payment by calling MAKE_PAYMENT---
EXEC MAKE_PAYMENT(600,401,200);
EXEC MAKE_PAYMENT(601,401,202);
EXEC MAKE_PAYMENT(602,401,200);
EXEC MAKE_PAYMENT(603,401,200);
EXEC MAKE_PAYMENT(604,401,200);
EXEC MAKE_PAYMENT(605,402,200);
EXEC MAKE_PAYMENT(606,400,201);
EXEC MAKE_PAYMENT(607,401,201);
EXEC MAKE_PAYMENT(608,403,202);
EXEC MAKE_PAYMENT(609,403,202);
EXEC MAKE_PAYMENT(610,403,202);
EXEC MAKE_PAYMENT(611,401,200);
EXEC MAKE_PAYMENT(612,401,200);
EXEC MAKE_PAYMENT(613,401,200);
/*
-----------------------------Reports-----------------------------------------------------------------------------------
*/

----Member 1--------------
BEGIN
dbms_output.put_line('
displaying the number of vehicles registered in each state.');
displaystates();
END;
/

----Member 2----------

exec GOODCUSTOMERS;

exec WORSTCUSTOMERS;





-------------------Member 3-------------------

declare
starting_point varchar(50):='Baltimore';
begin
report_one_leg_destinations(starting_point);
end;
/
----------------------Member 5----------------------------

--executing the procedure and running the result (Cursor) returned by the procedure in loop to calculate the total income of the destinations.
declare
  result sys_refcursor;
  dest_town VARCHAR(50);
  lsn number; 
  GRANDTOTAL NUMBER := 0;
begin
  GETDESTTOWNINCOME(result); 
  dbms_output.put_line('dest_town'||'   '||'Total_Income');
  loop
    fetch result into dest_town, lsn; 
    exit when result%notfound;
        dbms_output.put_line(dest_town||'   '||lsn);
        GRANDTOTAL := GRANDTOTAL + lsn;
  end loop;
   dbms_output.put_line('GRANDTOTAL'||'   '||GRANDTOTAL);
Exception
        when no_data_found then
        Dbms_output.put_line('no rows found');
when too_many_rows then
        dbms_output.put_line('too many rows');
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('error');


end;
/
Commit;

