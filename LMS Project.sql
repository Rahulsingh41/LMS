 LMS Project
-- Table Creation Script:
CREATE TABLE [dbo].[Subject]
(
    [SubjectID] [int] NOT NULL,
    [SubjectName] [varchar](64) NULL,
    CONSTRAINT [PK_Subject] PRIMARY KEY CLUSTERED ([SubjectID] ASC)
)
GO
CREATE TABLE [dbo].[Department]
(
    [DeptID] [int] NOT NULL,
    [DeptName] [varchar](64) NOT NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([DeptID] ASC)
)
GO
CREATE TABLE [dbo].[BookDetails]
(
    [BookID] [int] NOT NULL,
    [BookName] [varchar](64) NOT NULL,
    [AuthorName] [varchar](64) NOT NULL,
    [BookSerialNumber] [varchar](64) NOT NULL,
    [SubjectID] [int] NOT NULL,
    [Publisher] [varchar](64) NOT NULL,
    [Price] [int] NULL,
 CONSTRAINT [PK_BookDetails] PRIMARY KEY CLUSTERED ([BookID] ASC)
)
GO
ALTER TABLE [dbo].[BookDetails]  WITH CHECK
ADD  CONSTRAINT [FK_BookDetails_subject_SubjectID] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
CREATE TABLE [dbo].[BorrowerDetails]
(
    [BorrowerID] [int] NOT NULL,
    [BorrowerName] [varchar](64) NOT NULL,
    [BorrowerContact] [varchar](64) NOT NULL,
    [DeptID] [int] NOT NULL,
    [Address] [varchar](64) NOT NULL,
    CONSTRAINT [PK_BorrowerDetails] PRIMARY KEY CLUSTERED ([BorrowerID] ASC)
)
GO
ALTER TABLE [dbo].[BorrowerDetails]  WITH CHECK
ADD  CONSTRAINT [FK_Borrowerdetails_Department_DeptID] FOREIGN KEY([DeptID])
REFERENCES [dbo].[Department] ([DeptID])
GO
CREATE TABLE [dbo].[BookBorrowed]
(
    [BookBorrowedID] [int] NOT NULL,
    [BookID] [int] NOT NULL,
    [BorrowerID] [int] NOT NULL,
    [BorrowedOn] [datetime] NOT NULL,
    [DueDate] [datetime] NOT NULL,
    [NumberOfCopies] [int] NOT NULL,
    [ReturnStatus] [varchar](64) NOT NULL,
    CONSTRAINT [PK_BookBorrowed] PRIMARY KEY CLUSTERED ([BookBorrowedID] ASC)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BookBorrowed]  WITH CHECK ADD  CONSTRAINT [FK_Bookborrowed_BookDetails_BookID] FOREIGN KEY([BookID])
REFERENCES [dbo].[BookDetails] ([BookID])
GO
ALTER TABLE [dbo].[BookBorrowed]  WITH CHECK ADD  CONSTRAINT [FK_Bookborrowed_Borrowerdetails_BorrowerID] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[BorrowerDetails] ([BorrowerID])
GO


-- create a report/view to see bookname, authorname, subjectname and price
CREATE VIEW BookReport
AS
select bookname,authorname,subjectname, price
from subject as s
inner join bookdetails as b
on b.subjectid=s.subjectid


-- create a report/view to see Borrowername, BorrowerContact, DepartmentName and Address
CREATE VIEW BorrowerReport
AS
select b.Borrowername, b.BorrowerContact, d.DeptName as DepartmentName, b.Address
from Department as d
inner join BorrowerDetails as b
on d.DeptID=b.DeptID


-- create a report/view to see borrowd book details: BookName, BorrowerName,
-- BorrowerContact, AuthorName, BorrowedOn, DueDate
CREATE VIEW BorrowedBookReport
AS
select bd.BookName, br.BorrowerName, br.BorrowerContact, bd.AuthorName, bb.BorrowedOn, bb.DueDate
from bookdetails as bd
INNER JOIN bookborrowed as bb ON bd.BookID=bb.BookID
INNER JOIN BorrowerDetails as br ON bb.BorrowerID = br.BorrowerID
WHERE bb.ReturnStatus = 'N'



--     Create a Stored Procedure to borrow a book (Add a entry to BookBorrowed table)
-- BookName, BorrowerName
CREATE PROCEDURE BorrowNewBook
@BookName Varchar(32),
@BorrowerName Varchar(32)
AS
BEGIN
    declare @bid int = NULL , @brid int = NULL, @bbid int = 1
    select @bbid = max(bookborrowedid)+1 from BookBorrowed
    IF NOT EXISTS (select * from BookDetails where BookName = @BookName)
    BEGIN
        Print 'Book does not exist in the library: ' + @BookName
    END
    ELSE
    BEGIN
        select @bid = BookID from BookDetails where BookName = @BookName
    END
    IF NOT EXISTS (select * from BorrowerDetails where BorrowerName = @BorrowerName)
    BEGIN
        Print 'Not a member of the library: ' + @BorrowerName
    END
    ELSE
    BEGIN
        select @brid = BorrowerID from BorrowerDetails where BorrowerName = @BorrowerName
    END
    IF (@bid IS NOT NULL) AND (@brid IS NOT NULL)
    BEGIN
        INSERT INTO BookBorrowed (BookBorrowedID, bookid, BorrowerID, BorrowedOn, DueDate, NumberOfCopies, ReturnStatus)
        Values(@bbid, @bid, @brid, getdate(), dateadd(day, 3, getdate()), 1, 'N')
    END
END