# Library-Management-System-Database

## Project Description
A complete MySQL database solution for managing library operations including books, authors, publishers, members, and loans.

## Features
- Tracks book inventory with available/total copies
- Manages member information and loan history
- Enforces data integrity with constraints
- Supports complex relationships (1-1, 1-M, M-M)

## Setup Instructions
1. Clone this repository
2. Import the SQL file into MySQL:
   ```bash
   mysql -u [username] -p [database_name] < library_management_system.sql