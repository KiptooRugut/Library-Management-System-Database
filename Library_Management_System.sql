-- Enhanced Library Management System Database
-- This SQL script creates a comprehensive library management system
-- with additional features like fines, reservations, and audit logging

-- Clean up existing tables (in proper dependency order)
DROP DATABASE IF EXISTS library_management;   -- Including the tables below;
DROP TABLE IF EXISTS Fines;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS BorrowRecords;
DROP TABLE IF EXISTS BookAuthors;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS LibraryCards;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Publishers;
DROP TABLE IF EXISTS AuditLog;

-- Database creation
CREATE DATABASE library_management;
USE library_management;

-- ================= CORE TABLES =================

-- Publishers: Stores information about book publishers
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(200),
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    established_year YEAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Contains publisher information';

-- Authors: Stores information about book authors
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_author UNIQUE (first_name, last_name, birth_date)
) COMMENT 'Contains details about book authors';

-- Books: Main table containing book information
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher_id INT,
    publication_year YEAR,
    edition INT DEFAULT 1,
    category VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies AND available_copies >= 0)
) COMMENT 'Main table containing book information';

-- BookAuthors: Junction table for book-author many-to-many relationship
CREATE TABLE BookAuthors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        ON DELETE CASCADE
) COMMENT 'Junction table for book-author many-to-many relationship';

-- Members: Stores information about library members
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(200),
    membership_date DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
) COMMENT 'Stores information about library members';


-- Loans: Tracks all book loans and returns
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Active', 'Returned', 'Overdue', 'Lost') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (due_date >= loan_date AND 
                              (return_date IS NULL OR return_date >= loan_date))
) COMMENT 'Tracks all book loans and returns';

-- ============== INDEXES ==============
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_isbn ON Books(isbn);
CREATE INDEX idx_members_email ON Members(email);
CREATE INDEX idx_loans_dates ON Loans(loan_date, due_date, return_date);

-- ============== SAMPLE DATA ==============
-- Insert sample publishers
INSERT INTO Publishers (name, address, contact_email, established_year) VALUES
('Black Random House', '175 Broadway, Nairobi, Nai', 'info@randomhouse.com', 2013),
('Mike Kiptoo', '195 Kipchoge, Eldoret, Ld', 'contact@mike.com', 1989),
('Candy & Mutable', '7831 Avenue of the Marathoners, Kaptagat, Ld', 'info@candy.com', 1924);

-- Insert sample authors
INSERT INTO Authors (first_name, last_name, birth_date, nationality) VALUES
('George', 'Grey', '1993-06-25', 'Kenyan'),
('J.K.', 'Sigilai', '1985-07-31', 'Ugandan'),
('Stephen', 'Kingslay', '1977-09-21', 'South African');

-- Insert sample books
INSERT INTO Books (title, isbn, publisher_id, publication_year, total_copies, available_copies) VALUES
('1984', '9780451524935', 1, 1949, 5, 5),
('Harry Potter and the Philosopher''s Stone', '9780747532743', 2, 1997, 3, 3),
('The Shining', '9780307743657', 3, 1977, 4, 4);

-- Link books to authors
INSERT INTO BookAuthors (book_id, author_id) VALUES
(1, 1), -- 1984 by George Grey
(2, 2), -- Harry Potter by J.K. Sigilai
(3, 3); -- The Shining by Stephen Kingslay

-- Insert sample members
INSERT INTO Members (first_name, last_name, email, phone, membership_date) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', '2023-01-15'),
('Jane', 'Smach', 'jane.smach@email.com', '555-0102', '2023-02-20');