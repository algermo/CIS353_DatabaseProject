SPOOL project.out
SET ECHO ON
/*
CIS 353 - Database Design Project
Molly Alger
Ella Konst
Kelsey Brennan
Kathryn Cook
*/
--
-- Drop tables if they already exist
--
DROP TABLE Animal CASCADE CONSTRAINTS;
DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE Parent CASCADE CONSTRAINTS;
DROP TABLE Volunteer CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE MedicalRecords CASCADE CONSTRAINTS;
DROP TABLE AnimalBreeds CASCADE CONSTRAINTS;
DROP TABLE VolunteersAt CASCADE CONSTRAINTS;
DROP TABLE Pay CASCADE CONSTRAINTS;
DROP TABLE AdoptionInfo CASCADE CONSTRAINTS;
--
-- Create tables
--
CREATE TABLE Animal 
(
aID 			INTEGER 	PRIMARY KEY,
name			CHAR(20),
species		CHAR(20)	NOT NULL,
birthdate		DATE,
medicalStatus	CHAR(50),
gender		CHAR(10),
locID			INTEGER	NOT NULL,
locStartDate	DATE		NOT NULL,
adoptionStatus	CHAR(15)	NOT NULL,
-- aIC1: Animal species allowed at the agency are dogs and cats
CONSTRAINT aIC1 CHECK (species IN ('dog', 'cat')),
-- aIC2: Adoption status can be Available, Unavailable, Adopted
CONSTRAINT aIC2 CHECK (adoptionStatus IN ('available', 'unavailable', 'adopted')),
-- aIC3: Medical status can be Healthy or Unhealthy
CONSTRAINT aIC3 CHECK (medicalStatus IN ('healthy', 'unhealthy')),
-- aIC4: Gender can be Male or Female
CONSTRAINT aIC4 CHECK (gender IN ('male', 'female'))
);
--
CREATE TABLE Location 
( 
locID		INTEGER,
address	CHAR(50)	NOT NULL,
phone		INTEGER	NOT NULL,
CONSTRAINT locIC1 PRIMARY KEY (locID)
);
--
CREATE TABLE Parent
(
pID 		INTEGER 	PRIMARY KEY,
name 		CHAR(15)	NOT NULL,
phone 	INTEGER,
address 	CHAR(50),
email  	CHAR(50)
);
--
CREATE TABLE Volunteer
(
vID		INTEGER	PRIMARY KEY,
name		CHAR(15)	NOT NULL,
phone		CHAR(15)	NOT NULL,
email		CHAR(50),
address	CHAR(50)
);
--
CREATE TABLE Pay
(
position 	CHAR(25)	PRIMARY KEY,
payRate	INTEGER	NOT NULL,
--paIC1: Every employee has to make minimum wage or greater
CONSTRAINT paIC1 CHECK (payRate >= 8.5),
--paIC2: If the position is Manager, the pay must be greater than or equal to $15
CONSTRAINT paIC2 CHECK (NOT(position = 'Manager' AND payRate < 15)),
--paIC3: Position can only be Manager, Assistant Manager, Vet, Nurse, or General Employee
CONSTRAINT paIC3 CHECK(position IN ('Manager', 'Assistant Manager', 'Vet', 'Nurse', 'General Employee'))
);
--
CREATE TABLE Employee
(
eID		INTEGER	PRIMARY KEY,
name		CHAR(15)	NOT NULL,
email		CHAR(50),
address	CHAR(50),
position 	CHAR(25)	NOT NULL,
hours		INTEGER,
locID		INTEGER	NOT NULL,
startDate	DATE,
-- eIC1: Employees can only work up to 40 hours a week
CONSTRAINT eIC1 CHECK (hours <= 40),
CONSTRAINT eIC2 FOREIGN KEY (position) references Pay(position) ON DELETE SET NULL
);
--
CREATE TABLE MedicalRecords
(
aID		INTEGER	NOT NULL,
pDate		DATE		NOT NULL,
procedure	CHAR(50)	NOT NULL,
PRIMARY KEY(aID, pDate, procedure)
);
--
CREATE TABLE AnimalBreeds
(
aID			INTEGER	NOT NULL,
animalBreed	CHAR(20)	NOT NULL,
PRIMARY KEY(aID, animalBreed)
);
--
CREATE TABLE VolunteersAt
(
vID		INTEGER	NOT NULL,
locID		INTEGER	NOT NULL,
hours		INTEGER,
startDate	DATE,
PRIMARY KEY (vID, locID),
--vaIC1: Volunteers can only work up to 25 hours a week per location.
CONSTRAINT vaIC1 CHECK (hours <=25)
);
--
CREATE TABLE AdoptionInfo
(
aID 		INTEGER	NOT NULL,
pID			INTEGER	NOT NULL,
adoptionType	CHAR(15) 	NOT NULL,
adoptionDate	DATE		NOT NULL,
PRIMARY KEY(aID, pID),
--aiIC1: Adoption type can only be Adopted or Fostered
CONSTRAINT aiIC1 CHECK (adoptionType IN ('adopted', 'fostered'))
);
--
-- Add foreign keys
--
ALTER TABLE Animal
ADD FOREIGN KEY (locID) references Location(locID)
Deferrable initially deferred;
ALTER TABLE Employee
ADD FOREIGN KEY (locID) references Location(locID)
Deferrable initially deferred;
ALTER TABLE MedicalRecords
ADD FOREIGN KEY (aID) references Animal(aID)
Deferrable initially deferred;
ALTER TABLE AnimalBreeds
ADD FOREIGN KEY (aID) references Animal(aID)
Deferrable initially deferred;
ALTER TABLE VolunteersAt
ADD FOREIGN KEY (vID) references Volunteer(vID)
Deferrable initially deferred;
ALTER TABLE VolunteersAt
ADD FOREIGN KEY (locID) references Location(locID)
Deferrable initially deferred;
ALTER TABLE AdoptionInfo
ADD FOREIGN KEY (aID) references Animal(aID)
Deferrable initially deferred;
ALTER TABLE AdoptionInfo
ADD FOREIGN KEY (pID) references Parent(pID)
Deferrable initially deferred;
--
--
SET FEEDBACK OFF
--
-- Inserting into Location table
--
INSERT INTO Location VALUES (21, '123 Main Street', 6165551234);
INSERT INTO Location VALUES (22, '2337 Lake Michigan Drive', 6165550987);
INSERT INTO Location VALUES (23, '10007 48th Avenue', 6165556337);
--
-- Inserting into Animal table
--
INSERT INTO Animal VALUES (1, 'Fido', 'dog', TO_DATE('03/08/2015', 'MM/DD/YY'), 'healthy', 'male', 21, TO_DATE('11/25/2015', 'MM/DD/YY'), 'available');
INSERT INTO Animal VALUES (2, 'Scruffy', 'dog', TO_DATE('08/17/2008', 'MM/DD/YY'), 'healthy', 'female', 22, TO_DATE('11/22/2011', 'MM/DD/YY'), 'available');
INSERT INTO Animal VALUES (3, 'Fluffy', 'cat', TO_DATE('11/25/2011', 'MM/DD/YY'), 'unhealthy', 'male', 21, TO_DATE('01/02/2013', 'MM/DD/YY'), 'unavailable');
INSERT INTO Animal VALUES (4, 'Piper', 'dog', TO_DATE('05/20/2014', 'MM/DD/YY'), 'healthy', 'male', 23, TO_DATE('08/20/2014','MM/DD/YY'), 'unavailable');
INSERT INTO Animal VALUES (5, null, 'cat', null, null, null, 21, TO_DATE('04/09/2016', 'MM/DD/YY'), 'available');
INSERT INTO Animal VALUES (6, 'Rascal', 'cat', TO_DATE('07/14/2009', 'MM/DD/YY'), 'healthy', 'male', 22, TO_DATE('07/01/2009', 'MM/DD/YY'), 'unavailable');
INSERT INTO Animal VALUES (7, 'Callie', 'cat', null, 'healthy', 'female', 22, TO_DATE('01/12/2013', 'MM/DD/YY'), 'unavailable');
INSERT INTO Animal VALUES (8, 'Albi', 'dog', null, 'unhealthy', 'male', 21, TO_DATE('04/23/2004', 'MM/DD/YY'), 'available');
--
-- Inserting into Parent table
--
INSERT INTO Parent VALUES (31, 'John Doe', 6165550011, '111 Main Street', 'johndoe@gmail.com');
INSERT INTO Parent VALUES (32, 'Jane Smith', null, '9988 Fulton Street', 'janesmith@gmail.com');
INSERT INTO Parent VALUES (33, 'Tom Green', 6165555586, '10744 48th Avenue', null);
INSERT INTO Parent VALUES (34, 'Fred Lander', null, null, null);
INSERT INTO Parent VALUES (35, 'Jonathan Joly', 6165554985, null, 'jonj2000@hotmail.com');
--
-- Inserting into Volunteer table
--
INSERT INTO Volunteer VALUES (51, 'Sarah Coleman', 6165551278, 'sarahcoleman@gmail.com', '5555 8th Street');
INSERT INTO Volunteer VALUES (52, 'Joe Stevens', 6165551278, null, '976 42nd Avenue');
INSERT INTO Volunteer VALUES (53, 'Michael Smith', 8105556060, 'mikesmith@gmail.com', null);
INSERT INTO Volunteer VALUES (54, 'Anna Saccone', 6165554691, 'annasaccone@charter.net', null);
--
-- Inserting into Pay table
--
INSERT INTO Pay VALUES ('Manager', 20);
INSERT INTO Pay VALUES ('Assistant Manager', 11);
INSERT INTO Pay VALUES ('Vet', 25);
INSERT INTO Pay VALUES ('Nurse', 15);
INSERT INTO Pay VALUES ('General Employee', 8.5);
--
-- Inserting into Employee table
--
INSERT INTO Employee VALUES (41, 'Rachel Rogers', 'rachrogers@gmail.com', '65478 Lake Michigan Drive', 'Manager', 40, 21, TO_DATE('1/19/2011', 'MM/DD/YY'));
INSERT INTO Employee VALUES (42, 'Andrew Bates', 'abates@gmail.com', '12345 48th Avenue', 'Nurse', 30, 22, TO_DATE('9/8/2015', 'MM/DD/YY'));
INSERT INTO Employee VALUES (43, 'Megan West', 'westme@gmail.com', '999 56th Avenue', 'General Employee', null, 21, null);
INSERT INTO Employee VALUES (44, 'Ethan Scott', 'eScott@outlook.com', null, 'Assistant Manager', 20, 23, TO_DATE('06/18/2013', 'MM/DD/YY'));
INSERT INTO Employee VALUES (45, 'Eliza Harold', 'elizaharold@yahoo.com', '1643 Main St.', 'Vet', 15, 22, TO_DATE('12/02/2014', 'MM/DD/YY'));
--
-- Inserting into Medical Records table
--
INSERT INTO MedicalRecords VALUES (1, TO_DATE('11/30/2015', 'MM/DD/YY'), 'Neuter');
INSERT INTO MedicalRecords VALUES (1, TO_DATE('12/30/2015', 'MM/DD/YY'), 'Vaccines');
INSERT INTO MedicalRecords VALUES (4, TO_DATE('08/04/2014', 'MM/DD/YY'), 'Vaccines');
INSERT INTO MedicalRecords VALUES (8, TO_DATE('04/04/2006', 'MM/DD/YY'), 'Neuter');
INSERT INTO MedicalRecords VALUES (8, TO_DATE('01/25/2011', 'MM/DD/YY'), 'Eye Surgery');
--
-- Inserting into Animal Breeds table
--
INSERT INTO AnimalBreeds VALUES (1, 'Black Lab');
INSERT INTO AnimalBreeds VALUES (2, 'Pug');
INSERT INTO AnimalBreeds VALUES (3, 'Ragdoll');
INSERT INTO AnimalBreeds VALUES (4, 'Shih Tzu');
INSERT INTO AnimalBreeds VALUES (4, 'Mini Toy Poodle');
INSERT INTO AnimalBreeds VALUES (5, 'Manx');
INSERT INTO AnimalBreeds VALUES (6, 'Orange Tabby');
INSERT INTO AnimalBreeds VALUES (7, 'Calico');
INSERT INTO AnimalBreeds VALUES (8, 'Maltese');
INSERT INTO AnimalBreeds VALUES (8, 'Poodle');
--
-- Inserting into VolunteersAt table
--
INSERT INTO VolunteersAt VALUES (51, 21, 10, TO_DATE('08/04/2015', 'MM/DD/YY'));
INSERT INTO VolunteersAt VALUES (51, 23, 5, TO_DATE('08/04/2015', 'MM/DD/YY'));
INSERT INTO VolunteersAt VALUES (52, 21, 25, TO_DATE('05/15/2012', 'MM/DD/YY'));
INSERT INTO VolunteersAt VALUES (53, 23, 5, TO_DATE('02/20/2016', 'MM/DD/YY'));
INSERT INTO VolunteersAt VALUES (54, 21, 10, TO_DATE('06/05/2004', 'MM/DD/YY'));
INSERT INTO VolunteersAt VALUES (54, 22, 18, TO_DATE('01/13/2009', 'MM/DD/YY'));
INSERT INTO VolunteersAt VALUES (54, 23, 23, TO_DATE('12/05/2010', 'MM/DD/YY'));
--
-- Inserting into Adoption Info table
--
INSERT INTO AdoptionInfo VALUES(1, 31, 'fostered', TO_DATE('02/22/2016', 'MM/DD/YY'));
INSERT INTO AdoptionInfo VALUES(3, 32, 'adopted', TO_DATE('06/27/2014', 'MM/DD/YY'));
INSERT INTO AdoptionInfo VALUES(4, 33, 'adopted', TO_DATE('08/11/2014', 'MM/DD/YY'));
INSERT INTO AdoptionInfo VALUES(6, 34, 'adopted', TO_DATE('07/30/2009', 'MM/DD/YY'));
INSERT INTO AdoptionInfo VALUES(7, 34, 'adopted', TO_DATE('02/11/2013', 'MM/DD/YY'));
INSERT INTO AdoptionInfo VALUES(8, 35, 'fostered', TO_DATE('06/30/2005', 'MM/DD/YY'));
SET FEEDBACK ON
COMMIT
SELECT * FROM Animal;
SELECT * FROM Location;
SELECT * FROM Parent;
SELECT * FROM Volunteer;
SELECT * FROM Employee;
SELECT * FROM MedicalRecords;
SELECT * FROM AnimalBreeds;
SELECT * FROM VolunteersAt;
SELECT * FROM Pay;
SELECT * FROM AdoptionInfo;
--
-- QUERIES
--
-- Q1: Join with 4 relations
-- Find the name and birthdate of every dog that has been adopted as 
-- well as the address of the location they were adopted from and the 
-- name of the person who adopted them.
--
SELECT A.name, A.birthdate, L.address, P.name
FROM Animal A, AdoptionInfo AI, Location L, Parent P
WHERE A.aID = AI.aID		AND
	AI.pID = P.pID		AND
	A.locID = L.locID	AND
	A.species = 'dog';
--
-- Q2: Self-join
-- Find the names and IDs of every employee who works at the same 
-- location, as well at the address of the location they work at. 
-- Remove duplicates.
--
SELECT E1.eID, E1.name, E2.eID, E2.name, L.address
FROM Employee E1, Employee E2, Location L
WHERE E1.eID > E2.eID		AND
	E1.locID = E2.locID	AND
	E1.locID = L.locID;
-- 
-- Q3: Union, intersect, or minus
-- Find the name and species of all animals who are at location ID 22
-- (Lake Michigan drive) and are not dogs.
--
SELECT name, species
FROM Animal
WHERE locID = 22
MINUS
SELECT name, species
FROM Animal
WHERE species = 'dog';
--
-- Q4: Sum, avg, min, or max
-- Find the number of hours for the volunteer who works the most hours 
-- at the main location (location ID 21).
--
SELECT MAX(hours)
FROM VolunteersAt
WHERE locID = 21;
--
-- Q5: Group by, having, and order by
-- Find all locations with more than one cat and list them in order -- by locID. 
SELECT L.locID, Count(*)
FROM location L, Animal A
WHERE L.locID = A.locID AND A.species = 'cat'
GROUP BY L.locID
HAVING Count(*) > 1
ORDER BY L.locID;
--
-- Q6: Correlated subquery
-- Find the animal ID, name, species, and breed of all animals who
-- are healthy but have not been adopted.
-- Order by animal ID.
--
SELECT A.aid, A.name, A.species, B.animalbreed
FROM Animal A, AnimalBreeds B
WHERE A.medicalStatus = 'healthy' AND
A.aid = B.aid AND
NOT EXISTS (SELECT *
		 FROM AdoptionInfo I
		 WHERE A.aid = I.aid AND
		 adoptionType = 'adopted')
ORDER BY A.aid;
--
-- Q7: Non-correlated subquery
-- Find the employee ID and name for every employee who works at
-- the main location (location ID 21) but makes less than $12.
-- Order by employee ID
--
SELECT eid, name
FROM Employee
WHERE locID = 21 AND
	position NOT IN (SELECT P.position
			 FROM Pay P
			 WHERE payRate > 12)
ORDER BY eid;
--
-- Q8: Relation division
-- Find the ID and name of every parent who has adopted every cat from location 22.
--
SELECT P.pid, P.name
FROM Parent P
WHERE NOT EXISTS((SELECT A.aid
			FROM Animal A
			WHERE A.species = 'cat' AND A.locID = 22)
			MINUS
			(SELECT A.aid
			FROM Animal A, AdoptionInfo I
			WHERE A.aid = I.aid AND
			P.pid = I.pid AND
			A.species = 'cat' AND
			A.locID = 22));
--
-- Q9: Outer join
-- Find the ID, name, and gender of every cat, as well as the name of 
-- their parent if they have been adopted. Order by animal ID.
--
SELECT A.aID, A.name, A.gender, P.name
FROM Animal A
LEFT OUTER JOIN AdoptionInfo AI ON A.aID = AI.aID
LEFT OUTER JOIN Parent P ON AI.pID = p.pID
WHERE A.species = 'cat'
ORDER BY A.aID;
--
-- TESTING ICS 
--
-- Testing: locIC1 (Key)
-- Inserting a new location with an existing ID number should fail.
INSERT INTO Location VALUES (22, '123 Sesame St', 6165554567);
--
-- Testing: eIC2 (Foreign Key)
-- Trying to change an employee’s position to 'Owner', which does not 
-- exist in Pay, should fail.
UPDATE Employee SET position = 'Owner' WHERE eID = 41;
--
-- Testing: aiIC1 (1 attribute)
-- Inserting an animal of a species other than dog or cat should fail.
INSERT INTO Animal VALUES (67, 'Bill', 'parrot', null, null, 'male', 21, TO_DATE('03/09/2015', 'MM/DD/YY'), 'available');
--
-- Testing: paIC2 (2 attribute 1 row)
-- Attempts to update pay of Manager to 9 dollars should fail.
UPDATE Pay SET payRate = 9 WHERE position = 'Manager';
--
COMMIT
--
SPOOL OFF