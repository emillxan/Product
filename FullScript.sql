-- 1  
create database TestDb;
use TestDb;

-- 2
create table [Product](
      [ID]          uniqueidentifier not null primary key
	, [Name]        nvarchar(255)    not null
	, [Description] nvarchar(max)    null
);

create unique nonclustered index [IXFU#Product@Name]
on [Product] ([Name])
with (allow_page_locks = on
    , allow_row_locks  = on);

-- 3
create table [ProductVersion] (
      [ID]           uniqueidentifier not null primary key
    , [ProductID]    uniqueidentifier not null
	, [Name]         nvarchar(255)    not null
    , [Description]  nvarchar(max)    null
    , [Creatingdate] datetime         not null default getdate()
    , [Width]        decimal(10, 2)   not null check (width > 0)
    , [Height]       decimal(10, 2)   not null check (height > 0)
    , [Length]       decimal(10, 2)   not null check (length > 0)
    , constraint [FK#Product@ID#ProductVersion@ProductID] foreign key ([ProductID]) references [Product]([ID]) on delete cascade
);

create nonclustered index [IXFU#ProductVersion@Name]
on [ProductVersion] ([Name])
with (allow_page_locks = on
    , allow_row_locks  = on);

create nonclustered index [IXFU#ProductVersion@CreatingDate]
on [ProductVersion] ([Creatingdate])
with (allow_page_locks = on
    , allow_row_locks  = on);

create nonclustered index [IXFU#ProductVersion@Width]
on [ProductVersion] ([Width])
with (allow_page_locks = on
    , allow_row_locks  = on);

create nonclustered index [IXFU#ProductVersion@Height]
on [ProductVersion] ([Height])
with (allow_page_locks = on
    , allow_row_locks  = on);

create nonclustered index [IXFU#ProductVersion@Length]
on [ProductVersion] ([Length])
with (allow_page_locks = on
    , allow_row_locks  = on);

-- 4
create table [EventLog] (
      [ID]          uniqueidentifier not null primary key
    , [EventDate]   datetime         not null default getdate()
    , [Description] nvarchar(max)    null
);

create nonclustered index [IXFU#EventLog@EventDate]
on [EventLog] ([EventDate])
with (allow_page_locks = on
    , allow_row_locks  = on);


--5
create trigger [TR#Product@Log]
on [Product]
after insert
    , update
    , delete
as
begin
    declare @action nvarchar(50)
    
    if exists (select * from inserted) and exists (select * from deleted)
        set @action = 'update'
    else if exists (select * from inserted)
        set @action = 'insert'
    else if exists (select * from deleted)
        set @action = 'delete'
    
    insert into [EventLog] ([EventDate], [Description])
    values (getdate(), 'Action: ' + @action + ' on Product')
end;

create trigger [TR#ProductVersion@Log]
on [ProductVersion]
after insert
    , update
    , delete
as
begin
    declare @action nvarchar(50)
    
    if exists (select * from inserted) and exists (select * from deleted)
        set @action = 'update'
    else if exists (select * from inserted)
        set @action = 'insert'
    else if exists (select * from deleted)
        set @action = 'delete'
    
    insert into [EventLog] ([EventDate], [Description])
    values (getdate(), 'Action: ' + @action + ' on ProductVersion')
end;

-- 6
create function [dbo].[SearchProductVersions](
      @productName        nvarchar(255)
    , @productVersionName nvarchar(255)
    , @minVolume          decimal(10, 2)
    , @maxVolume          decimal(10, 2)
)
returns @result table (
      [ProductVersionID]   uniqueidentifier
    , [ProductName]        nvarchar(255)
    , [ProductVersionName] nvarchar(255)
    , [Width]              decimal(10, 2)
    , [Length]             decimal(10, 2)
    , [Height]             decimal(10, 2)
)
as
begin
    insert into @result
    select [pv].ID      as ProductVersionID
         ,  [p].[Name]  as ProductName
         , [pv].[Name]  as ProductVersionName
         , [pv].[Width]
         , [pv].[Length]
         , [pv].[Height]
      from [Product]        [p]
      join [ProductVersion] [pv] on [p].[ID] = [pv].[ProductID]
    where  [p].[Name] like '%' + @productName        + '%'
      and [pv].[Name] like '%' + @productVersionName + '%'
      and ([pv].[Width] * [pv].[Length] * [pv].[Height]) between @minVolume 
	                                                         and @maxVolume;

    return;
end;

-- 7
insert into [Product] ([ID], [Name], [Description])
values (newid(), 'Product A', 'Description of Product A')
     , (newid(), 'Product B', 'Description of Product B')
     , (newid(), 'Product C', 'Description of Product C');

declare @productA uniqueidentifier = (select ID from [Product] where [Name] = 'Product A');
declare @productB uniqueidentifier = (select ID from [Product] where [Name] = 'Product B');
declare @productC uniqueidentifier = (select ID from [Product] where [Name] = 'Product C');

insert into [ProductVersion] ([ID], [ProductID], [Name], [Description], [CreatingDate], [Width], [Height], [Length])
values (newid(), @productA, 'Version 1.0', 'First version of Product A' , getdate(), 100.5, 50.2, 30.3)
     , (newid(), @productA, 'Version 2.0', 'Second version of Product A', getdate(), 120.0, 60.0, 40.0)
     , (newid(), @productB, 'Version 1.0', 'First version of Product B' , getdate(), 80.0, 45.5, 35.0 )
     , (newid(), @productC, 'Version 1.0', 'First version of Product C' , getdate(), 110.3, 55.5, 33.3);

