---------------------------Functions---------------------------

--Gives a random sale tax
alter function GiveManufactureTax(@basetax int, @rand float)
returns float
as
begin
	declare @manufactureTax float = (@basetax + @rand)
	return @manufactureTax
end

select round(dbo.GiveManufactureTax(1745,rand()), 0)

--Gives the amount of production house depending on continent's population
alter function GiveProductionHouseAmount(@ContinentID int)
returns int
as
begin
	return (select round(sum(c.Population)*0.000000035, 0)
			from Country c
			where c.ContinentID = @ContinentID)
end


select dbo.GiveProductionHouseAmount(4) --Tests function

--Gives random Date
alter function GiveRandomDate(
	@CurrentDate datetime,
	@rand float
)
returns date
as
begin
	declare @FutureDate datetime = (dateadd(DAY, round(dbo.GiveManufactureTax(2,@rand*15),0), @CurrentDate))
	return format(@FutureDate,'d','en-US')
end

select dbo.GiveRandomDate(GETDATE(),rand())

--Gives random Production House ID
alter function GiveRandomProductionHouseID(
	@CountryID int,
	@rand float
)
returns int
as
begin
	return (select round(dbo.GiveManufactureTax(min(ph.ProductionHouseID),@rand*(max(ph.ProductionHouseID)-min(ph.ProductionHouseID))),0)
			from ProductionHouse ph
			inner join Country c on c.ContinentID = ph.ContinentID
			where c.CountryID = @CountryID)
end

--Gives random Warehouse ID
create function GiveRandomWarehouseID(
	@CountryID int,
	@rand float
)
returns int
as
begin
	return (select round(dbo.GiveManufactureTax(min(w.WarehouseID),@rand*(max(w.WarehouseID)-min(w.WarehouseID))),0)
			from Warehouse w
			inner join Country c on c.CountryID = w.CountryID
			where c.CountryID = @CountryID)
end

--Give random SubDistributor ID
alter function GiveRandomSubDistributorID(
	@CountryID int,
	@rand float
)
returns int
as
begin
	return (select round(dbo.GiveManufactureTax(min(sd.SubDistributorID),@rand*(max(sd.SubDistributorID)-min(sd.SubDistributorID))),0)
			from SubDistributor sd
			inner join Distributor d on d.DistributorID = sd.DistributorID
			inner join Country c on c.CountryID = d.CountryID
			where c.CountryID = @CountryID)
end

--Give random Channel Partner ID
alter function GiveRandomChannelPartnerID(
	@SubDistributorID int,
	@rand float
)
returns int
as
begin
	return (select round(dbo.GiveManufactureTax(min(cp.ChannelPartnerID),@rand*(max(cp.ChannelPartnerID)-min(cp.ChannelPartnerID))),0)
			from ChannelPartner cp
			inner join SubDistributor sd on sd.SubDistributorID = cp.SubDistributorID
			inner join Distributor d on d.DistributorID = sd.DistributorID
			where cp.SubDistributorID = @SubDistributorID)
end

--Give random Zone ID by SubDistributor
alter function GiveRandomZoneID(
	@SubDistributorID int,
	@rand float
)
returns int
as
begin
	return (select round(dbo.GiveManufactureTax(min(z.ZoneID),@rand*(max(z.ZoneID)-min(z.ZoneID))),0)
			from Zone z
			inner join ChannelPartner cp on z.ChannelPartnerID = cp.ChannelPartnerID
			inner join SubDistributor sd on sd.SubDistributorID = cp.SubDistributorID
			where sd.SubDistributorID = @SubDistributorID)
end

--Give random Store ID
alter function GiveRandomStoreID(
	@ChannelPartnerID int,
	@rand float
)
returns int
as
begin
	declare @ZoneID int = (select round(dbo.GiveManufactureTax(min(z.ZoneID),@rand*(max(z.ZoneID)-min(z.ZoneID))),0)
							from Zone z
							inner join ChannelPartner cp on z.ChannelPartnerID = cp.ChannelPartnerID
							where cp.ChannelPartnerID = @ChannelPartnerID)

	return (select round(dbo.GiveManufactureTax(min(s.StoreID),@rand*(max(s.StoreID)-min(s.StoreID))),0)
			from Store s
			inner join Zone z on z.ZoneID = s.StoreID
			inner join ChannelPartner cp on z.ChannelPartnerID = cp.ChannelPartnerID
			inner join SubDistributor sd on sd.SubDistributorID = cp.SubDistributorID
			where cp.ChannelPartnerID = @ChannelPartnerID and z.ZoneID = @ZoneID)
end


--Gives random country ID
alter function GiveRandomCountryID(
	@ContinentID int,
	@rand float
)
returns int
as
begin
	return (select round(dbo.GiveManufactureTax(min(c.CountryID), @rand*(max(c.CountryID)-min(c.CountryID))),0)
			from Country c 
			where c.ContinentID = @ContinentID)
end

select max(c.CountryID), min(c.CountryID), round(dbo.GiveManufactureTax(min(c.CountryID), rand()*(max(c.CountryID)-min(c.CountryID))),0) from Country c --Randomly chooses a production house assigned to that country
where c.ContinentID = 1

--Give the total countries
alter function GiveTotalCountriesFromContinent(
	@ContinentID int
)
returns int
as
begin
	return (select count(*) from Country 
			where ContinentID = @ContinentID)
end


---------------------------Procedure---------------------------
--Stored Procedure for Production House Table
alter procedure proc_ProductionHouse(
	@action varchar(20),
	@ContinentIDParam int = null,
	@WarehouseIDParam int = null
)
as
begin
	declare @rand int
	declare @ProductionHouseID int

	if(@action = 'Create') --Creates a production house w/ random name
	begin
		declare @Name varchar(50)

		set @rand = round(dbo.GiveManufactureTax(9,rand()*20),0)
		set @Name = ( --Randomize name
			case
				when @rand = 9 then 'WaterGate Production'
				when @rand = 10 then 'Looking Glass Production'
				when @rand = 11 then 'Continnum Production'
				when @rand = 12 then 'Half Moon Production'
				when @rand = 13 then 'Green Fuzz Production'
				when @rand = 14 then 'DNA Production'
				when @rand = 15 then 'Giggle Production'
				when @rand = 16 then 'Sandstone Production'
				when @rand = 17 then 'Spinning Wheel Production'
				when @rand = 18 then 'Brain Stew Production'
				when @rand = 19 then 'Stillwater Production'
				when @rand = 20 then 'ThirdEye Production'
				when @rand = 21 then 'Diftwood Production'
				when @rand = 22 then 'Stardust Production'
				when @rand = 23 then 'Watermark Production'
				when @rand = 24 then 'TwinSpas Production'
				when @rand = 25 then 'Farwide Production'
				when @rand = 26 then 'Moving Production'
				when @rand = 27 then 'ReelGood Production'
				when @rand = 28 then 'InterProduction'
				when @rand = 29 then 'MetroProduction'
				when @rand = 30 then 'Electronic Production'
				when @rand = 31 then 'Slazer Production'
				when @rand = 32 then 'Taszz Production'
			end
		)

		insert into ProductionHouse(ProductionHouseName, ContinentID) values(@Name, @ContinentIDParam)
	end

	if(@action = 'AssignToWarehouse') --Assign production house to warehouse randomly
	begin
		declare @HowManyPH int = (select count(*) from ProductionHouse where ProductionHouse.ContinentID = @ContinentIDParam)
		set @rand = (select round(dbo.GiveManufactureTax(1,rand()*20), 0))

		if (@HowManyPH < 4)
		begin --Creates production house and assign country to it
			exec proc_ProductionHouse 'Create', @ContinentIDParam
			set @ProductionHouseID = (select max(p.ProductionHouseID) from ProductionHouse p)
			insert into ProductionHouseWarehouses(ProductionHouseID, WarehouseID) values(@ProductionHouseID, @WarehouseIDParam)
		end
		else
		begin
			if (@rand > 15) --Currently 25%
			begin --Creates production house and assign country to it
				exec proc_ProductionHouse 'Create', @ContinentIDParam
				set @ProductionHouseID = (select max(p.ProductionHouseID) from ProductionHouse p)
				insert into ProductionHouseWarehouses(ProductionHouseID, WarehouseID) values(@ProductionHouseID, @WarehouseIDParam)
			end
			else
			begin --Randomly assigns a production house to country
				set @ProductionHouseID = (select round(max(p.ProductionHouseID) - dbo.GiveManufactureTax(0,rand()*(count(p.productionHouseID)-1)),0) 
										from ProductionHouse p
										where p.ContinentID = @ContinentIDParam)
				insert into ProductionHouseWarehouses(ProductionHouseID, WarehouseID) values(@ProductionHouseID, @WarehouseIDParam)
			end
		end
	end
end

--Creates Distributors
alter procedure proc_CreateDistributor(
	@CountryID int
)
as
begin
	declare @name varchar(50)
	declare @rand int = round(dbo.GiveManufactureTax(9,rand()*20),0)
	set @name = ( --Randomize name
		case 
			when @rand = 9 then 'Whole Order'
			when @rand = 10 then 'Order Pros'
			when @rand = 11 then 'Strict Supply'
			when @rand = 12 then 'Happy Distributers'
			when @rand = 13 then 'Inventory Wholesale'
			when @rand = 14 then 'Bulk Demand'
			when @rand = 15 then 'You To Retail'
			when @rand = 16 then 'Glorious Goods'
			when @rand = 17 then 'Bounty Of Goods'
			when @rand = 18 then 'Wholesale Solutions'
			when @rand = 19 then 'The Wholesale Bazaar Co.'
			when @rand = 20 then 'Budget Wholesale'
			when @rand = 21 then 'Wholesale Dealers'
			when @rand = 22 then 'The Wholesale Merchant Co.'
			when @rand = 23 then 'Wholesale Store'
			when @rand = 24 then 'Wholesale Outlets'
			when @rand = 25 then 'District Wholesale'
			when @rand = 26 then 'Department'
			when @rand = 27 then 'Wholesale Operative Co'
			when @rand = 28 then 'Le marché'
			when @rand = 29 then 'The Wholesale Buys Co.'
			when @rand = 30 then 'Middle Man'
			when @rand = 31 then 'Distribution To Home'
			when @rand = 32 then 'Distribution Queen'
		end
	)

	insert into Distributor(DistributorName, CountryID) values(@name, @CountryID)
end

--Creates Warehouses
alter procedure proc_CreateWarehouse(
	@CountryID int,
	@DistributorID int
)
as
begin
	declare @rand int
	declare @name varchar(20)
	set @rand = round(dbo.GiveManufactureTax(9,rand()*20),0)

	set @name = ( --Randomize name
		case 
			when @rand = 9 then 'Fovty'
			when @rand = 10 then 'Doroly'
			when @rand = 11 then 'Ziofy'
			when @rand = 12 then 'Niollo'
			when @rand = 13 then 'Vozzby'
			when @rand = 14 then 'Worivo'
			when @rand = 15 then 'Hiputi'
			when @rand = 16 then 'Warivo'
			when @rand = 17 then 'Kariox'
			when @rand = 18 then 'Wrizty'
			when @rand = 19 then 'Joniry'
			when @rand = 20 then 'Roniry'
			when @rand = 21 then 'Vravmo'
			when @rand = 22 then 'Loniry'
			when @rand = 23 then 'Wopno'
			when @rand = 24 then 'Hiolty'
			when @rand = 25 then 'Heyinz'
			when @rand = 26 then 'Zengvo'
			when @rand = 27 then 'Rumpes'
			when @rand = 28 then 'Moriox'
			when @rand = 29 then 'Woati'
			when @rand = 30 then 'Hatello'
			when @rand = 31 then 'Nolunt'
			when @rand = 32 then 'Povty'
		end
	)
		
	Insert into Warehouse(WarehouseName, CountryID, DistributorID) values(@name, @CountryID, @DistributorID)

end

exec proc_CreateWarehouse 70


--Create Sub-Distributor
alter procedure proc_CreateSubDistributor(
	@population int,
	@DistributorID int
)
as
begin
	declare @rand int
	declare @name varchar(50)
	declare @HowManySubDistributor int = (select (round(@population*0.00000035, 0)+1))
	
	while @HowManySubDistributor > 0
	begin
		select @HowManySubDistributor -= 1
		set @rand = (select round(dbo.GiveManufactureTax(9,rand()*20), 0))
		set @name = ( --Randomize name
			case 
				when @rand = 9 then 'About The Bulk'
				when @rand = 10 then 'All in One'
				when @rand = 11 then 'Bunch of Things'
				when @rand = 12 then 'Retail Distribution Bros'
				when @rand = 13 then 'Distribution Wofl'
				when @rand = 14 then 'Pearl Market'
				when @rand = 15 then 'Sell Wholesale'
				when @rand = 16 then 'LiveSale Company'
				when @rand = 17 then 'The Grocersale'
				when @rand = 18 then 'Wholesale Imported Co.'
				when @rand = 19 then 'Applied Wholesale'
				when @rand = 20 then 'SignifiSale'
				when @rand = 21 then 'Massale'
				when @rand = 22 then 'The General Wholesale Co.'
				when @rand = 23 then 'Allied Distribution Services'
				when @rand = 24 then 'American Food'
				when @rand = 25 then 'Big Market'
				when @rand = 26 then 'Cloudnormous'
				when @rand = 27 then 'Supplyspace Global'
				when @rand = 28 then 'Prima Sustenance'
				when @rand = 29 then 'Sweetsop'
				when @rand = 30 then 'Vitagrain'
				when @rand = 31 then 'Serva'
				when @rand = 32 then 'Mnexa'
			end
		)

		insert into SubDistributor(SubDistrbutorName, DistributorID) values(@name,@DistributorID)
	end
end

--Create Channel Partner
create procedure proc_CreateChannelPartner(
	@population int,
	@SubDistributorID int
)
as
begin
	declare @rand int
	declare @name varchar(50)
	declare @HowManyChannelPartner int = (select (round(@population*0.000000035, 0)+1))
	
	while @HowManyChannelPartner > 0
	begin
		select @HowManyChannelPartner -= 1
		set @rand = (select round(dbo.GiveManufactureTax(9,rand()*20), 0))
		set @name = ( --Randomize name
			case 
				when @rand = 9 then '3nom'
				when @rand = 10 then 'Acliviti'
				when @rand = 11 then 'A.F. Daniel'
				when @rand = 12 then 'ATC'
				when @rand = 13 then 'Black Box'
				when @rand = 14 then 'Bridlewood'
				when @rand = 15 then 'Bryley Systems'
				when @rand = 16 then 'Carrier Access'
				when @rand = 17 then 'CloudTech'
				when @rand = 18 then 'CTG'
				when @rand = 19 then 'Eze Castle'
				when @rand = 20 then 'CPI'
				when @rand = 21 then 'Infinit Consulting'
				when @rand = 22 then 'Liquid Networx'
				when @rand = 23 then 'Net7 Solutions'
				when @rand = 24 then 'Networks Unlimited'
				when @rand = 25 then 'Nexus'
				when @rand = 26 then 'No More Salespeople'
				when @rand = 27 then 'Opex Technologies'
				when @rand = 28 then 'Platte River Networks'
				when @rand = 29 then 'Richardson Communications'
				when @rand = 30 then 'SageNet'
				when @rand = 31 then 'TelecomQuotes'
				when @rand = 32 then 'ZLH Enterprises'
			end
		)

		insert into ChannelPartner(ChannelPartnerName, SubDistributorID) values(@name,@SubDistributorID)
	end
end

--Create a zone
create procedure proc_CreateZones(
	@ChannelPartnerID int
)
as
begin
	declare @name varchar(50)
	declare @rand float = (select round(dbo.GiveManufactureTax(9,rand()*20), 0))
	set @name = ( --Randomize name
		case 
			when @rand = 9 then 'Lower West Yeosk'
			when @rand = 10 then 'Little Smialt'
			when @rand = 11 then 'Downtown Dronnooc'
			when @rand = 12 then 'Qakreft Center'
			when @rand = 13 then 'Lower South Bogut'
			when @rand = 14 then 'Fort Shidoam'
			when @rand = 15 then 'North Shrigig'
			when @rand = 16 then 'Whoanupt District'
			when @rand = 17 then 'Scedanlialt West'
			when @rand = 18 then 'Rirrolzalf'
			when @rand = 19 then 'Little Kurd'
			when @rand = 20 then 'Glerk Row'
			when @rand = 21 then 'Lower West Ploormenk'
			when @rand = 22 then 'Diagwoc Grove'
			when @rand = 23 then 'Sannam Bazaar'
			when @rand = 24 then 'North Kewump'
			when @rand = 25 then 'Broattoork South'
			when @rand = 26 then 'Little Fropeept'
			when @rand = 27 then 'Kenurbion Wood'
			when @rand = 28 then 'Shroorrulgom Row'
			when @rand = 29 then 'Sprun Center'
			when @rand = 30 then 'Ward Bazaar'
			when @rand = 31 then 'Lower North Wramrid'
			when @rand = 32 then 'Upper Hiriasp'
		end
	)

	insert into Zone(ZoneName, ChannelPartnerID) values(@name,@ChannelPartnerID)
end

--Create a store
create procedure proc_CreateStore(
	@ZoneID int
)
as
begin
	declare @name varchar(50)
	declare @rand float = (select round(dbo.GiveManufactureTax(9,rand()*20), 0))
	set @name = ( --Randomize name
		case 
			when @rand = 9 then 'The Gadget Zone'
			when @rand = 10 then 'Agilis Electronics'
			when @rand = 11 then 'Every Gadget'
			when @rand = 12 then 'Pro Tech Gear'
			when @rand = 13 then 'The Gadget Factorie'
			when @rand = 14 then 'Tech Assault'
			when @rand = 15 then 'Connected Homes'
			when @rand = 16 then 'The Tech Cube'
			when @rand = 17 then 'Gamer Electronics'
			when @rand = 18 then 'Tech Scope'
			when @rand = 19 then 'Zoom Gadgets'
			when @rand = 20 then 'The Ridge Apparatus'
			when @rand = 21 then 'Knox International'
			when @rand = 22 then 'Machines and Gismo'
			when @rand = 23 then 'Efficient Machines'
			when @rand = 24 then 'Choice Gadgets'
			when @rand = 25 then 'Direct Electronics'
			when @rand = 26 then 'Techie Goodies'
			when @rand = 27 then 'Motors Gadgetry'
			when @rand = 28 then 'Electronics Care'
			when @rand = 29 then 'Machines and Things'
			when @rand = 30 then 'Cool Appliances'
			when @rand = 31 then 'Absolute Gadgets'
			when @rand = 32 then 'Surge Controls'
		end
	)

	insert into Store(StoreName, ZoneID) values(@name,@ZoneID)
end

--Add production house to product details
create procedure proc_ProductionHouseDestination(
	@ProductionHouseID int,
	@SerialNumber int
)
as
begin
	update ProductDetails --Updates product details to have production house 
			set ProductionHouseID = @ProductionHouseID,
			ProductionHouseDate = (dbo.GiveRandomDate(GETDATE(),rand()))
			where SerialNumber = @SerialNumber
end

--Stored procedure for ProductDetails Table
alter procedure proc_ProductDetails(
	@Action varchar(50),
	@SerialNumber int,
	@ProductionHouseID int = null,
	@ProductionHouseDate date = null output,
	@WarehouseID int = null,
	@WarehouseDate date = null output,
	@DistributorID int = null,
	@DistributorDate date = null output,
	@SubDistributorID int = null,
	@SubDistributorDate date = null output,
	@ChannelPartnerID int = null,
	@ChannelPartnerDate date = null output,
	@Date date = null,
	@Tax decimal(5,2) = null
)
as
begin
	if(@Action = 'UpdateProductionHouseDetails')
	begin
		update ProductDetails --Updates product details to have production house 
		set ProductionHouseID = @ProductionHouseID,
		ProductionHouseDate = (dbo.GiveRandomDate(GETDATE(),rand()))
		where SerialNumber = @SerialNumber
	end
	if(@Action = 'UpdateWarehouseDetails')
	begin
		update ProductDetails --Updates product details to have warehouse 
		set WarehouseID = @WarehouseID,
		WarehouseDate = (dbo.GiveRandomDate(@Date,rand())),
		Cost += (Cost*(@Tax/100))
		where SerialNumber = @SerialNumber
	end
	if(@Action = 'UpdateDistributorDetails')
	begin
		update ProductDetails --Updates product details to have distributor 
		set DistributorID = @DistributorID,
		DistributorDate = (dbo.GiveRandomDate(@Date,rand())),
		Cost += (Cost*(@Tax/100))
		where SerialNumber = @SerialNumber
	end
	if(@Action = 'UpdateSubDistributorDetails')
	begin
		update ProductDetails --Updates product details to have subdistributor 
		set SubDistributorID = @SubDistributorID,
		SubDistributorDate = (dbo.GiveRandomDate(@Date,rand())),
		Cost += (Cost*(@Tax/100))
		where SerialNumber = @SerialNumber
	end
	if(@Action = 'UpdateChannelPartnerDetails')
	begin
		update ProductDetails --Updates product details to have subdistributor 
		set ChannelPartnerID = @ChannelPartnerID,
		ChannelPartnerDate = (dbo.GiveRandomDate(@Date,rand())),
		Cost += (Cost*(@Tax/100))
		where SerialNumber = @SerialNumber
	end


	if(@Action = 'GiveProductionHouseDate')
	begin
		select @ProductionHouseDate = (select pd.ProductionHouseDate from ProductDetails pd 
										where pd.SerialNumber = @SerialNumber)
	end
	if(@Action = 'GiveWarehouseDate')
	begin
		select @WarehouseDate = (select pd.WarehouseDate from ProductDetails pd 
								where pd.SerialNumber = @SerialNumber)
	end
	if(@Action = 'GiveDistributorDate')
	begin
		select @DistributorDate = (select pd.DistributorDate from ProductDetails pd 
									where pd.SerialNumber = @SerialNumber)
	end
	if(@Action = 'GiveSubDistributorDate')
	begin
		select @SubDistributorDate = (select pd.SubDistributorDate from ProductDetails pd 
										where pd.SerialNumber = @SerialNumber)
	end
end


---------------------------Triggers---------------------------

--Trigger that will fill out the entire database (Took 6 minutes and 31 seconds to finish)
alter trigger trg_CreateEntireDataBase
on Country
after insert
as
begin
	declare @CountryID int
	set @CountryID = (select i.CountryID from inserted i)
	declare @ContinentID int = (select i.ContinentID from inserted i)
	declare @Population int = (select i.Population from inserted i)

	exec proc_CreateDistributor @CountryID --Creates a distributor for the country
	declare @DistributorID int = (select max(DistributorID) from Distributor)

	exec proc_CreateSubDistributor @Population, @DistributorID --Creates sub-distributor based on population

	declare @count int = 0
	declare @WarehouseID int
	while @count < 4 --Creates 4 Warehouse and assign production houses
	begin
		select @count += 1
		exec proc_CreateWarehouse @CountryID, @DistributorID
		set @WarehouseID = (select max(WarehouseID) from Warehouse)
		exec proc_ProductionHouse 'AssignToWarehouse', @ContinentID, @WarehouseID
	end
end

insert into Country(CountryName, Taxes, Population, ContinentID) values('United States', 9.8, 356102000, 1)

--Trigger to automatically create channel partners upon subdistributor creation
create trigger trg_CreateChannelPartner
on SubDistributor
after insert
as
begin
	declare @SubDistributorID int = (select i.SubDistributorID from inserted i)
	declare @DistributorID int = (select i.DistributorID from inserted i)
	declare @CountryID int
	set @CountryID = (select distinct c.CountryID from SubDistributor sd
						inner join Distributor d on sd.DistributorID = d.DistributorID
						inner join Country c on c.CountryID = d.CountryID
						where d.DistributorID = @DistributorID)
	declare @Population int = (select c.Population from Country c
								where c.CountryID = @CountryID)

	exec proc_CreateChannelPartner @Population, @SubDistributorID
end

insert into SubDistributor(DistributorID,SubDistrbutorName) values(141, 'Test')

--Trigger to automatically create/assign zones to channel partners
alter trigger trg_CreateZones
on ChannelPartner
after insert
as
begin
	declare @ChannelPartnerID int = (select i.ChannelPartnerID from inserted i)
	declare @SubDistributorID int = (select i.SubDistributorID from inserted i)
	declare @HowManyZone int = (select count(*) from Zone z
								inner join ChannelPartner cp on z.ChannelPartnerID = cp.ChannelPartnerID
								where cp.SubDistributorID = @SubDistributorID)
	
	declare @RandomChannelPartnerID int
	exec proc_CreateZones @ChannelPartnerID
	if(dbo.GiveManufactureTax(0,rand()*100) > 20 and @HowManyZone > 4) --80% chance to create a zone and attach to a random channel partner
	begin
		set @RandomChannelPartnerID = dbo.GiveRandomChannelPartnerID(@SubDistributorID, rand())
		exec proc_CreateZones @RandomChannelPartnerID
	end
end

create trigger trg_CreateStore
on Zone
after insert
as
begin
	declare @ZoneID int = (select i.ZoneID from inserted i)
	declare @ChannelPartnerID int = (select i.ChannelPartnerID from inserted i)
	
	declare @TotalStores int = (select round(dbo.GiveManufactureTax(1,rand()*20),0)) --randomly create 1-20 stores

	while(@TotalStores > 0)
	begin
		select @TotalStores -= 1
		exec proc_CreateStore @ZoneID
	end
end

--Trigger that fill distribute products of all these structures
alter trigger trg_CreateProductDetails
on ProductList
after insert
as
begin
	declare @ProductID int = (select i.ProductID from inserted i)
	declare @ProductCost smallmoney = (select i.BaseCost from inserted i)
	declare @count int = 0
	declare @count2 int = 0
	declare @SerialNumber int
	declare @CountryID int
	declare @Population int
	declare @Tax decimal(5,2)
	declare @ProductionHouseID int
	declare @WarehouseID int
	declare @DistributorID int
	declare @SubDistributorID int
	declare @ChannelPartnerID int
	declare @StoreID int
	declare @TotalCountries int = (select count(*) from Country)
	declare @Date date

	while(@count < @TotalCountries) --Goes through to each country
	begin
		select @count += 1
		set @CountryID = @count
		set @Population = (select c.Population from Country c where c.CountryID = @CountryID)
		set @Tax = (select c.Taxes from Country c where c.CountryID = @CountryID)
			
		while(@count2 < 10)--(round(@Population*0.0000002,0)+10)) --Creates products based on country's population (change it base on popularity also)
		begin
			select @count2 +=1
			insert into ProductDetails(Cost, ProductID) values(@ProductCost, @ProductID) --First initial creation
			set @SerialNumber = (select max(SerialNumber) from ProductDetails)
	
			--Product gets created in production house
			set @ProductionHouseID = (select dbo.GiveRandomProductionHouseID(@CountryID, rand())) --Gives random production house id based on country
			exec proc_ProductDetails 'UpdateProductionHouseDetails', @SerialNumber, @ProductionHouseID  --Updates production house details 

			--Product shipped to warehouse (country tax added to price)
			set @WarehouseID = (select dbo.GiveRandomWarehouseID(@CountryID, rand()))
			exec proc_ProductDetails 'GiveProductionHouseDate', @SerialNumber, @ProductionHouseDate = @Date output --Gets current date of production house
			exec proc_ProductDetails 'UpdateWarehouseDetails', @SerialNumber, @WarehouseID = @WarehouseID,@Date = @Date, @Tax = @Tax 

			--Randomize chance to ship that product to distributor
			if(dbo.GiveManufactureTax(0,rand()*100) > 10) --90% chance
			begin
				exec proc_ProductDetails 'GiveWarehouseDate', @SerialNumber, @WarehouseDate = @Date output
				exec proc_ProductDetails 'UpdateDistributorDetails', @SerialNumber, @DistributorID = @CountryID, @Date = @Date, @Tax = 8.0

				set @SubDistributorID = (select dbo.GiveRandomSubDistributorID(@CountryID, rand()))
				set @ChannelPartnerID = (select dbo.GiveRandomChannelPartnerID(@SubDistributorID,rand()))
				set @StoreID = (select dbo.GiveRandomStoreID(@ChannelPartnerID, rand())) --Give random store id based on zone and channelID

				if(dbo.GiveManufactureTax(0,rand()*100) > 10) --97% chance because its the distributor's job to get rid of the product as soon as possible
				begin
					exec proc_ProductDetails 'GiveDistributorDate', @SerialNumber, @DistributorDate = @Date output
					exec proc_ProductDetails 'UpdateSubDistributorDetails', @SerialNumber, @SubDistributorID = @SubDistributorID, @Date = @Date, @Tax = 8.0

					if(dbo.GiveManufactureTax(0,rand()*100) > 10) --97% chance to ship to channelPartner
					begin
						exec proc_ProductDetails 'GiveSubDistributorDate', @SerialNumber, @SubDistributorDate = @Date output
						exec proc_ProductDetails 'UpdateChannelPartnerDetails', @SerialNumber, @ChannelPartnerID = @ChannelPartnerID, @Date = @Date, @Tax = 8.0

						if(dbo.GiveManufactureTax(0,rand()*100) > 10) --97% chance to ship to Store CHANGE
						begin
							exec proc_ProductDetails 'GiveChannelPartnerDate', @SerialNumber, @ChannelPartnerDate = @Date output
							exec proc_ProductDetails 'UpdateStoreDetails', @SerialNumber, @ChannelPartnerID = @ChannelPartnerID, @Date = @Date, @Tax = 8.0
						end
					end
				end
			end

		end
		set @count2 = 0
	end
end

insert into ProductList(DeviceName, BaseCost) values('Airpods', 300)

