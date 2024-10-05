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
