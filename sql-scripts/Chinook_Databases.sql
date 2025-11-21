/********************************************************************************
-- Chinook Database Schema (User) Creation Script
-- File: Chinook_Databases.sql
-- Purpose: Create two Oracle schemas (users) for the Chinook database examples
--          and grant necessary privileges. Each user is dropped first if it
--          already exists. Note: In Oracle a schema = user; this does not
--          create a separate database.
********************************************************************************/

-- ============================================================================ 
-- SECTION: Schema "chinook" (creates Oracle user/schema for Chinook)
-- -----------------------------------------------------------------------------
-- - Drop existing user and all owned objects
-- - Create user with default and temporary tablespaces and a quota
-- - Grant minimal privileges required to create and use schema objects
-- - Connect as the new user
-- ============================================================================
DROP USER chinook CASCADE;

CREATE USER chinook
    IDENTIFIED BY chinook
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 10M ON users;

GRANT CONNECT TO chinook;
GRANT RESOURCE TO chinook;
GRANT CREATE SESSION TO chinook;
GRANT CREATE TABLE TO chinook;
GRANT CREATE VIEW TO chinook;

conn chinook/chinook


-- ============================================================================ 
-- SECTION: Schema "DSAchinook" (creates Oracle user/schema for Chinook DSA)
-- -----------------------------------------------------------------------------
-- - Drop existing user and all owned objects
-- - Create user with default and temporary tablespaces and a quota
-- - Grant minimal privileges required to create and use schema objects
-- - Connect as the new user
-- ============================================================================
DROP USER DSAchinook CASCADE;

CREATE USER DSAchinook
    IDENTIFIED BY DSAchinook
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 10M ON users;

GRANT CONNECT TO DSAchinook;
GRANT RESOURCE TO DSAchinook;
GRANT CREATE SESSION TO DSAchinook;
GRANT CREATE TABLE TO DSAchinook;
GRANT CREATE VIEW TO DSAchinook;

conn DSAchinook/DSAchinook
