--1. Quel pays a le plus grand nombre de clients ?
SELECT Country, COUNT(CustomerId) AS TotalCustomers
FROM Customer
GROUP BY Country
ORDER BY TotalCustomers DESC;

--2. Quel client a d?pens? le plus d?argent ?
SELECT
    C.FirstName,
    C.LastName,
    SUM(I.Total) AS TotalSpent
FROM
    Customer C JOIN
    Invoice I ON C.CustomerId = I.CustomerId
GROUP BY
    C.CustomerId, C.FirstName, C.LastName
ORDER BY
    TotalSpent DESC
FETCH FIRST 1 ROW ONLY;


--3. Quel album et de quel artiste, contient le plus de titres ?
SELECT
    a.Title AS AlbumTitle,
    r.Name AS ArtistName,
    COUNT(t.TrackId) AS TotalTracks
FROM Track t
JOIN
    Album a ON t.AlbumId = a.AlbumId
JOIN
    Artist r ON a.ArtistId = r.ArtistId
GROUP BY
    a.Title, r.Name
ORDER BY
    TotalTracks DESC
FETCH FIRST 1 ROW ONLY;

--4. Quel genre de musique est le plus repr?sent? ?
SELECT g.Name, COUNT(g.Name) AS TotalGenre
FROM Genre g 
JOIN Track t ON g.GenreID= t.GenreID
GROUP BY g.Name
ORDER BY TotalGenre DESC
FETCH FIRST 1 ROW ONLY;

--5. Affichez la dur?e en minutes, et secondes de l?album le plus long
SELECT
    a.Title AS AlbumTitle,
    -- Calcul de la dur?e totale en secondes
    TRUNC(SUM(t.Milliseconds) / 1000) AS TotalSeconds,
    -- Calcul de la dur?e en Minutes
    TRUNC(SUM(t.Milliseconds) / 1000 / 60) AS Minutes,
    -- Calcul des Secondes restantes
    MOD(TRUNC(SUM(t.Milliseconds) / 1000), 60) AS Seconds
FROM
    Track t
JOIN
    Album a ON t.AlbumId = a.AlbumId
GROUP BY
    a.Title
ORDER BY
    TotalSeconds DESC
FETCH FIRST 1 ROW ONLY;

--6. Combien d?artistes ne sont associ?s ? aucun album ?
SELECT Count(Artist.Name)
FROM Artist LEFT JOIN Album ON Artist.ArtistID = Album.ARTISTID
WHERE Album.ArtistID IS NULL;
-----
SELECT *
FROM Artist
WHERE artistID NOT IN 
    (SELECT artistID FROM Album); 
    

   -- 7. Le nombre d?albums compos?s de chansons de genres diff?rents ?
SELECT
    COUNT(*)
FROM
    (
        SELECT
            Track.AlbumId
        FROM
            Album
            INNER JOIN Track ON Track.AlbumId = Album.AlbumId
        GROUP BY
            Track.AlbumId
        HAVING
            COUNT(DISTINCT (Track.GenreId)) > 1
    );
    -- 8. Le pourcentage de chansons jamais achet?es
SELECT 
    ROUND((
        (SELECT COUNT(*) FROM Track
         WHERE Track.AlbumIdNOT IN (SELECT InvoiceLine.AlbumIdFROM InvoiceLine))
        * 100.0 / Total_Track
    ), 2) 
FROM (SELECT COUNT(*) AS Total_Track FROM Track)

-- 9. Le nombre de clients qui ont d?pens? plus que le montant total moyen d?pens? par tous les clients
SELECT
    COUNT(*)
FROM
    (
        SELECT
            Customer.CustomerId
        FROM
            (
                Customer
                INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
            )
            INNER JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
        GROUP BY
            Customer.CustomerId
        HAVING
            (AVG(InvoiceLine.UnitPrice * InvoiceLine.Quantity) <= SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity))
    );

-- 10. Identifiez l'artiste le plus vendu du genre musical le plus populaire
SELECT *
FROM (
    SELECT 
        g.NAME AS GENRE_MUSICAL,
        ar.NAME AS ARTISTE,
        COUNT(il.INVOICELINEID) AS NOMBRE_VENTES
    FROM GENRE g
    INNER JOIN TRACK t ON g.GENREID = t.GENREID
    INNER JOIN ALBUM al ON t.ALBUMID = al.ALBUMID
    INNER JOIN ARTIST ar ON al.ARTISTID = ar.ARTISTID
    INNER JOIN INVOICELINE il ON t.TRACKID = il.TRACKID
    WHERE g.GENREID = (
        SELECT GENREID
        FROM (
            SELECT g2.GENREID
            FROM GENRE g2
            INNER JOIN TRACK t2 ON g2.GENREID = t2.GENREID
            INNER JOIN INVOICELINE il2 ON t2.TRACKID = il2.TRACKID
            GROUP BY g2.GENREID
            ORDER BY COUNT(il2.INVOICELINEID) DESC
        )
        WHERE ROWNUM = 1
    )
    GROUP BY g.NAME, ar.NAME, ar.ARTISTID
    ORDER BY COUNT(il.INVOICELINEID) DESC
)
WHERE ROWNUM = 1;


-- 11. Classez les pistes de chaque album par dur?e
SELECT * FROM 
(SELECT
    Album.AlbumId,
    SUM(Track.Milliseconds) AS Album_Length
FROM
    Track
    INNER JOIN Album ON Track.AlbumId = Album.AlbumId
GROUP BY
    Album.AlbumId)
ORDER BY Album_Length DESC;

-- 12. Calculez les d?penses des clients par rapport ? la moyenne de leur pays
SELECT
    Customer.Country,
    ROUND(
        AVG(InvoiceLine.UnitPrice * InvoiceLine.Quantity),
        2
    )
FROM
    (
        Customer
        INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    )
    INNER JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY
    Customer.Country;