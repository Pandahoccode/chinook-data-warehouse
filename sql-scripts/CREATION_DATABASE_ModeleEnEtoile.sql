
/*******************************************************************************
Projet SAE
Creation de databse - modele en etoile

Vu Ngan Ha TRUONG
Phuc Anh DANG
********************************************************************************/

/*******************************************************************************
Drop database if it exists
********************************************************************************/
DROP USER ETOILE CASCADE;

commit;
/*******************************************************************************
   Create database
********************************************************************************/

CREATE USER ETOILE IDENTIFIED BY ETOILE;
GRANT CONNECT, RESOURCE TO ETOILE;
/*******************************************************************************
   Create Tables
********************************************************************************/


CREATE TABLE Invoice 
(
		TK_InvoiceID NUMBER NOT NULL,
    TK_CustomerID NUMBER NOT NULL,
    TK_EmployeeID NUMBER NOT NULL,
    TK_TrackID NUMBER NOT NULL,
    InvoiceID NUMBER NOT NULL,
    InvoiceLineID NUMBER NOT NULL,
    Datefull DATE NOT NULL,
    Quantity NUMBER NOT NULL,
    UnitPrice NUMBER(10,2) NOT NULL,
    TotalPrice AS (UnitPrice * Quantity),
    BillingAddress VARCHAR2(70),
    BillingCity VARCHAR2(40),
    BillingState VARCHAR2(40),
    BillingCountry VARCHAR2(40),
    BillingPostalCode VARCHAR2(10)
);

CREATE TABLE Employee
(
		TK_EmployeeID NUMBER NOT NULL,
    EmployeeId NUMBER NOT NULL,
    LastName VARCHAR2(20) NOT NULL,
    FirstName VARCHAR2(20) NOT NULL,
    Title VARCHAR2(30),
    ReportsTo NUMBER,
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR2(70),
    City VARCHAR2(40),
    State VARCHAR2(40),
    Country VARCHAR2(40),
    PostalCode VARCHAR2(10),
    Phone VARCHAR2(24),
    Fax VARCHAR2(24),
    Email VARCHAR2(60),
    CONSTRAINT PK_Employee PRIMARY KEY  (TK_EmployeeId)
);

CREATE TABLE Customer
(
		TK_CustomerID NUMBER NOT NULL,
    CustomerId NUMBER NOT NULL,
    FirstName VARCHAR2(40) NOT NULL,
    LastName VARCHAR2(20) NOT NULL,
    Company VARCHAR2(80),
    Address VARCHAR2(70),
    City VARCHAR2(40),
    State VARCHAR2(40),
    Country VARCHAR2(40),
    PostalCode VARCHAR2(10),
    Phone VARCHAR2(24),
    Fax VARCHAR2(24),
    Email VARCHAR2(60) NOT NULL,
    SupportRepId NUMBER,
    CONSTRAINT PK_Customer PRIMARY KEY  (TK_CustomerId)
);

CREATE TABLE Datefull
(
		Datefull DATE NOT NULL,
    DayName INT NOT NULL,
    MonthName INT NOT NULL,
    YearName INT NOT NULL,
    CONSTRAINT PK_Date PRIMARY KEY (Datefull)
);

CREATE TABLE Track
(
		TK_TrackID NUMBER NOT NULL,
		TrackID NUMBER NOT NULL,
    TrackName VARCHAR2(200) NOT NULL,
    ArtistName VARCHAR2(120) NOT NULL,
    AlbumTitle VARCHAR2(160) NOT NULL,
    MediaTypeName VARCHAR2(120) NOT NULL,
    GenreName VARCHAR2(120),
    Composer VARCHAR2(220),
    Milliseconds NUMBER NOT NULL,
    Bytes NUMBER,
    CONSTRAINT PK_Track PRIMARY KEY (TK_TrackID),
    CONSTRAINT UK_TrackID UNIQUE (TrackID)
);

CREATE TABLE Playlist_Track
(
		PlaylistID NUMBER NOT NULL,
    TrackID NUMBER NOT NULL,
    CONSTRAINT PK_PlaylistTrack PRIMARY KEY (PlaylistID, TrackID)
);

CREATE TABLE Playlist
(
		PlaylistID NUMBER NOT NULL,
    Name VARCHAR2(120),
    CONSTRAINT PK_PlaylistID PRIMARY KEY (PlaylistID)
);


/*******************************************************************************
   Create Foreign Keys
********************************************************************************/
ALTER TABLE Invoice ADD CONSTRAINT PK_InvoiceCustomerID 
		FOREIGN KEY (TK_CustomerID) REFERENCES Customer (TK_CustomerID) ;

ALTER TABLE Invoice ADD CONSTRAINT PK_InvoiceEmployeeID 
		FOREIGN KEY (TK_EmployeeID) REFERENCES Employee (TK_EmployeeID) ;
    
ALTER TABLE Invoice ADD CONSTRAINT PK_InvoiceTrackID 
		FOREIGN KEY (TK_TrackID) REFERENCES Track (TK_TrackID) ;
    
ALTER TABLE Invoice ADD CONSTRAINT PK_InvoiceDate
		FOREIGN KEY (Datefull) REFERENCES Datefull (Datefull) ;  

ALTER TABLE Playlist_Track ADD CONSTRAINT FK_PlaylistTrack_Track
    FOREIGN KEY (TrackID) REFERENCES Track (TrackID);
    
ALTER TABLE Playlist_Track ADD CONSTRAINT FK_PlaylistTrackPlaylistID
    FOREIGN KEY (PlaylistID) REFERENCES Playlist (PlaylistID);
    