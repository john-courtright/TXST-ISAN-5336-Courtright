/*
	ISAN 5355: Database Management Systems
    Assignment 5: Due 12/5
    Author: John Courtright
    Instructor: Dr. Zhao
*/

-- 1) Create the database for assignment
-- Create  database
CREATE DATABASE assign5;

-- Set collation and default character set for db
ALTER DATABASE assign5 CHARSET utf8mb4
					   COLLATE utf8mb4_0900_ai_ci;

-- Set storage engine to be InnoDB 
-- Will apply to newly created tables for the new db
SET SESSION default_storage_engine = InnoDB;

-- Activate schema
USE assign5; 

-- Trouble shooting
DROP TABLE 0NF; 

-- 2) Create original table (no normalization)
CREATE TABLE 0NF 
(
	UnitID VARCHAR(10),
    -- Two students in 0NF U1
    StudentID VARCHAR(10),
    -- DD-MM-YY format
    Date VARCHAR(10),
    TutorID VARCHAR(10),
    Topic VARCHAR(10),
    -- Room could be INT, but we shouldn't need to do any computation with it
    Room VARCHAR(10),
    -- In 0NF, U1 has two grades, seperated by comma
    Grade VARCHAR (10),
    Book VARCHAR(20),
    TutEmail VARCHAR(30)
); 

-- Insert original records
INSERT INTO 0NF (UnitID, StudentID, Date, TutorID, Topic, Room, Grade, Book, TutEmail)
VALUES ('U1', 'St1, St4', '23.02.03', 'Tut1', 'GMT', '629', '4.7, 4.3', 'Deumlich', 'tut1@fhbb.ch');
INSERT INTO 0NF (UnitID, StudentID, Date, TutorID, Topic, Room, Grade, Book, TutEmail)
VALUES ('U2', 'St1', '18.11.02', 'Tut3', 'Gin', '631', '5.1', 'Zehnder', 'tut3@fhbb.ch'); 
INSERT INTO 0NF (UnitID, StudentID, Date, TutorID, Topic, Room, Grade, Book, TutEmail)
VALUES ('U3', 'St2', '05.05.03', 'Tut3', 'PhF', '632', '4.9', 'Dummlerw', 'tut3@fhbb.ch'); 
INSERT INTO 0NF (UnitID, StudentID, Date, TutorID, Topic, Room, Grade, Book, TutEmail)
VALUES ('U4', 'St2', '04.07.03', 'Tut5', 'AVQ', '621', '5', 'SwissTopo', 'tut5@fhbb.ch');  

-- Validate
SELECT *
FROM 0NF;

-- 3) Create 1NF Table
-- Breaking StudentId and Grade down
CREATE TABLE 1NF (
    UnitID      VARCHAR(10),
    StudentID   VARCHAR(10),
    Date        VARCHAR(10),
    TutorID     VARCHAR(10),
    Topic       VARCHAR(10),
    Room        VARCHAR(10),
    -- Changing grade to be numeric
    Grade       DECIMAL(2,1),
    Book        VARCHAR(20),
    TutEmail    VARCHAR(30)
);

-- Enter new records with proper normalization (1NF)
INSERT INTO 1NF VALUES
('U1', 'St1', '23.02.03', 'Tut1', 'GMT', '629', 4.7, 'Deumlich', 'tut1@fhbb.ch'),
('U1', 'St4', '23.02.03', 'Tut1', 'GMT', '629', 4.3, 'Deumlich', 'tut1@fhbb.ch'),
('U2', 'St1', '18.11.02', 'Tut3', 'Gin', '631', 5.1, 'Zehnder', 'tut3@fhbb.ch'),
('U3', 'St2', '05.05.03', 'Tut3', 'PhF', '632', 4.9, 'Dummlerw', 'tut3@fhbb.ch'),
('U4', 'St2', '04.07.03', 'Tut5', 'AVQ', '621', 5.0, 'SwissTopo', 'tut5@fhbb.ch');

-- Validate
SELECT *
FROM 1NF;

-- 4) Create 2NF Tables
-- Tutoring Unit Table
CREATE TABLE Unit2NF (
    UnitID     VARCHAR(10) PRIMARY KEY,
    Date       VARCHAR(10),
    TutorID    VARCHAR(10),
    Topic      VARCHAR(10),
    Room       VARCHAR(10),
    Book       VARCHAR(20)
);

-- Student Table
CREATE TABLE StudentUnit2NF (
    UnitID     VARCHAR(10),
    StudentID  VARCHAR(10),
    Grade      DECIMAL(2,1),
    -- Delcare both as primary keys to avoid student-unit duplication
    PRIMARY KEY (UnitID, StudentID),
    FOREIGN KEY (UnitID) REFERENCES Unit2NF(UnitID)
);

-- Insert Records into both tables
INSERT INTO Unit2NF VALUES
('U1', '23.02.03', 'Tut1', 'GMT', '629', 'Deumlich'),
('U2', '18.11.02', 'Tut3', 'Gin', '631', 'Zehnder'),
('U3', '05.05.03', 'Tut3', 'PhF', '632', 'Dummlerw'),
('U4', '04.07.03', 'Tut5', 'AVQ', '621', 'SwissTopo');

INSERT INTO StudentUnit2NF VALUES
('U1', 'St1', 4.7),
('U1', 'St4', 4.3),
('U2', 'St1', 5.1),
('U3', 'St2', 4.9),
('U4', 'St2', 5.0);

-- Validate
SELECT *
FROM Unit2NF;
SELECT*
FROM StudentUnit2NF;

-- Troubleshoot
DROP TABLE StudentUnit3NF;
DROP TABLE Unit3NF;
DROP TABLE Tutor3NF; 

-- 5) Create 3NF Tables
CREATE TABLE Tutor3NF (
    TutorID   VARCHAR(10) PRIMARY KEY,
    TutEmail  VARCHAR(30)
);

CREATE TABLE Unit3NF (
    UnitID     VARCHAR(10) PRIMARY KEY,
    Date       VARCHAR(10),
    TutorID    VARCHAR(10),
    Topic      VARCHAR(10),
    Room       VARCHAR(10),
    Book       VARCHAR(20),
    FOREIGN KEY (TutorID) REFERENCES Tutor3NF(TutorID)
);

CREATE TABLE StudentUnit3NF (
    UnitID     VARCHAR(10),
    StudentID  VARCHAR(10),
    Grade      DECIMAL(2,1),
    PRIMARY KEY (UnitID, StudentID),
    FOREIGN KEY (UnitID) REFERENCES Unit3NF(UnitID)
);

-- Insert Records
INSERT INTO Tutor3NF VALUES
('Tut1', 'tut1@fhbb.ch'),
('Tut3', 'tut3@fhbb.ch'),
('Tut5', 'tut5@fhbb.ch');

INSERT INTO Unit3NF VALUES
('U1',  '23.02.03', 'Tut1', 'GMT', '629', 'Deumlich'),
('U2',  '18.11.02', 'Tut3', 'Gin', '631', 'Zehnder'),
('U3',  '05.05.03', 'Tut3', 'PhF', '632', 'Dummlerw'),
('U4', '04.07.03', 'Tut5', 'AVQ', '621', 'SwissTopo');

INSERT INTO StudentUnit3NF VALUES
('U1',  'St1', 4.7),
('U1',  'St4', 4.3),
('U2',  'St1', 5.1),
('U3',  'St2', 4.9),
('U4', 'St2', 5.0);

-- Validate
SELECT *
FROM Unit3NF;
SELECT *
FROM StudentUnit3NF;
SELECT *
FROM Tutor3NF;

-- 6) Insert 3 new records into each table
INSERT INTO Tutor3NF (TutorID, TutEmail) VALUES
('Tut7', 'tut7@fhbb.ch'),
('Tut8', 'tut8@fhbb.ch'),
('Tut9', 'tut9@fhbb.ch');

INSERT INTO Unit3NF (UnitID, Date, TutorID, Topic, Room, Book) VALUES
('U5', '12.03.04', 'Tut7', 'MLB', '640', 'Data Mining 101'),
('U6', '28.09.04', 'Tut8', 'STAT', '645', 'Applied Statistics'),
('U7', '15.01.05', 'Tut9', 'DSA', '650', 'Data Structures');

INSERT INTO StudentUnit3NF (UnitID, StudentID, Grade) VALUES
('U5', 'St10', 4.8),
('U6', 'St11', 5.2),
('U7', 'St12', 4.4);

-- 6) Join the three table
SELECT 
    su.UnitID,
    su.StudentID,
    u.Date,
    u.TutorID,
    u.Topic,
    u.Room,
    su.Grade,
    u.Book,
    t.TutEmail
FROM StudentUnit3NF su
JOIN Unit3NF u 
    ON su.UnitID = u.UnitID
JOIN Tutor3NF t
    ON u.TutorID = t.TutorID
ORDER BY su.UnitID, su.StudentID;

