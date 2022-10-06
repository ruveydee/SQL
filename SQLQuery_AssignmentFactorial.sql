--Factorial Function

--Create a scalar-valued function that returns the factorial of a number you gave it.

/*

-->>>SCALAR VALUED FUNCTIONS              
--(Tek bir değer döndürüyor)     

CREATE FUNCTION FUNCTION_NAME(@PAREMETER TYPE)      
RETURNS TYPE                                        
AS												   	
BEGIN 												
    SQL_STATEMENT										
RETURN VALUE 										
END;												

DECLARE @COUNTER INT  = 1

*/


CREATE FUNCTION dbo.Factorial ( @Number int )
RETURNS INT
AS
BEGIN
DECLARE @VALUE  int

    IF @Number <= 1
        SET @VALUE = 1
    ELSE
        SET @VALUE = @Number * dbo.Factorial(@Number - 1)
RETURN (@VALUE)
END

Go
SELECT dbo.Factorial(5)

