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

