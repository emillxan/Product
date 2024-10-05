CREATE TABLE [dbo].[ProductVersion] (
    [ID]           UNIQUEIDENTIFIER NOT NULL,
    [ProductID]    UNIQUEIDENTIFIER NOT NULL,
    [Name]         NVARCHAR (255)   NOT NULL,
    [Description]  NVARCHAR (MAX)   NULL,
    [Creatingdate] DATETIME         DEFAULT (getdate()) NOT NULL,
    [Width]        DECIMAL (10, 2)  NOT NULL,
    [Height]       DECIMAL (10, 2)  NOT NULL,
    [Length]       DECIMAL (10, 2)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CHECK ([height]>(0)),
    CHECK ([length]>(0)),
    CHECK ([width]>(0)),
    CONSTRAINT [FK#Product@ID#ProductVersion@ProductID] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IXFU#ProductVersion@Length]
    ON [dbo].[ProductVersion]([Length] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFU#ProductVersion@Height]
    ON [dbo].[ProductVersion]([Height] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFU#ProductVersion@Width]
    ON [dbo].[ProductVersion]([Width] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFU#ProductVersion@CreatingDate]
    ON [dbo].[ProductVersion]([Creatingdate] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFU#ProductVersion@Name]
    ON [dbo].[ProductVersion]([Name] ASC);


GO
create trigger [TR@ProductVersion@Log]
on [ProductVersion]
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
    values (newid(), getdate(), 'Action: ' + @action + ' on ProductVersion');
end;