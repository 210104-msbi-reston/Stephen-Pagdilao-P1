--------Continent---------
Create table Continent(
	ContinentID int not null Identity(1,1) primary key,
	ContinentName varchar(20) not null
);

--------Country---------
Create table Country(
	CountryID int not null identity(1,1) primary key,
	ContinentName varchar(100) not null,
	ContinentID int foreign key references Continent(ContinentID) On delete set null,
	Taxes decimal(5,4) default(0.08),
	Population int
);


--------ProductionHouse---------
Create table ProductionHouse(
	ProductionHouseID int not null identity(1,1) primary key,
	Date date default(getdate()),
	ProductionHouseName varchar(20) not null
);

alter table ProductionHouse
add ContinentID int foreign key references Continent(ContinentID)

--------Warehouse---------
Create table Warehouse(
	WarehouseID int not null identity(1,1) primary key,
	WarehouseName varchar(20) not null
);

alter table Warehouse
add CountryID int foreign key references Country(CountryID);

alter table Warehouse
add DistributorID int foreign key references Distributor(DistributorID)

--------Join table between ProductionHouse and Warehouse---------
Create table ProductionHouseWarehouses(
	ProductionHouseID int not null foreign key references ProductionHouse(ProductionHouseID),
	WarehouseID int not null foreign key references Warehouse(WarehouseID),
	primary key(ProductionHouseID, WarehouseID),
);

--------ProductDetails---------
Create table ProductDetails(
	SerialNumber int not null identity(1,1) primary key,
	Cost smallmoney not null
);

alter table ProductDetails
add ProductionHouseID int foreign key references ProductionHouse(ProductionHouseID)

alter table ProductDetails
add WarehouseID int foreign key references Warehouse(WarehouseID)

alter table ProductDetails
add DistributorID int foreign key references Distributor(DistributorID)

alter table ProductDetails
add SubDistributorID int foreign key references SubDistributor(SubDistributorID)

alter table ProductDetails
add ChannelPartnerID int foreign key references ChannelPartner(ChannelPartnerID)

alter table ProductDetails
add StoreID int foreign key references Store(StoreID)

alter table ProductDetails
add CustomerID int foreign key references Customer(SSN)

alter table ProductDetails
add ProductID int foreign key references ProductList(ProductID)

alter table ProductDetails
add ProductionHouseDate date

alter table ProductDetails
add WarehouseDate date

alter table ProductDetails
add DistributorDate date

alter table ProductDetails
add SubDistributorDate date

alter table ProductDetails
add ChannelPartnerDate date

alter table ProductDetails
add StoreDate date

alter table ProductDetails
add PurchaseDate date


--------Distributor---------
Create table Distributor(
	DistributorID int not null identity(1,1) primary key,
	DistributorName varchar(20)
);

alter table Distributor
add CountryID int unique foreign key references Country(CountryID)

alter table Distributor --makes it unique
add constraint FK_CountryID_Unique unique(CountryID)

--------SubDistributor---------
Create table SubDistributor(
	SubDistributorID int not null identity(1,1) primary key,
	SubDistrbutorName varchar(20)
);

alter table SubDistributor
add DistributorID int foreign key references Distributor(DistributorID)

--------ChannelPartner---------
Create table ChannelPartner(
	ChannelPartnerID int not null identity(1,1) primary key,
	ChannelPartnerName varchar(20)
);

alter table ChannelPartner
add SubDistributorID int foreign key references SubDistributor(SubDistributorID)

--------Zone---------
Create table Zone(
	ZoneID int not null identity(1,1) primary key,
	ZoneName varchar(20)
);

alter table Zone
add ChannelPartnerID int foreign key references ChannelPartner(ChannelPartnerID)
alter table Zone
add constraint ChannelPartnerID_Unique unique(ChannelPartnerID)

--------Store---------
Create table Store(
	StoreID int not null identity(1,1) primary key,
	StoreName varchar(20),
);

alter table Store
add ZoneID int foreign key references Zone(ZoneID)

--------Join Table for Store to Customers---------
Create table StoreCustomers(
	StoreID int not null foreign key references Store(StoreID),
	CustomerSSN int not null foreign key references Customer(SSN),
	primary key (StoreID,CustomerSSN)
);

--------Customer---------
Create table Customer(
	SSN int not null primary key,
	Name varchar(20),
);

alter table Customer
add CountryID int foreign key references Country(CountryID)