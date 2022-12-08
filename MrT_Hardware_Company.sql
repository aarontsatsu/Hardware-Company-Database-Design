drop database if exists MrT_Hardware_Company;
create database MrT_Hardware_Company;
use MrT_Hardware_Company;

create table Customer(
CustomerID varchar(5) primary key,
Telephone varchar(25) unique not null,
Address varchar (25) not null,
Email varchar(50) unique not null
);

create table IndividualCustomer(
IndividualCustomerID varchar(5) unique,
FOREIGN KEY (IndividualCustomerID) references Customer(CustomerID) on delete cascade on update cascade,
FirstName varchar(20) not null,
LastName varchar (20) not null,
Gender enum('Male', 'Female', 'Others') not null

);

create table CorporateEntity(
CorporateEntityID varchar(5) unique,
FOREIGN KEY (CorporateEntityID) references Customer(CustomerID) on delete cascade,
CompanyName varchar(40) not null,
CompanyCity varchar(20)
);

create table Supplier(
SupplierID varchar(5) primary key,
SupplierName varchar(20) not null, 
Telephone varchar(25) unique not null, 
Email varchar (50) not null unique, 
Country varchar (30)
);

create table Staff(
StaffID varchar(5) primary key,
FirstName varchar (20) not null,
LastName varchar(20) not null,
Telephone varchar (25) not null unique,
Address varchar (25) not null,
Email varchar (50) unique not null,
StartDate date not null,
EndDate date null
);

create table Driver(
DriverID varchar(5) unique,
FOREIGN KEY (DriverID) references Staff(StaffID) on delete cascade on update cascade,
LicenseNumber varchar(15) unique not null,
TrafficViolationRecord varchar(255) null
);

create table Salesperson(
SalespersonID varchar(5) unique,
FOREIGN KEY (SalespersonID) references Staff(StaffID) on delete cascade on update cascade,
CommissionRate float not null,
SalesQuota int null
);

create table Intern(
InternID varchar(5) unique,
FOREIGN KEY (InternID) references Staff(StaffID) on delete cascade on update cascade,
Institution varchar(50) not null,
Major varchar(35) not null
);

create table Technician(
TechnicianID varchar(5) unique,
FOREIGN KEY (TechnicianID) references Staff(StaffID) on delete cascade on update cascade,
ExpertiseArea enum('printers', 'scanners', 'system units', 'laptops', 'UPS', 'computer monitors') not null default 'laptops',
ExperienceStartYear year not null
);

create table Manager(
ManagerID varchar(5) unique,
FOREIGN KEY (ManagerID) references Staff(StaffID) on delete cascade on update cascade,
YearsOfExperience year not null,
MaritalStatus enum('Married', 'Single', 'Divorced') null
);

create table Truck(
TruckID varchar(5) primary key,
LicensePlate varchar(10) unique not null,
Make varchar(15) not null,
Model varchar(20) not null,
ManufactureYear year
);

create table Product(
ProductID varchar(5) primary key,
ProductType enum ('printers', 'scanners', 'system units', 'laptops', 'UPS', 'computer monitors') not null,
Cost float not null,
StockQuantity int not null
);

create table RepairsService(
RepairsServiceID varchar(5) primary key,
RepairsName enum ('printers', 'scanners', 'system units', 'laptops', 'UPS', 'computer monitors') not null,
Cost float not null
);

create table Payment(
PaymentID varchar(5) primary key,
PaymentDate date not null,
PaymentTime time not null,
Amount float not null,
PaymentMethod enum('MOMO', 'POS', 'cash', 'debit card', 'credit card')
);

create table ProductPayment(
ProductPaymentID varchar(5) unique,
PaymentID varchar(5),
FOREIGN KEY (PaymentID) references Payment(PaymentID) on delete cascade on update cascade,
Discount float null
);

create table RepairsPayment(
RepairsPaymentID varchar(5) unique,
PaymentID varchar(5),
FOREIGN KEY (PaymentID) references Payment(PaymentID) on delete cascade on update cascade,
ServicerTip float null
);

create table TruckDriver(
TruckDriverID varchar(5) unique,
DriveDate date not null,
FuelRefills int null,
DriverID varchar(5),
TruckID varchar(5),
FOREIGN KEY (DriverID) references Driver(DriverID) on delete cascade on update cascade,
FOREIGN KEY (TruckID) references Truck(TruckID) on delete cascade on update cascade
);

create table ProductCustomer(
ProductCustomerID varchar(5) unique,
PurchaseDate date not null,
PurchaseTime time not null,
SalespersonID varchar(5),
InternID varchar(5) null,
ProductID varchar(5),
CustomerID varchar(5),
ProductPaymentID varchar(5),
FOREIGN KEY (SalespersonID) references Salesperson(SalespersonID) on delete cascade on update cascade,
FOREIGN KEY (InternID) references Intern(InternID) on delete cascade on update cascade,
FOREIGN KEY (ProductID) references Product(ProductID) on delete cascade on update cascade,
FOREIGN KEY (CustomerID) references Customer(CustomerID) on delete cascade on update cascade,
FOREIGN KEY (ProductPaymentID) references ProductPayment(ProductPaymentID) on delete cascade on update cascade
);

create table RepairsCustomer(
RepairsCustomerID varchar(5) unique,
LoginDate date not null,
LogoutDate date null,
CustomerID varchar(5),
RepairsServiceID varchar(5),
TechnicianID varchar(5),
InternID varchar(5) null,
RepairsPaymentID varchar(5),
ProductID varchar(5),
FOREIGN KEY (CustomerID) references Customer(CustomerID) on delete cascade on update cascade,
FOREIGN KEY (RepairsServiceID) references RepairsService(RepairsServiceID) on delete cascade on update cascade,
FOREIGN KEY (TechnicianID) references Technician(TechnicianID) on delete cascade on update cascade,
FOREIGN KEY (InternID) references Intern(InternID) on delete cascade on update cascade,
FOREIGN KEY (RepairsPaymentID) references RepairsPayment(RepairsPaymentID) on delete cascade on update cascade,
FOREIGN KEY (ProductID) references Product(ProductID) on delete cascade on update cascade
);

create table ProductSupplier(
ProductSupplierID varchar(5) unique,
SupplyDate date not null,
AgentFirstName varchar (20) not null,
AgentLastName varchar(20) not null,
AgentContact varchar(25) not null,
ProductID varchar(5),
SupplierID varchar(5),
FOREIGN KEY (ProductID) references Product(ProductID) on delete cascade on update cascade,
FOREIGN KEY (SupplierID) references Supplier(SupplierID) on delete cascade on update cascade
);

create table Delivery(
DeliveryID varchar(5) unique,
DeliveryTime time not null,
DeliveryDate date not null,
DeliveryStatus enum('completed', 'in progress'),
TruckDriverID varchar (5),
ProductCustomerID varchar(5),
FOREIGN KEY (TruckDriverID) references TruckDriver(TruckDriverID) on delete cascade on update cascade,
FOREIGN KEY (ProductCustomerID) references ProductCustomer(ProductCustomerID) on delete cascade on update cascade
);

/*Creating an index for customer ID to improve performance of queries that use the customer ID in join queries.*/
create index customerid_index on Customer(CustomerID);

/*Creating an index for the product type which will be used often in order by queries for efficiency*/
create index producttype_index on Product(ProductType);

/*Creating an index for staff names to improve queries that will look up employee names*/
create index staffname_index on Staff(FirstName, LastName);

/*Creating an index for the supplier names to improve queries that order by the supplier name*/
create index suppliername_index on Supplier(SupplierName);


/*
Data Population
*/
insert into Customer(CustomerID, Telephone, Address, Email)values('C100', '0234568431', 'Moko 7 Street', 'aaron@gmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C200', '0223456781', 'Milo 4 Street', 'ama@gmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C300', '0456789875', 'Jomo 12 Street', 'cbgbank@gmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C400', '0302234569', '1 University Ave', 'ashesiuniv@gmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C500', '0235869493', 'Salifu Street', 'claude@hotmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C600', '0302368789', 'Shiashie Avenue', 'nia@gov.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C700', '0234098031', 'Kwaku Street', 'emma@gmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C800', '0987655678', 'Osu Street', 'signature@outlook.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C900', '0246784569', 'Dzodze Street', 'abigail@gmail.com');
insert into Customer(CustomerID, Telephone, Address, Email)values('C101', '0304567654', 'Adom 45 Street', 'petit.foods@gmail.com');


insert into IndividualCustomer(IndividualCustomerID, FirstName,LastName,Gender)values('C900', 'Abigail', 'Owusu', 'Female');
insert into IndividualCustomer(IndividualCustomerID, FirstName,LastName,Gender)values('C700', 'Emmanuel', 'Nobi', 'Male');
insert into IndividualCustomer(IndividualCustomerID, FirstName,LastName,Gender)values('C500', 'Claude', 'Tamakloe', 'Male');
insert into IndividualCustomer(IndividualCustomerID, FirstName,LastName,Gender)values('C200', 'Ama', 'Ayiku', 'Female');
insert into IndividualCustomer(IndividualCustomerID, FirstName,LastName,Gender)values('C100', 'Aaron', 'Tamakloe', 'Male');


insert into CorporateEntity(CorporateEntityID, CompanyName,CompanyCity)values('C300', 'CBG Bank', 'Accra');
insert into CorporateEntity(CorporateEntityID, CompanyName,CompanyCity)values('C400', 'Ashesi University', 'Berekuso');
insert into CorporateEntity(CorporateEntityID, CompanyName,CompanyCity)values('C600', 'National Identification Authority', 'Accra');
insert into CorporateEntity(CorporateEntityID, CompanyName,CompanyCity)values('C800', 'Signature Apartments', 'Accra');
insert into CorporateEntity(CorporateEntityID, CompanyName,CompanyCity)values('C101', 'Petit Foods', 'Tema');

insert into Supplier(SupplierID,SupplierName, Telephone, Email, Country)values('S100', 'HP', '+123456789875', 'hpusa@outlook.com', 'United States of America');
insert into Supplier(SupplierID,SupplierName, Telephone, Email, Country)values('S200', 'Schneider', '865-210-1675', 'schneiderusa@outlook.com', 'United States of America');
insert into Supplier(SupplierID,SupplierName, Telephone, Email, Country)values('S300', 'Toshiba', '+86-18248100063', 'toshibachina@outlook.com', 'China');
insert into Supplier(SupplierID,SupplierName, Telephone, Email, Country)values('S400', 'Apple', '336-972-9276', 'appleusa@outlook.com', 'United States of America');
insert into Supplier(SupplierID,SupplierName, Telephone, Email, Country)values('S500', 'Canon', '+86-15842591201', 'canonchina@outlook.com', 'China');


insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST100', 'Badu', 'Nkansah', '0541443737', 'A Lang Road', 'badu@gmail.com', '2008-07-12');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST200', 'Frederick', 'Dapaah', '0244400000', 'C 25 Dawano Ave', 'fred@gmail.com', '2010-05-02');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate, EndDate)values('ST300', 'Augustine', 'Ahado', '0244400456', 'Hanch Street', 'augustine@nafti.edu', '2022-6-01', '2022-08-30');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST400', 'Ewuarama', 'Keeba', '+233-24921989', 'Masere Avenue 4', 'ewurama@gmail.com', '2011-07-05');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST500', 'Ishmael', 'Acquah', '+233-24924569', 'Devault Avenue 10', 'ishmael@gmail.com', '2008-01-15');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST600', 'Anthony', 'Kwami', '+23377721989', 'Osu Avenue 9', 'kwami@gmail.com', '2021-08-05');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate,EndDate)values('ST700', 'Arnold', 'Asante', '+233-11100089', 'Haatso 4th Street', 'arnold@gmail.com', '2021-06-01', '2021-08-30');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST800', 'Gifty', 'Quansah', '+23334567989', 'Okpotsi Avenue', 'gifty@gmail.com', '2009-08-02');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST900', 'Ato', 'Klubi', '+2330005689', 'Padmore Street', 'ato@gmail.com', '2011-07-09');
insert into Staff(StaffID,FirstName,LastName,Telephone,Address,Email,StartDate)values('ST101', 'Samuel', 'Amponsah', '+23357882189', 'Adentan 48th Street', 'samuel@gmail.com', '2008-05-15');


insert into Driver(DriverID,LicenseNumber,TrafficViolationRecord)values('ST100', 'D1203-435-245', '2 Overspeeding');
insert into Driver(DriverID,LicenseNumber,TrafficViolationRecord)values('ST900', 'D1203-406-222', '1 Overspeeding, 4 Overloading');

insert into Salesperson(SalespersonID,CommissionRate,SalesQuota)values('ST400', 23.8, 100);
insert into Salesperson(SalespersonID,CommissionRate,SalesQuota)values('ST800', 20.4, 80);

insert into Intern(InternID,Institution,Major)values('ST300', 'NAFTI', 'Information Technology');
insert into Intern(InternID,Institution,Major)values('ST700', 'Academic City', 'Computer Science');

insert into Technician(TechnicianID ,ExpertiseArea,ExperienceStartYear)values('ST200', 'laptops', '2006');
insert into Technician(TechnicianID ,ExpertiseArea,ExperienceStartYear)values('ST600', 'UPS', '2010');
insert into Technician(TechnicianID ,ExpertiseArea,ExperienceStartYear)values('ST101', 'system units', '2005');

insert into Manager(ManagerID,YearsOfExperience,MaritalStatus)values('ST500', '2001', 'Single');


insert into Truck(TruckID,LicensePlate,Make,Model,ManufactureYear)values('T100', 'GT-222-15', 'Toyota', 'Hilux', '2007');
insert into Truck(TruckID,LicensePlate,Make,Model,ManufactureYear)values('T200', 'GT-136-12', 'Chevrolet', 'Cruze', '2010');
insert into Truck(TruckID,LicensePlate,Make,Model,ManufactureYear)values('T300', 'GT-12-17', 'Honda', 'Accord', '2016');
insert into Truck(TruckID,LicensePlate,Make,Model,ManufactureYear)values('T400', 'GT-100-19', 'Ford', 'F150', '2018');
insert into Truck(TruckID,LicensePlate,Make,Model,ManufactureYear)values('T500', 'GS-136-22', 'Toyota', 'Prado', '2019');


insert into Product(ProductID,ProductType,Cost,StockQuantity)values('P100', 'printers', 5300.99, 20);
insert into Product(ProductID,ProductType,Cost,StockQuantity)values('P200', 'scanners', 4500.99, 20);
insert into Product(ProductID,ProductType,Cost,StockQuantity)values('P300', 'system units', 8000.50, 10);
insert into Product(ProductID,ProductType,Cost,StockQuantity)values('P400', 'laptops', 20000.00, 20);
insert into Product(ProductID,ProductType,Cost,StockQuantity)values('P500', 'UPS', 15000.00, 10);
insert into Product(ProductID,ProductType,Cost,StockQuantity)values('P600', 'computer monitors', 2505.90, 20);


insert into RepairsService(RepairsServiceID,RepairsName,Cost)values('R100', 'printers', 500);
insert into RepairsService(RepairsServiceID,RepairsName,Cost)values('R200', 'scanners', 300);
insert into RepairsService(RepairsServiceID,RepairsName,Cost)values('R300', 'system units', 1000);
insert into RepairsService(RepairsServiceID,RepairsName,Cost)values('R400', 'laptops', 700);
insert into RepairsService(RepairsServiceID,RepairsName,Cost)values('R500', 'UPS', 1200);
insert into RepairsService(RepairsServiceID,RepairsName,Cost)values('R600', 'computer monitors', 950);


insert into Payment(PaymentID,PaymentDate,PaymentTime,Amount,PaymentMethod)values('PM100', '2022-09-12', '19:30:10', 4500, 'cash');
insert into Payment(PaymentID,PaymentDate,PaymentTime,Amount,PaymentMethod)values('PM200', '2022-01-25', '13:36:20', 15000, 'MOMO');
insert into Payment(PaymentID,PaymentDate,PaymentTime,Amount,PaymentMethod)values('PM300', '2022-07-23', '09:05:10', 5300, 'POS');
insert into Payment(PaymentID,PaymentDate,PaymentTime,Amount,PaymentMethod)values('PM400', '2015-09-12', '16:30:10', 1000, 'debit card');
insert into Payment(PaymentID,PaymentDate,PaymentTime,Amount,PaymentMethod)values('PM500', '2022-11-01', '14:23:11', 700, 'cash');


insert into ProductPayment(ProductPaymentID,PaymentID,Discount)values('PP100', 'PM200', 5.2);
insert into ProductPayment(ProductPaymentID, PaymentID)values('PP200','PM100');
insert into ProductPayment(ProductPaymentID,PaymentID, Discount)values('PP300', 'PM300', 2.5);

insert into RepairsPayment(RepairsPaymentID,PaymentID, ServicerTip)values('RP100', 'PM500', 100);
insert into RepairsPayment(RepairsPaymentID,PaymentID, ServicerTip)values('RP200', 'PM400', 50);

insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD100', '2022-11-02', 3, 'ST100', 'T100');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD200', '2021-10-02', 0, 'ST100', 'T200');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD300', '2022-10-24', 6, 'ST100', 'T300');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD400', '2021-12-06', 2, 'ST100', 'T400');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD500', '2022-11-02', 0, 'ST100', 'T500');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD600', '2021-11-02', 0, 'ST900', 'T500');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD700', '2022-01-02', 2, 'ST900', 'T400');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD800', '2022-07-13', 5, 'ST900', 'T300');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD900', '2022-08-02', 0, 'ST900', 'T200');
insert into TruckDriver(TruckDriverID,DriveDate,FuelRefills,DriverID,TruckID)values('TD101', '2021-08-15', 4, 'ST900', 'T100');


insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC100', '2022-10-09', '13:00:01', 'ST400', 'P500', 'C300', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,InternID,ProductID,CustomerID,
ProductPaymentID)values('PC200', '2022-01-19', '15:00:01', 'ST400', 'ST300', 'P400', 'C100', 'PP200');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,InternID,ProductID,CustomerID,
ProductPaymentID)values('PC300', '2022-01-19', '15:30:01', 'ST800', 'ST700', 'P600', 'C200', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,InternID,ProductID,CustomerID,
ProductPaymentID)values('PC400', '2021-01-19', '16:00:01', 'ST400', 'ST300', 'P200', 'C400', 'PP300');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC500', '2022-01-29', '15:56:01', 'ST800','P200', 'C700', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC600', '2022-05-20', '15:58:01', 'ST400','P600', 'C500', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC700', '2022-01-29', '15:56:01', 'ST400','P400', 'C600', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC800', '2022-01-29', '15:56:01', 'ST800','P100', 'C800', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC900', '2022-01-29', '15:56:01', 'ST800','P500', 'C900', 'PP100');
insert into ProductCustomer(ProductCustomerID,PurchaseDate,PurchaseTime,SalespersonID,ProductID,CustomerID,
ProductPaymentID)values('PC101', '2022-07-05', '15:56:01', 'ST800','P300', 'C101', 'PP100');


insert into RepairsCustomer(RepairsCustomerID,LoginDate,LogoutDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC100', '2022-07-05', '2022-07-08', 'C101', 'R100', 'ST200','ST300','RP100','P100');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC200', '2022-01-14','C100', 'R200', 'ST600','ST300','RP200','P200');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,LogoutDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC300', '2022-07-05', '2022-07-06', 'C200', 'R100', 'ST200','ST700','RP100','P100');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC400', '2022-07-05', 'C300', 'R600', 'ST200','ST700','RP100','P600');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,LogoutDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC500', '2022-11-05', '2022-11-05', 'C400', 'R300', 'ST600','ST300','RP200','P300');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC600', '2022-10-25', 'C800', 'R500', 'ST600','ST700','RP100','P500');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,LogoutDate,CustomerID,RepairsServiceID,TechnicianID,RepairsPaymentID,ProductID)
values('RC700', '2022-07-05', '2022-07-08', 'C700', 'R400', 'ST200','RP100','P400');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,LogoutDate,CustomerID,RepairsServiceID,TechnicianID,RepairsPaymentID,ProductID)
values('RC800', '2022-07-05', '2022-07-08', 'C600', 'R100', 'ST200','RP100','P100');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,CustomerID,RepairsServiceID,TechnicianID,RepairsPaymentID,ProductID)
values('RC900', '2022-07-05', 'C900', 'R500', 'ST600','RP200','P500');
insert into RepairsCustomer(RepairsCustomerID,LoginDate,LogoutDate,CustomerID,RepairsServiceID,TechnicianID,InternID,RepairsPaymentID,ProductID)
values('RC101', '2022-07-05', '2022-07-28', 'C200', 'R100', 'ST600','ST700','RP200','P100');


insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS100', '2021-09-15', 'Michael', 'Annan', '3456754321', 'P100', 'S100');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS200', '2022-09-15', 'Amos', 'Debrah', '34454654321', 'P100', 'S200');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS300', '2022-11-15', 'Seyram', 'Adonu', '1243546577', 'P200', 'S300');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS400', '2022-09-25', 'Serick', 'Mensah', '2134536475', 'P300', 'S300');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS500', '2022-08-15', 'Oliver', 'Ngong', '1234567787', 'P400', 'S400');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS600', '2021-09-15', 'Dickson', 'Akubia', '3456754321', 'P500', 'S100');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS700', '2022-12-12', 'Kelvin', 'Anim', '04457685432', 'P200', 'S500');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS800', '2022-07-05', 'Keli', 'Tagoe', '02035868432', 'P400', 'S400');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS900', '2022-08-15', 'Precious', 'Annan', '3000454321', 'P400', 'S300');
insert into ProductSupplier(ProductSupplierID,SupplyDate,AgentFirstName,AgentLastName,AgentContact,ProductID,SupplierID)values('PS101', '2022-09-15', 'David', 'Nobi', '37688756921', 'P600', 'S400');


insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D100', '15:09:00', '2022-11-18', 'completed', 'TD100', 'PC100');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D200', '16:09:00', '2022-11-25', 'completed', 'TD200', 'PC200');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D300', '12:01:00', '2022-10-15', 'in progress', 'TD100', 'PC300');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D400', '15:09:00', '2022-05-15', 'completed', 'TD400', 'PC400');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D500', '15:09:00', '2022-06-27', 'completed', 'TD500', 'PC500');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D600', '15:09:00', '2021-07-11', 'completed', 'TD400', 'PC600');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D700', '15:09:00', '2022-08-25', 'completed', 'TD600', 'PC700');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D800', '15:29:00', '2022-01-23', 'in progress', 'TD700', 'PC800');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D900', '11:19:00', '2022-11-16', 'completed', 'TD900', 'PC900');
insert into Delivery(DeliveryID,DeliveryTime,DeliveryDate,DeliveryStatus,TruckDriverID,ProductCustomerID)values('D101', '09:09:00', '2022-11-20', 'in progress', 'TD101', 'PC101');


-- QUERY 1
/*Identify the suppliers of products that keep returning for repairs.*/
SELECT Supplier.SupplierName AS 'Supplier Name', COUNT(RepairsCustomer.ProductID) AS 'Number of Returns'
FROM Supplier
JOIN ProductSupplier ON Supplier.SupplierID = ProductSupplier.SupplierID
JOIN RepairsCustomer ON ProductSupplier.ProductID = RepairsCustomer.ProductID
GROUP BY Supplier.SupplierName
HAVING COUNT(RepairsCustomer.ProductID) > 0
ORDER BY COUNT(RepairsCustomer.ProductID) DESC;


-- QUERY 2 (SUBQUERY)
/*Retrieve data on all company products and the quantity that each salesperson has sold.*/
Select CONCAT(Staff.FirstName, " ", Staff.LastName) AS Staff_Name,
Salesperson.SalespersonID AS StaffID, ProductType AS Products_Sold, COUNT(ProductType) As Quantity_Sold
from Staff, Salesperson, Product
where exists (
	select * from ProductCustomer
	where Salesperson.SalespersonID = ProductCustomer.SalespersonID 
    and Product.ProductID= ProductCustomer.ProductID and Staff.StaffID = Salesperson.SalespersonID)
    group by Product.ProductID;
    

-- QUERY 3
/*Query to retrieve data on different products that our supplier supplies to the company*/
select SupplierName, ProductType, Product.StockQuantity, SupplyDate
from ProductSupplier
join Supplier on ProductSupplier.SupplierID = Supplier.SupplierID
join Product on ProductSupplier.ProductID = Product.ProductID
group by ProductType
order by SupplyDate;


-- QUERY 4
/*Retrieve data on customers' products that have been delivered and those yet to be delivered to them*/
SELECT ProductType, Customer.CustomerID, DeliveryStatus
FROM ProductCustomer
INNER JOIN Product ON ProductCustomer.ProductID = Product.ProductID
INNER JOIN Customer ON ProductCustomer.CustomerID = Customer.CustomerID
JOIN Delivery on ProductCustomer.ProductCustomerID = Delivery.ProductCustomerID
group by CustomerID;


-- QUERY 5
/*Retrieve Data on repairs services that are yet to be completed and the staff in charge of the repairs*/
SELECT RepairsName, CONCAT(Staff.FirstName, " ", Staff.LastName) AS Staff_Assigned, LogoutDate
from RepairsCustomer
INNER JOIN Staff ON RepairsCustomer.TechnicianID = Staff.StaffID
INNER JOIN RepairsService ON RepairsCustomer.RepairsServiceID = RepairsService.RepairsServiceID
where LogoutDate IS NULL;


-- QUERY 6
/*Retrieve data on products that have accrued revenue for the company based on payments made by customers.*/
SELECT ProductType, SUM(Payment.Amount) AS Total_Amount, PaymentDate
from ProductCustomer
JOIN Product on ProductCustomer.ProductID = Product.ProductID
JOIN ProductPayment on ProductCustomer.ProductPaymentID = ProductPayment.ProductPaymentID
JOIN Payment on ProductPayment.PaymentID = Payment.PaymentID
group by ProductPayment.PaymentID
order by PaymentDate;
