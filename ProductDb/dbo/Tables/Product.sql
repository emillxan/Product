CREATE TABLE [dbo].[Product] (
    [ID]          UNIQUEIDENTIFIER NOT NULL,
    [Name]        NVARCHAR (255)   NOT NULL,
    [Description] NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IXFU#Product@Name]
    ON [dbo].[Product]([Name] ASC);


GO
create trigger [TR#Product@Log]
on [Product]
after insert
    , update
    , delete
as
begin
    declare @action nvarchar(50);
    
    if exists (select * from inserted) and exists (select * from deleted)
        set @action = 'update';
    else if exists (select * from inserted)
        set @action = 'insert';
    else if exists (select * from deleted)
        set @action = 'delete';
    
    insert into [EventLog] ([ID], [EventDate], [Description])
    values (newid(), getdate(), 'Action: ' + @action + ' on Product');
end;