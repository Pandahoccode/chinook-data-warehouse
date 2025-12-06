/*******************************************************************************
   Create Tables for ODS with a column date to track when the record was added
********************************************************************************/
CREATE TABLE Album
(
    AlbumId NUMBER NOT NULL,
    Title VARCHAR2(160) NOT NULL,
    ArtistId NUMBER NOT NULL,
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY  (AlbumId)
);

CREATE TABLE Artist
(
    ArtistId NUMBER NOT NULL,
    Name VARCHAR2(120),
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Artist PRIMARY KEY  (ArtistId)
);

CREATE TABLE Customer
(
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
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY  (CustomerId)
);

CREATE TABLE Employee
(
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
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY  (EmployeeId)
);

CREATE TABLE Genre
(
    GenreId NUMBER NOT NULL,
    Name VARCHAR2(120),
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Genre PRIMARY KEY  (GenreId)
);

CREATE TABLE Invoice
(
    InvoiceId NUMBER NOT NULL,
    CustomerId NUMBER NOT NULL,
    InvoiceDate DATE NOT NULL,
    BillingAddress VARCHAR2(70),
    BillingCity VARCHAR2(40),
    BillingState VARCHAR2(40),
    BillingCountry VARCHAR2(40),
    BillingPostalCode VARCHAR2(10),
    Total NUMBER(10,2) NOT NULL,
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Invoice PRIMARY KEY  (InvoiceId)
);

CREATE TABLE InvoiceLine
(
    InvoiceLineId NUMBER NOT NULL,
    InvoiceId NUMBER NOT NULL,
    TrackId NUMBER NOT NULL,
    UnitPrice NUMBER(10,2) NOT NULL,
    Quantity NUMBER NOT NULL,
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_InvoiceLine PRIMARY KEY  (InvoiceLineId)
);

CREATE TABLE MediaType
(
    MediaTypeId NUMBER NOT NULL,
    Name VARCHAR2(120),
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_MediaType PRIMARY KEY  (MediaTypeId)
);

CREATE TABLE Playlist
(
    PlaylistId NUMBER NOT NULL,
    Name VARCHAR2(120),
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Playlist PRIMARY KEY  (PlaylistId)
);

CREATE TABLE PlaylistTrack
(
    PlaylistId NUMBER NOT NULL,
    TrackId NUMBER NOT NULL,
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_PlaylistTrack PRIMARY KEY  (PlaylistId, TrackId)
);

CREATE TABLE Track
(
    TrackId NUMBER NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    AlbumId NUMBER,
    MediaTypeId NUMBER NOT NULL,
    GenreId NUMBER,
    Composer VARCHAR2(220),
    Milliseconds NUMBER NOT NULL,
    Bytes NUMBER,
    UnitPrice NUMBER(10,2) NOT NULL,
    DateAdd DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_Track PRIMARY KEY  (TrackId)
);
