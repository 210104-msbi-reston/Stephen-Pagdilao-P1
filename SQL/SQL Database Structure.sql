/****** Script for SelectTopNRows command from SSMS  ******/
select * from Continent
select * from Country
select * from ProductionHouse
select * from ProductionHouseWarehouses
select * from Warehouse
select * from Distributor
select * from SubDistributor
select * from ChannelPartner
select * from Zone
select * from Store

--Gets countries from a continent
select ct.Name,c.CountryName from Country c 
inner join Continent ct on c.ContinentID = ct.ContinentID

--Gets the total production house for each continent
select count(*) as [Total Production House], c.Name ContinentID from ProductionHouse ph
inner join Continent c on c.ContinentID = ph.ContinentID
group by c.Name

--Gets the total countries for each continent
select count(*) as [Total Countries], c.Name from Country ct
inner join Continent c on c.ContinentID = ct.ContinentID
group by c.Name

--Gets the warehouse list from a production house
select ct.Name as [Continent Name],c.CountryName,w.WarehouseName, ph.ProductionHouseName from Warehouse w
inner join ProductionHouseWarehouses phw on phw.WarehouseID = w.WarehouseID
inner join ProductionHouse ph on ph.ProductionHouseID = phw.ProductionHouseID
inner join Country c on c.CountryID = w.CountryID
inner join Continent ct on ct.ContinentID = c.ContinentID
-- where c.CountryID = 8
where ph.ProductionHouseID = 5

--Calculation that determines how many sub-distributor in a country will have based on population
select (round(c.Population*0.00000035, 0)+1) as [Total SubDistributor] ,
c.Population,
c.CountryName,
c.CountryID from Country c
order by c.Population desc

--Get sub-distributor from a country
select sd.SubDistrbutorName, d.DistributorName, c.CountryName, c.CountryID from SubDistributor sd
inner join Distributor d on d.DistributorID = sd.DistributorID
inner join Country c on c.CountryID = d.CountryID
where c.CountryName = 'China'

--Calculation that determines how many channel partner in a country will have based on population
select (round(c.Population*0.000000035, 0)+1) as [Total SubDistributor] ,
c.Population,
c.CountryName from Country c
order by c.Population desc

--Get list of channel partner from a subdistributor
select cp.ChannelPartnerName,sd.SubDistrbutorName,sd.SubDistributorID, d.DistributorName, c.CountryName from ChannelPartner cp
inner join SubDistributor sd on sd.SubDistributorID = cp.SubDistributorID
inner join Distributor d on d.DistributorID = sd.DistributorID
inner join Country c on c.CountryID = d.CountryID
where d.DistributorID = 100

------------Delete records-----------
  delete from Country
  dbcc checkident('Country', reseed, 0)

    delete from Distributor
  dbcc checkident('Distributor', reseed, 0)

    delete from Warehouse
  dbcc checkident('Warehouse', reseed, 0)

    delete from ProductionHouse
  dbcc checkident('ProductionHouse', reseed, 0)

  delete from SubDistributor
  dbcc checkident('SubDistributor', reseed, 0)

  delete from ChannelPartner
  dbcc checkident('ChannelPartner', reseed, 0)

  delete from Zone
    dbcc checkident('Zone', reseed, 0)

    delete from ProductionHouseWarehouses