
CREATE procedure [dbo].[AddNewMember]

@BorrowerID int ,
@BorrowerName varchar(64) ,
@BorrowerContact varchar(64) ,
@DeptID int ,
@Address varchar(64)
AS

BEGIN

     IF exists (select * from dbo.BorrowerDetails where BorrowerID = @BorrowerID)
	 BEGIN
	      Print ' Borrower ID Present In The Records...' + Convert(Varchar(65), @BorrowerID)
	 END

ELSE

    IF exists (select * from dbo.BorrowerDetails where BorrowerName = @BorrowerName)
	 BEGIN
	      Print ' Borrower Name Present In The Records...' +  @BorrowerName
	 END

ELSE

  BEGIN

  INSERT INTO dbo.BorrowerDetails( BorrowerID, BorrowerName, BorrowerContact, DeptID, Address)
  Values (@BorrowerID, @BorrowerName, @BorrowerContact, @DeptID, @Address)
  
  END

END
GO


