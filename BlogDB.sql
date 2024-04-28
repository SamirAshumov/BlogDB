
CREATE DATABASE BlogDB
USE BlogDB

CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL UNIQUE
)


CREATE TABLE Tags (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL UNIQUE
)


CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    FullName NVARCHAR(50) NOT NULL,
    Age INT CHECK (Age >= 0 AND Age <= 150)
)


CREATE TABLE Blogs (
    Id INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(50) NOT NULL CHECK (LEN(Title) <= 50),
    Description NVARCHAR(50) NOT NULL,
    UserId INT,
    CategoryId INT,
	isDeleted BIT DEFAULT 0,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)


CREATE TABLE BlogsTags (
    BlogId INT,
    TagId INT,
    PRIMARY KEY (BlogId, TagId),
    FOREIGN KEY (BlogId) REFERENCES Blogs(Id),
    FOREIGN KEY (TagId) REFERENCES Tags(Id)
)



CREATE TABLE Comments (
    Id INT PRIMARY KEY IDENTITY,
    Content NVARCHAR(50) NOT NULL CHECK (LEN(Content) <= 250),
    UserId INT,
    BlogId INT,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (BlogId) REFERENCES Blogs(Id)
)



CREATE VIEW BlogInfo1 AS 
SELECT b.Title , u.UserName , u.FullName 
FROM Blogs b
INNER JOIN Users u ON b.UserId = u.Id;

SELECT * FROM BlogInfo1



CREATE VIEW BlogInfo2 AS
SELECT b.Title AS BlogTitle, c.Name AS CategoryName
FROM Blogs b
INNER JOIN Categories c ON b.CategoryId = c.Id;

SELECT * FROM BlogInfo2




CREATE PROCEDURE GetUserComments
    @userId INT
AS
BEGIN
    SELECT *
    FROM Comments
    WHERE UserId = @userId;
END

EXEC GetUserComments @userId = 2;




CREATE PROCEDURE GetUserBlogs
    @userId INT
AS
BEGIN
    SELECT *
    FROM Blogs
    WHERE UserId = @userId;
END

EXEC GetUserBlogs @userId = 3;




CREATE PROCEDURE CountBlogsInCategory
    @categoryId INT
AS
BEGIN
    SELECT COUNT(*) AS Counts
    FROM Blogs
    WHERE CategoryId = @categoryId;
END

EXEC CountBlogsInCategory  @categoryId = 2;



CREATE FUNCTION GetUserBlogsTable
(
    @userId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Blogs
    WHERE UserId = @userId
)

SELECT * FROM dbo.GetUserBlogsTable(4);





CREATE TRIGGER SetDeletedToTrue
ON Blogs
AFTER DELETE
AS
BEGIN
    UPDATE Blogs
    SET isDeleted = 1  
    FROM deleted
    WHERE Blogs.Id = deleted.Id;
END;






INSERT INTO Categories (Name)
VALUES ('Category 1'),
       ('Category 2'),
       ('Category 3'),
       ('Category 4'),
       ('Category 5'),
       ('Category 6');


INSERT INTO Tags (Name)
VALUES ('Tag 1'),
       ('Tag 2'),
       ('Tag 3'),
       ('Tag 4'),
       ('Tag 5'),
       ('Tag 6');


INSERT INTO Users (UserName, FullName, Age)
VALUES ('user1', 'fullname1', 25),
       ('user2', 'fullname2', 30),
       ('user3', 'fullname3', 28),
       ('user4', 'fullname4', 35),
       ('user5', 'fullname5', 22),
       ('user6', 'fullname6', 40);


INSERT INTO Blogs (Title, Description, UserId, CategoryId)
VALUES ('Blog Title 1', 'Description for Blog 1', 1, 1),
       ('Blog Title 2', 'Description for Blog 2', 2, 2),
       ('Blog Title 3', 'Description for Blog 3', 3, 1),
       ('Blog Title 4', 'Description for Blog 4', 4, 2),
       ('Blog Title 5', 'Description for Blog 5', 5, 3),
       ('Blog Title 6', 'Description for Blog 6', 6, 1);



DELETE FROM Blogs
WHERE Id = 4;


SELECT * FROM Blogs




