CREATE TABLE [dbo].[EventLog] (
    [ID]          UNIQUEIDENTIFIER NOT NULL,
    [EventDate]   DATETIME         DEFAULT (getdate()) NOT NULL,
    [Description] NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IXFU#EventLog@EventDate]
    ON [dbo].[EventLog]([EventDate] ASC);

