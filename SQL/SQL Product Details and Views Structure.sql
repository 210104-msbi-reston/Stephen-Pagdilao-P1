/****** Script for SelectTopNRows command from SSMS  ******/
select * from ProductList
select * from ProductDetails

select pd.SerialNumber, pl.DeviceName,pl.BaseCost, pd.Cost, c.CountryName  from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID
inner join Warehouse w on w.WarehouseID = pd.WarehouseID
inner join Country c on c.CountryID = w.CountryID

select * from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID
inner join Warehouse w on w.WarehouseID = pd.WarehouseID
inner join Country c on c.CountryID = w.CountryID

--Check If channel partner is under a sub distributor
select * from SubDistributor sd
inner join ChannelPartner cp on cp.SubDistributorID = sd.SubDistributorID
where sd.SubDistributorID = 46

-----------------------------------------Views--------------------------------------------

-------------------------------------NORTH AMERICA----------------------------------------
-------PRODUCTION HOUSE MANAGER--------
--Overview
alter view ProductHouseManagerViewInNorthAmerica
as
select pd.SerialNumber as [Product Serial Number],
pl.DeviceName as [Device Name],
pl.BaseCost as [Product Cost],
ph.ProductionHouseName as [Production House Name],
ph.ProductionHouseID as [Production House ID],
pd.ProductionHouseDate as [Date Created]
from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID 
inner join Continent c on c.ContinentID = ph.ContinentID
where c.ContinentID = 1

select * from ProductHouseManagerViewInNorthAmerica

--Statistics
alter view ProductHouseManagerStatisticsViewInNorthAmerica
as
select ph.ProductionHouseID as [Production House ID],
count(pd.SerialNumber) as [Total Products Created],
avg(pl.BaseCost) as [Average Cost Per Product],
count(pd.WarehouseID) as [Total Products Shipped]
from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID 
inner join Continent c on c.ContinentID = ph.ContinentID
where c.ContinentID = 1
group by ph.ProductionHouseID

select * from ProductHouseManagerStatisticsViewInNorthAmerica

-------WAREHOUSE MANAGER--------
--Overview
alter view WarehouseManagerViewInNorthAmerica
as
select w.WarehouseID as [Warehouse ID],
w.WarehouseName as [Warehouse Name],
pd.SerialNumber as [Product Serial Number],
pl.DeviceName as [Device Name],
pl.BaseCost as [Product Base Cost],
Convert(Decimal(5,2),(pl.BaseCost+(pl.BaseCost * ct.Taxes/100))) as [Total Product Cost],
ph.ProductionHouseName as [Production House Name],
pd.WarehouseDate as [Date Received],
ct.CountryName
from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID 
inner join Continent c on c.ContinentID = ph.ContinentID
inner join Warehouse w on w.WarehouseID = pd.WarehouseID
inner join Country ct on ct.CountryID = w.CountryID
where c.ContinentID = 1

select * from WarehouseManagerViewInNorthAmerica

--Statistics
alter view WarehouseManagerStatisticsViewInNorthAmerica
as
select w.WarehouseID as [Warehouse ID],
count(w.WarehouseID) as [Total Products Received],
Convert(Decimal(5,2),avg((pl.BaseCost+(pl.BaseCost * ct.Taxes/100)))) as [Average Cost Per Product],
count(pd.DistributorID) as [Total Products Shipped],
count(w.WarehouseID) - count(pd.DistributorID) as [In Stock]
from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID 
inner join Continent c on c.ContinentID = ph.ContinentID
inner join Warehouse w on w.WarehouseID = pd.WarehouseID
inner join Country ct on ct.CountryID = w.CountryID
where c.ContinentID = 1
group by w.WarehouseID

select * from WarehouseManagerStatisticsViewInNorthAmerica

--Specific details what product is in stock

-------DISTRIBUTOR MANAGER--------
--Overview
alter view DistributorManagerViewInNorthAmerica
as
select d.DistributorID as [Distributor ID],
d.DistributorName as [Distributor Name],
pd.SerialNumber as [Product Serial Number],
pl.DeviceName as [Device Name],
Convert(Decimal(5,2),(pl.BaseCost + pl.BaseCost*ct.Taxes/100)*8/100) as [Revenue],
Convert(Decimal(5,2),(pl.BaseCost + pl.BaseCost*ct.Taxes/100)+(pl.BaseCost + pl.BaseCost*ct.Taxes/100)*8/100) as [Total Product Cost],
pd.DistributorDate as [Date Received],
w.WarehouseName as [Warehouse Name],
ct.CountryName
from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID 
inner join Continent c on c.ContinentID = ph.ContinentID
inner join Warehouse w on w.WarehouseID = pd.WarehouseID
inner join Country ct on ct.CountryID = w.CountryID
inner join Distributor d on d.DistributorID = w.DistributorID
where c.ContinentID = 1 and pd.DistributorDate is not null

select * from DistributorManagerViewInNorthAmerica

--Statistical
create view DistributorManagerStatisticsViewInNorthAmerica
as
select d.DistributorID as [Distributor ID],
count(d.DistributorID) as [Total Products Received],
Convert(decimal(5,2), avg((pl.BaseCost + pl.BaseCost*ct.Taxes/100)*8/100)) as [Average Revenue per Product],
Convert(Decimal(5,2),avg((pl.BaseCost + pl.BaseCost*ct.Taxes/100)+(pl.BaseCost + pl.BaseCost*ct.Taxes/100)*8/100)) as [Average Cost Per Product],
count(pd.ChannelPartnerID) as [Total Products Shipped],
count(d.DistributorID) - count(pd.ChannelPartnerID) as [In Stock]
from ProductDetails pd
inner join ProductList pl on pd.ProductID = pl.ProductID
inner join ProductionHouse ph on ph.ProductionHouseID = pd.ProductionHouseID 
inner join Continent c on c.ContinentID = ph.ContinentID
inner join Warehouse w on w.WarehouseID = pd.WarehouseID
inner join Country ct on ct.CountryID = w.CountryID
inner join Distributor d on d.DistributorID = w.DistributorID
where c.ContinentID = 1
group by d.DistributorID

select * from DistributorManagerStatisticsViewInNorthAmerica

-------SUBDISTRIBUTOR MANAGER--------



--Delete statements--
delete from ProductList
dbcc checkident('ProductList',reseed,0)

delete from ProductDetails
dbcc checkident('ProductDetails', reseed, 111111111)