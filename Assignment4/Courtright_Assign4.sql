/*
	ISAN 5355: Database Management Systems
    Assignment 4: Due 11/19
    Author: John Courtright
    Instructor: Dr. Zhao
*/

-- START
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE,
SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- 1) Create the database
CREATE DATABASE assign4;

-- 2) Set collation and default character set for db
ALTER DATABASE assign4 CHARSET utf8mb4
					   COLLATE utf8mb4_0900_ai_ci;

-- 3) Set storage engine to be InnoDB 
-- Will apply to newly created tables for the new db
SET SESSION default_storage_engine = InnoDB;

-- 4) Activate schema
USE assign4; 

-- to troubleshoot
DROP TABLE book;
DROP TABLE branch;
DROP TABLE branch_has_book;

/* 5) Create the 'book' table w/:
	bookCode CHAR(4) as the PK
    title VARCHAR(40)
    publisherCode CHAR(3)
    bookType CHAR(3)
    paperback CHAR(1) */
CREATE TABLE book
( 
	bookCode CHAR(4) PRIMARY KEY,
    title VARCHAR(40),
    publisherCode CHAR(3),
    bookType CHAR(3),
    paperback CHAR(1)
);
    
/* 6) Create the 'branch' table w/:
	branchNum DECIMAL(2,0) as the PK
    branchName VARCHAR(50)
    branchLocation VARCHAR(50) */
CREATE TABLE branch
(
	branchNum DECIMAL(2,0) PRIMARY KEY,
    branchName VARCHAR(50),
    branchLocation VARCHAR(50)
);

/* 7) Create the 'branch_has_book' table w/:
	branch_branchNum DECIMAL(2,0) 
    book_bookCode CHAR(4)
    OnHand DECIMAL(2,0) */
CREATE TABLE branch_has_book
(
    branch_branchNum DECIMAL(2,0),
    book_bookCode CHAR(4),
    OnHand DECIMAL(2,0),
    PRIMARY KEY (branch_branchNum, book_bookCode),
    FOREIGN KEY (branch_branchNum) REFERENCES branch(branchNum),
    FOREIGN KEY (book_bookCode) REFERENCES book(bookCode)
);

/* 8) Insert 3 records into each table */ 
INSERT INTO book (bookCode, title, publisherCode, bookType, paperback)
VALUES
('B001', 'Data Science Essentials', 'P01', 'TEC', 'Y'),
('B002', 'Modern SQL Design', 'P02', 'TEC', 'N'),
('B003', 'Marketing Analytics 101', 'P03', 'BUS', 'Y');

INSERT INTO branch (branchNum, branchName, branchLocation)
VALUES
(10, 'Downtown Library', 'Austin'),
(20, 'Campus Library', 'San Marcos'),
(30, 'Westside Library', 'Dallas');

INSERT INTO branch_has_book (branch_branchNum, book_bookCode, OnHand)
VALUES
-- Downtown Library carries all three books
(10, 'B001', 4),
(10, 'B002', 2),
(10, 'B003', 5),

-- Campus Library carries two books
(20, 'B001', 3),
(20, 'B002', 6),

-- Westside Library carries two books
(30, 'B002', 4),
(30, 'B003', 3);

/* 9) Perform a SELECT command on the inner join of the 
	three tables that reveals all records in each table */
SELECT 
    br.branchName,
    br.branchLocation,
    bk.title,
    bk.bookType,
    bhb.OnHand
FROM branch_has_book AS bhb
INNER JOIN branch AS br 
    ON bhb.branch_branchNum = br.branchNum
INNER JOIN book AS bk 
    ON bhb.book_bookCode = bk.bookCode
ORDER BY br.branchName, bk.bookCode;

-- END
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
