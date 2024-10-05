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