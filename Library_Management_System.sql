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