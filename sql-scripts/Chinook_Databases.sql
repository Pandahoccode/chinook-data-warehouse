/********************************************************************************
-- CHINOOK Database Schema (User) Creation Script
-- File: CHINOOK_Databases.sql
-- Purpose: Create two Oracle schemas (users) for the CHINOOK database examples
--          and grant necessary privileges. Each user is dropped first if it
--          already exists. Note: In Oracle a schema = user; this does not
--          create a separate database.
********************************************************************************/

-- ============================================================================ 
-- SECTION: Schema "CHINOOK" (creates Oracle user/schema for CHINOOK)
-- -----------------------------------------------------------------------------
-- - Drop existing user and all owned objects
-- - Create user with default and temporary tablespaces and a quota
-- - Grant minimal privileges required to create and use schema objects
-- - Connect as the new user
-- ============================================================================
DROP USER CHINOOK CASCADE;

CREATE USER CHINOOK
    IDENTIFIED BY CHINOOK
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 10M ON users;

GRANT CONNECT TO CHINOOK;
GRANT RESOURCE TO CHINOOK;
GRANT CREATE SESSION TO CHINOOK;
GRANT CREATE TABLE TO CHINOOK;
GRANT CREATE VIEW TO CHINOOK;

conn CHINOOK/CHINOOK


-- ============================================================================ 
-- SECTION: Schema "DSA_CHINOOK" (creates Oracle user/schema for CHINOOK DSA)
-- -----------------------------------------------------------------------------
-- - Drop existing user and all owned objects
-- - Create user with default and temporary tablespaces and a quota
-- - Grant minimal privileges required to create and use schema objects
-- - Connect as the new user
-- ============================================================================
DROP USER DSA_CHINOOK CASCADE;

CREATE USER DSA_CHINOOK
    IDENTIFIED BY DSA_CHINOOK
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 10M ON users;

GRANT CONNECT TO DSA_CHINOOK;
GRANT RESOURCE TO DSA_CHINOOK;
GRANT CREATE SESSION TO DSA_CHINOOK;
GRANT CREATE TABLE TO DSA_CHINOOK;
GRANT CREATE VIEW TO DSA_CHINOOK;

conn DSA_CHINOOK/DSA_CHINOOK
