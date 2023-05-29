
CREATE PROCEDURE [dbo].[ADDNEWBOOK]

@BookID int ,
@BookName varchar(64) ,
@AuthorName varchar(64) ,
@BookSerialNumber varchar(64) ,
@SubjectID int ,
@Publisher varchar(64) ,
@Price int

AS

BEGIN
      IF exists (select * from dbo.BookDetails where BookID = @BookID)
	  begin
	      Print ' Book ID Present In The Records...' + Convert(Varchar(65), @BookID)
	  ENd
ELSE

      IF exists (select * from dbo.BookDetails where BookName = @BookName)
	  BEGIN
	      Print ' Book Name Present In The Records...' + @BookName
	  END

ELSE

      IF exists (select * from dbo.BookDetails where BookSerialNumber = @BookSerialNumber)
	  BEGIN
	      Print ' BookSerialNumber Present In The Records...' + @BookSerialNumber
	  END
ELSE

        BEGIN
       INSERT INTO dbo.BookDetails
       ( BookId, BookName, AuthorName, BookSerialNumber, SubjectID, Publisher, Price)
        Values (@BookID, @BookName, @AuthorName, @BookSerialNumber, @SubjectID, @Publisher , @Price)
        END

END
GO


