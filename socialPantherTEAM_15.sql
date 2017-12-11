-- Drop all tables
DROP TABlE PROFILE CASCADE CONSTRAINTS;
DROP TABLE FRIENDS CASCADE CONSTRAINTS;
DROP TABLE PENDINGFRIENDS CASCADE CONSTRAINTS;
DROP TABLE MESSAGES CASCADE CONSTRAINTS;
DROP TABLE MESSAGERECIPIENT CASCADE CONSTRAINTS;
DROP TABLE GROUPS CASCADE CONSTRAINTS;
DROP TABLE PENDINGGROUPMEMBERS CASCADE CONSTRAINTS;
DROP TABLE GROUPMEMBERSHIP CASCADE CONSTRAINTS;

--CREATE THE PROFILE TABLE FIRST SINCE MANY TABLES REFERENCE THIS TABLE
CREATE TABLE PROFILE(
  userID      varchar2(20)       not null deferrable,
  name   varchar2(50)    not null deferrable,
  email  varchar2(50) not null deferrable,
  password          varchar2(50) not null deferrable,
  dateOfBirth            date not null deferrable,
  lastLogin             timestamp,
  CONSTRAINT PROFILE_PK PRIMARY KEY (userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT PROFILE_UN UNIQUE(email) INITIALLY IMMEDIATE DEFERRABLE
);

CREATE TABLE FRIENDS(
  userID1 varchar2(20) not null deferrable,
  userID2 varchar2(20) not null deferrable,
  JDate date,
  message varchar2(200),
  CONSTRAINT FRIENDS_PK PRIMARY KEY (userID1, userID2) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT FRIENDS_FK1 FOREIGN KEY (userID1) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT FRIENDS_FK2 FOREIGN KEY (userID2) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

CREATE TABLE PENDINGFRIENDS(
  fromID varchar2(20) not null deferrable,
  toID varchar2(20) not null deferrable,
  message varchar2(200),
  CONSTRAINT PENDINGFRIENDS_PK PRIMARY KEY (fromID,toID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT PENDINGFRIENDS_FK1 FOREIGN KEY (fromID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT PENDINGFRIENDS_FK2 FOREIGN KEY (toID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);
-- A couple tables reference the table GROUPS
CREATE TABLE GROUPS(
  gID integer not null deferrable,
  name varchar2(50) not null deferrable,
  description varchar2(200),
  lim integer not null deferrable,
  CONSTRAINT GROUPS_PK PRIMARY KEY (gID) INITIALLY IMMEDIATE DEFERRABLE
);
---Assumes users can be deleted but messages can still be retained, just without the deleted user
CREATE TABLE MESSAGES(
  msgID varchar2(20) not null deferrable,
  fromID varchar2(20),
  message varchar2(200) default null,
  toUserID varchar2(20),
  toGroupID integer default null,
  dateSend timestamp not null deferrable,
  CONSTRAINT MESSAGES_PK PRIMARY KEY (msgID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT MESSAGES_FK1 FOREIGN KEY (fromID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT MESSAGES_FK2 FOREIGN KEY (toUserID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT MESSAGES_FK3 FOREIGN KEY (toGroupID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE
);
---Assumes users can be deleted but messages can be retained without the user
CREATE TABLE MESSAGERECIPIENT(
  msgID varchar2(20) not null deferrable,
  userID varchar2(20),
  CONSTRAINT MESSAGERECIPIENT PRIMARY KEY (msgID),
  CONSTRAINT MESSAGERECIPIENT_FK1 FOREIGN KEY (msgID) REFERENCES MESSAGES(msgID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT MESSAGERECIPIENT_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

CREATE TABLE PENDINGGROUPMEMBERS(
  gID integer not null deferrable,
  userID varchar2(20) not null deferrable,
  message varchar2(200) default null,
  CONSTRAINT PENDINGGROUPMEMBERS_PK PRIMARY KEY (gID,userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT PENDINGGROUPMEMBERS_FK1 FOREIGN KEY (gID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT PENDINGGROUPMEMBERS_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

CREATE TABLE GROUPMEMBERSHIP(
  gID integer not null deferrable,
  userID varchar2(20) not null deferrable,
  role varchar2(20) default('Member'),
  CONSTRAINT GROUPMEMBERSHIP_PK PRIMARY KEY (gID, userID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT GROUPMEMBERSHIP_FK1 FOREIGN KEY (gID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE,
  CONSTRAINT GROUPMEMBERSHIP_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

INSERT INTO PROFILE values('28328', 'Beulah', '28328@pitt.edu', 'pass', '4-August-1935', null);
INSERT INTO PROFILE values('3c69a', 'Morgan', '3c69a@pitt.edu', 'pass', '27-May-1907', null);
INSERT INTO PROFILE values('3dad9', 'Fran', '3dad9@pitt.edu', 'pass', '14-September-1928', null);
INSERT INTO PROFILE values('31430', 'Myron', '31430@pitt.edu', 'pass', '27-December-1937', null);
INSERT INTO PROFILE values('9965c', 'Arden', '9965c@pitt.edu', 'pass', '30-September-1931', null);
INSERT INTO PROFILE values('38eec', 'Margarite', '38eec@pitt.edu', 'pass', '16-July-1956', null);
INSERT INTO PROFILE values('05fb5', 'Cyndy', '05fb5@pitt.edu', 'pass', '23-September-1982', null);
INSERT INTO PROFILE values('a4854', 'Margarite', 'a4854@pitt.edu', 'pass', '26-July-1953', null);
INSERT INTO PROFILE values('c6538', 'Fran', 'c6538@pitt.edu', 'pass', '17-April-1981', null);
INSERT INTO PROFILE values('0b034', 'Bernardo', '0b034@pitt.edu', 'pass', '14-April-1917', null);
INSERT INTO PROFILE values('0dd06', 'Anika', '0dd06@pitt.edu', 'pass', '12-December-1988', null);
INSERT INTO PROFILE values('9bf36', 'Teodoro', '9bf36@pitt.edu', 'pass', '12-January-1990', null);
INSERT INTO PROFILE values('124a6', 'Bernardo', '124a6@pitt.edu', 'pass', '10-May-1909', null);
INSERT INTO PROFILE values('b0cb1', 'Arden', 'b0cb1@pitt.edu', 'pass', '29-May-1945', null);
INSERT INTO PROFILE values('c7443', 'Lynwood', 'c7443@pitt.edu', 'pass', '23-October-1963', null);
INSERT INTO PROFILE values('8279d', 'Bernardo', '8279d@pitt.edu', 'pass', '9-December-1919', null);
INSERT INTO PROFILE values('63dfb', 'Lynwood', '63dfb@pitt.edu', 'pass', '13-February-1961', null);
INSERT INTO PROFILE values('2b1e4', 'Darlena', '2b1e4@pitt.edu', 'pass', '24-December-1919', null);
INSERT INTO PROFILE values('930ad', 'Morgan', '930ad@pitt.edu', 'pass', '5-January-1964', null);
INSERT INTO PROFILE values('a6723', 'Anika', 'a6723@pitt.edu', 'pass', '28-February-1926', null);
INSERT INTO PROFILE values('3392a', 'Kathi', '3392a@pitt.edu', 'pass', '26-August-1925', null);
INSERT INTO PROFILE values('cf978', 'Beulah', 'cf978@pitt.edu', 'pass', '27-October-1961', null);
INSERT INTO PROFILE values('56877', 'Darlena', '56877@pitt.edu', 'pass', '16-February-1904', null);
INSERT INTO PROFILE values('1a812', 'Cyndy', '1a812@pitt.edu', 'pass', '21-November-1933', null);
INSERT INTO PROFILE values('4f9d6', 'Lynwood', '4f9d6@pitt.edu', 'pass', '7-June-1997', null);
INSERT INTO PROFILE values('bc4a5', 'Arden', 'bc4a5@pitt.edu', 'pass', '5-January-1954', null);
INSERT INTO PROFILE values('79d7f', 'Kathi', '79d7f@pitt.edu', 'pass', '16-February-1973', null);
INSERT INTO PROFILE values('e2e0c', 'Jeanne', 'e2e0c@pitt.edu', 'pass', '26-January-1954', null);
INSERT INTO PROFILE values('dbd1c', 'Beulah', 'dbd1c@pitt.edu', 'pass', '25-October-1928', null);
INSERT INTO PROFILE values('95d3d', 'Irwin', '95d3d@pitt.edu', 'pass', '30-December-1994', null);
INSERT INTO PROFILE values('f1799', 'Morgan', 'f1799@pitt.edu', 'pass', '31-July-1949', null);
INSERT INTO PROFILE values('dd0b1', 'Cyndy', 'dd0b1@pitt.edu', 'pass', '23-April-1985', null);
INSERT INTO PROFILE values('ee57d', 'Fran', 'ee57d@pitt.edu', 'pass', '22-September-1907', null);
INSERT INTO PROFILE values('c16bf', 'Lynwood', 'c16bf@pitt.edu', 'pass', '30-November-1987', null);
INSERT INTO PROFILE values('ae01f', 'Kathi', 'ae01f@pitt.edu', 'pass', '17-July-1930', null);
INSERT INTO PROFILE values('4620b', 'Lynwood', '4620b@pitt.edu', 'pass', '17-August-1920', null);
INSERT INTO PROFILE values('7927f', 'Darlena', '7927f@pitt.edu', 'pass', '20-April-1974', null);
INSERT INTO PROFILE values('4d5de', 'Arden', '4d5de@pitt.edu', 'pass', '1-March-1997', null);
INSERT INTO PROFILE values('39aa8', 'Arden', '39aa8@pitt.edu', 'pass', '25-May-1930', null);
INSERT INTO PROFILE values('d4d42', 'Seymour', 'd4d42@pitt.edu', 'pass', '24-August-1933', null);
INSERT INTO PROFILE values('ea99f', 'Cyndy', 'ea99f@pitt.edu', 'pass', '1-May-1973', null);
INSERT INTO PROFILE values('fc81c', 'Anika', 'fc81c@pitt.edu', 'pass', '15-May-1900', null);
INSERT INTO PROFILE values('78178', 'Edison', '78178@pitt.edu', 'pass', '20-March-1922', null);
INSERT INTO PROFILE values('f14ee', 'Asa', 'f14ee@pitt.edu', 'pass', '17-December-1975', null);
INSERT INTO PROFILE values('c1de3', 'Anika', 'c1de3@pitt.edu', 'pass', '9-September-1979', null);
INSERT INTO PROFILE values('e0564', 'Arden', 'e0564@pitt.edu', 'pass', '6-April-1990', null);
INSERT INTO PROFILE values('bde19', 'Kathi', 'bde19@pitt.edu', 'pass', '28-April-1913', null);
INSERT INTO PROFILE values('9e88e', 'Giselle', '9e88e@pitt.edu', 'pass', '30-November-1966', null);
INSERT INTO PROFILE values('25c82', 'Myron', '25c82@pitt.edu', 'pass', '2-February-1959', null);
INSERT INTO PROFILE values('7c983', 'Darlena', '7c983@pitt.edu', 'pass', '10-February-1961', null);
INSERT INTO PROFILE values('32601', 'Jeanne', '32601@pitt.edu', 'pass', '27-February-1988', null);
INSERT INTO PROFILE values('70026', 'Lara', '70026@pitt.edu', 'pass', '18-December-1992', null);
INSERT INTO PROFILE values('a29bb', 'Morgan', 'a29bb@pitt.edu', 'pass', '2-November-1960', null);
INSERT INTO PROFILE values('ceb89', 'Morgan', 'ceb89@pitt.edu', 'pass', '18-September-1950', null);
INSERT INTO PROFILE values('682fc', 'Jeanne', '682fc@pitt.edu', 'pass', '6-September-1969', null);
INSERT INTO PROFILE values('6b3ad', 'Morgan', '6b3ad@pitt.edu', 'pass', '4-May-1930', null);
INSERT INTO PROFILE values('ab2a2', 'Cyndy', 'ab2a2@pitt.edu', 'pass', '12-July-1923', null);
INSERT INTO PROFILE values('d066b', 'Myron', 'd066b@pitt.edu', 'pass', '25-February-1915', null);
INSERT INTO PROFILE values('150c6', 'Irwin', '150c6@pitt.edu', 'pass', '31-October-1952', null);
INSERT INTO PROFILE values('b1088', 'Seymour', 'b1088@pitt.edu', 'pass', '24-September-1967', null);
INSERT INTO PROFILE values('32f09', 'Myron', '32f09@pitt.edu', 'pass', '14-September-1982', null);
INSERT INTO PROFILE values('24746', 'Teodoro', '24746@pitt.edu', 'pass', '19-September-1975', null);
INSERT INTO PROFILE values('d42f0', 'Bernardo', 'd42f0@pitt.edu', 'pass', '25-October-1940', null);
INSERT INTO PROFILE values('5e4b8', 'Teodoro', '5e4b8@pitt.edu', 'pass', '8-March-1974', null);
INSERT INTO PROFILE values('295a0', 'Teodoro', '295a0@pitt.edu', 'pass', '8-January-1974', null);
INSERT INTO PROFILE values('a3cd0', 'Beulah', 'a3cd0@pitt.edu', 'pass', '18-October-1960', null);
INSERT INTO PROFILE values('9ba78', 'Bernardo', '9ba78@pitt.edu', 'pass', '29-March-1974', null);
INSERT INTO PROFILE values('713e0', 'Edison', '713e0@pitt.edu', 'pass', '2-June-1965', null);
INSERT INTO PROFILE values('c7c36', 'Bernardo', 'c7c36@pitt.edu', 'pass', '8-June-1988', null);
INSERT INTO PROFILE values('7bc17', 'Bernardo', '7bc17@pitt.edu', 'pass', '8-August-1928', null);
INSERT INTO PROFILE values('f508d', 'Anika', 'f508d@pitt.edu', 'pass', '15-May-1931', null);
INSERT INTO PROFILE values('ca2cf', 'Giselle', 'ca2cf@pitt.edu', 'pass', '12-April-1949', null);
INSERT INTO PROFILE values('e742f', 'Arden', 'e742f@pitt.edu', 'pass', '1-June-1927', null);
INSERT INTO PROFILE values('c522f', 'Jeanne', 'c522f@pitt.edu', 'pass', '22-December-1944', null);
INSERT INTO PROFILE values('fe394', 'Margarite', 'fe394@pitt.edu', 'pass', '14-January-1949', null);
INSERT INTO PROFILE values('a04c7', 'Seymour', 'a04c7@pitt.edu', 'pass', '14-January-1946', null);
INSERT INTO PROFILE values('43ec9', 'Darlena', '43ec9@pitt.edu', 'pass', '20-March-1942', null);
INSERT INTO PROFILE values('bd049', 'Lara', 'bd049@pitt.edu', 'pass', '1-October-1947', null);
INSERT INTO PROFILE values('ab9fe', 'Irwin', 'ab9fe@pitt.edu', 'pass', '6-December-1985', null);
INSERT INTO PROFILE values('144f6', 'Beulah', '144f6@pitt.edu', 'pass', '13-September-1935', null);
INSERT INTO PROFILE values('268de', 'Cyndy', '268de@pitt.edu', 'pass', '13-September-1998', null);
INSERT INTO PROFILE values('7335c', 'Myron', '7335c@pitt.edu', 'pass', '6-May-1938', null);
INSERT INTO PROFILE values('45bf9', 'Jeanne', '45bf9@pitt.edu', 'pass', '3-May-1924', null);
INSERT INTO PROFILE values('8f1b4', 'Teodoro', '8f1b4@pitt.edu', 'pass', '24-August-1944', null);
INSERT INTO PROFILE values('58c8d', 'Giselle', '58c8d@pitt.edu', 'pass', '25-April-1942', null);
INSERT INTO PROFILE values('75c3b', 'Lara', '75c3b@pitt.edu', 'pass', '19-July-1955', null);
INSERT INTO PROFILE values('7960d', 'Seymour', '7960d@pitt.edu', 'pass', '25-July-1995', null);
INSERT INTO PROFILE values('52089', 'Giselle', '52089@pitt.edu', 'pass', '16-February-1920', null);
INSERT INTO PROFILE values('c6467', 'Asa', 'c6467@pitt.edu', 'pass', '5-February-1905', null);
INSERT INTO PROFILE values('1c808', 'Beulah', '1c808@pitt.edu', 'pass', '22-September-1943', null);
INSERT INTO PROFILE values('5f6ee', 'Seymour', '5f6ee@pitt.edu', 'pass', '1-August-1964', null);
INSERT INTO PROFILE values('c4686', 'Bernardo', 'c4686@pitt.edu', 'pass', '8-July-1920', null);
INSERT INTO PROFILE values('3af95', 'Teodoro', '3af95@pitt.edu', 'pass', '23-November-1960', null);
INSERT INTO PROFILE values('e9f91', 'Teodoro', 'e9f91@pitt.edu', 'pass', '19-November-1916', null);
INSERT INTO PROFILE values('5ef3c', 'Lara', '5ef3c@pitt.edu', 'pass', '3-September-1997', null);
INSERT INTO PROFILE values('df2b8', 'Darlena', 'df2b8@pitt.edu', 'pass', '21-May-1907', null);
INSERT INTO PROFILE values('2307a', 'Irwin', '2307a@pitt.edu', 'pass', '8-March-1905', null);
INSERT INTO PROFILE values('1e9d9', 'Asa', '1e9d9@pitt.edu', 'pass', '27-April-1967', null);
INSERT INTO PROFILE values('9c1ec', 'Fran', '9c1ec@pitt.edu', 'pass', '19-January-1933', null);
INSERT INTO PROFILE values('34677', 'Lynwood', '34677@pitt.edu', 'pass', '5-September-1968', null);

INSERT INTO FRIENDS values('25c82', 'ca2cf', '26-January-1949', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('78178', '75c3b', '29-September-1996', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('268de', 'fe394', '8-October-1996', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('713e0', 'fe394', '31-August-1967', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dd0b1', 'e742f', '29-June-1929', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9c1ec', '713e0', '27-March-1930', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1c808', 'e2e0c', '16-June-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('bde19', 'bde19', '30-May-1901', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7443', '56877', '26-August-1969', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('24746', 'a3cd0', '13-April-1981', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('5ef3c', '34677', '20-July-1975', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('7335c', '5ef3c', '25-November-1928', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c6538', 'a4854', '9-February-1967', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('930ad', '268de', '22-October-1952', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('df2b8', '25c82', '9-March-1942', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('75c3b', 'a4854', '25-February-1985', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('5ef3c', 'e9f91', '19-March-1985', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1c808', '1c808', '2-January-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c6467', 'bde19', '18-November-1939', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('39aa8', '43ec9', '4-November-1912', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ea99f', '9e88e', '22-September-1946', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1a812', '7c983', '28-March-1957', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('43ec9', 'dbd1c', '19-August-1925', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('7c983', '39aa8', '14-May-1951', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('682fc', 'dd0b1', '20-October-1991', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a04c7', '4620b', '27-June-1942', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('0b034', 'd42f0', '17-February-1941', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('7c983', 'd42f0', '23-April-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('28328', '8279d', '20-September-1948', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('cf978', 'f508d', '29-December-1966', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ea99f', 'f1799', '24-February-1939', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c16bf', '9965c', '10-October-1959', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e9f91', '3dad9', '23-December-1994', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('fe394', '39aa8', '14-February-1928', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9e88e', '295a0', '12-May-1939', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9e88e', '28328', '26-January-1910', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e742f', '7335c', '17-September-1936', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('bd049', '268de', '25-July-1909', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('38eec', 'df2b8', '9-February-1907', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a6723', 'a3cd0', '31-July-1941', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('39aa8', '2307a', '6-July-1929', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a04c7', '7bc17', '13-June-1929', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8f1b4', 'ab2a2', '20-November-1941', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dbd1c', '32f09', '24-December-1929', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('d066b', '295a0', '1-February-1914', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('713e0', '295a0', '17-December-1915', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('52089', 'ee57d', '2-August-1994', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e0564', 'dbd1c', '22-January-1994', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('fc81c', '1e9d9', '18-May-1938', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dd0b1', '4d5de', '4-July-1942', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8f1b4', 'd4d42', '16-September-1981', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4d5de', 'c16bf', '23-September-1913', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('6b3ad', 'ca2cf', '16-January-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c522f', '930ad', '27-July-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('150c6', 'e9f91', '27-February-1943', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('144f6', '05fb5', '14-February-1948', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c1de3', '713e0', '15-June-1972', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('d42f0', '7bc17', '6-October-1954', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('930ad', '2b1e4', '15-April-1974', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9ba78', '25c82', '9-October-1954', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('78178', '2307a', '4-August-1980', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7443', 'df2b8', '6-October-1924', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('150c6', 'f1799', '16-April-1920', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('05fb5', 'ae01f', '12-April-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e2e0c', 'ca2cf', '26-June-1967', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4d5de', '95d3d', '28-January-1922', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e9f91', '2307a', '9-March-1913', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9965c', 'e0564', '25-December-1947', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4f9d6', '7c983', '1-February-1914', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('32601', 'a4854', '4-November-1984', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ceb89', 'b0cb1', '14-November-1913', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('2b1e4', '4620b', '15-July-1964', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('34677', '05fb5', '1-October-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('268de', '0b034', '13-March-1998', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('bd049', 'ab9fe', '8-February-1941', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('52089', '75c3b', '1-June-1988', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('295a0', 'f508d', '7-September-1977', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c1de3', 'ae01f', '3-October-1946', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('df2b8', '1e9d9', '3-May-1949', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('32601', 'e2e0c', '19-September-1918', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('52089', '4d5de', '4-January-1922', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a04c7', 'ae01f', '12-May-1963', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('39aa8', '3dad9', '27-September-1959', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ceb89', '124a6', '22-October-1927', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7c36', 'dbd1c', '11-May-1960', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('56877', '75c3b', '19-February-1901', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4f9d6', '4f9d6', '28-November-1956', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3dad9', 'ceb89', '14-September-1940', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('b0cb1', '3dad9', '23-February-1911', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3392a', '32f09', '27-May-1912', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('32f09', '930ad', '11-January-1921', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('28328', 'ab2a2', '15-March-1943', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a4854', '7bc17', '8-November-1941', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ae01f', '1c808', '20-February-1905', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e742f', 'dbd1c', '23-June-1945', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('58c8d', 'dd0b1', '14-February-1926', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4f9d6', '95d3d', '31-January-1955', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('144f6', 'dbd1c', '29-November-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('268de', 'd066b', '29-March-1956', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('45bf9', '3392a', '11-April-1985', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9c1ec', '79d7f', '22-February-1978', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('713e0', '4d5de', '24-July-1906', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1e9d9', '4d5de', '15-July-1943', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('75c3b', '52089', '3-December-1951', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3dad9', '713e0', '5-June-1971', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7c36', 'f1799', '21-December-1950', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9bf36', '682fc', '21-June-1975', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('63dfb', 'b0cb1', '9-November-1916', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('32601', 'ca2cf', '19-November-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a6723', '3392a', '16-October-1953', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a4854', 'ee57d', '18-October-1935', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c522f', '1e9d9', '6-June-1964', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('52089', '4f9d6', '29-April-1977', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4620b', '6b3ad', '30-November-1962', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3c69a', 'ae01f', '7-December-1917', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ab9fe', 'f14ee', '1-February-1936', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e2e0c', '31430', '5-May-2000', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('79d7f', 'a29bb', '13-January-1930', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('d42f0', '4f9d6', '15-November-1969', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('56877', '05fb5', '8-April-1986', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1a812', '7335c', '8-February-1964', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7443', 'ab2a2', '27-August-1928', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('0dd06', 'bd049', '4-September-1969', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8f1b4', 'c6467', '2-October-1909', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('2b1e4', 'bde19', '30-April-1978', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('e9f91', 'a4854', '5-May-1962', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8f1b4', '9965c', '7-August-1965', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('b1088', 'c7443', '2-October-1938', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a6723', '930ad', '14-February-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('295a0', '8f1b4', '25-January-1967', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('713e0', '4f9d6', '17-February-1925', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('bde19', '05fb5', '11-May-1958', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ab9fe', '4d5de', '6-August-1937', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9e88e', '7c983', '18-December-1961', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('39aa8', '05fb5', '11-June-1978', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('fc81c', 'bde19', '8-March-1964', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ea99f', '2307a', '7-May-1954', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8279d', '3af95', '20-November-1998', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('7bc17', 'dd0b1', '11-January-1928', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('fe394', '268de', '11-April-1976', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('7c983', '9e88e', '4-April-1933', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('5f6ee', '144f6', '21-June-1932', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1a812', '9965c', '22-July-1983', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('95d3d', 'ceb89', '2-August-1988', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3c69a', '8279d', '17-March-1997', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('0dd06', '38eec', '18-September-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('268de', '3af95', '10-March-1941', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('124a6', '4f9d6', '31-August-1999', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c1de3', '8f1b4', '26-August-1915', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('f1799', 'c6467', '16-March-1921', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ee57d', '56877', '30-November-1901', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8279d', 'f1799', '6-May-1970', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a29bb', '2307a', '23-February-1982', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('56877', 'ab2a2', '10-July-1960', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('268de', 'c522f', '25-August-1908', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dbd1c', 'e0564', '3-July-1996', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3dad9', '8f1b4', '31-March-1981', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('6b3ad', '7960d', '30-June-1930', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1c808', 'fc81c', '6-February-1948', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('34677', '34677', '18-April-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('cf978', '78178', '10-June-2000', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3392a', '8279d', '28-March-1971', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9ba78', 'a3cd0', '13-September-1944', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dd0b1', 'ae01f', '30-April-1918', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('58c8d', 'e0564', '22-December-1927', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('930ad', '1c808', '24-March-1964', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('32601', '43ec9', '25-February-1932', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8f1b4', 'f14ee', '24-September-1928', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7c36', 'c16bf', '29-September-1954', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3c69a', '56877', '11-November-1990', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('8279d', '5f6ee', '27-March-1905', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('2b1e4', '2b1e4', '15-February-1969', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9e88e', '32f09', '13-August-1945', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('3392a', '3dad9', '2-March-1952', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('295a0', 'ae01f', '28-January-1962', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('f1799', '4f9d6', '30-October-1985', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('5ef3c', '24746', '14-November-1973', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('124a6', '70026', '31-August-1937', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('6b3ad', '63dfb', '24-December-1999', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dd0b1', 'c6467', '6-December-1936', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('a6723', 'ab9fe', '12-August-1912', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9965c', '3af95', '4-August-2000', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('9e88e', '24746', '14-June-1919', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('75c3b', '0b034', '3-January-1985', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('1a812', '682fc', '28-April-1946', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('f508d', 'dbd1c', '22-November-1997', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ae01f', 'df2b8', '13-February-1973', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('b0cb1', '4d5de', '31-July-1936', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c522f', '144f6', '2-December-1931', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('268de', '05fb5', '2-October-1911', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('c7c36', 'c1de3', '19-August-1927', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('58c8d', '268de', '13-September-1930', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('ab2a2', '6b3ad', '14-January-1923', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('58c8d', '3af95', '26-July-1925', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('32601', '9e88e', '24-September-1939', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('7927f', 'e0564', '20-February-1927', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('d066b', '25c82', '23-April-1960', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('295a0', '3dad9', '9-August-1946', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('dd0b1', 'e9f91', '3-February-1988', 'Would you like to be my friend?');
INSERT INTO FRIENDS values('4d5de', 'c4686', '3-February-1930', 'Would you like to be my friend?');

INSERT INTO GROUPS values(1, 'HSC', 'Hindu Students Council',4);
INSERT INTO GROUPS values(2, 'CSC', 'Pitt Computer Science Club',4);
INSERT INTO GROUPS values(3, 'Pitt Cycling', 'Competitive and casual cycling club',5);
INSERT INTO GROUPS values(4, 'Pitt Triathlon', 'Swim, Bike, Run',5);
INSERT INTO GROUPS values(5, 'Pitt XC', 'Just Run',4);
INSERT INTO GROUPS values(6, 'Pitt Swimming', 'Just Swim',4);
INSERT INTO GROUPS values(7, 'DECA', 'Business club that covers the four sectors of business',4);
INSERT INTO GROUPS values(8, 'ASA', 'Asian Students Alliance',4);
INSERT INTO GROUPS values(9, 'Pitt IEEE', 'Club for electrical/computer engineering students',4);
INSERT INTO GROUPS values(10, 'Pitt Gaming', 'Competitive and casual gaming club',4);

INSERT INTO GROUPMEMBERSHIP values(3,'25c82','Manager');
INSERT INTO GROUPMEMBERSHIP values(2, '25c82','Member');
INSERT INTO GROUPMEMBERSHIP values(1,'b0cb1','Manager');

INSERT INTO PENDINGGROUPMEMBERS values(3,'b0cb1','Please let me join');

INSERT INTO MESSAGES values('1', '1e9d9', 'Sample Text', '1c808', null, '28-November-1945');
INSERT INTO MESSAGES values('2', '9ba78', 'What''s up?', '7960d', null, '18-October-1905');
INSERT INTO MESSAGES values('3', '24746', 'asjdklfjlkdf', '4f9d6', null, '18-August-1979');
INSERT INTO MESSAGES values('4', 'c6467', 'Sample Text', '3c69a', null, '1-July-1930');
INSERT INTO MESSAGES values('5', '32f09', 'Sample Text', '7960d', null, '6-September-1995');
INSERT INTO MESSAGES values('6', '930ad', 'What do you think of Panos?', 'ab2a2', null, '9-May-1948');
INSERT INTO MESSAGES values('7', '1c808', 'Sample Text', '56877', null, '13-May-1926');
INSERT INTO MESSAGES values('8', 'c16bf', 'Hello', '52089', null, '18-March-1980');
INSERT INTO MESSAGES values('9', 'bc4a5', 'You''re a good person', '7bc17', null, '7-July-1933');
INSERT INTO MESSAGES values('10', 'e0564', 'How is CS1555?', 'e9f91', null, '7-March-1919');
INSERT INTO MESSAGES values('11', '43ec9', 'Sample Text', '05fb5', null, '15-January-1985');
INSERT INTO MESSAGES values('12', '32f09', 'Sample Text', '38eec', null, '10-September-1923');
INSERT INTO MESSAGES values('13', '0b034', 'Sample Text', 'a4854', null, '12-November-1941');
INSERT INTO MESSAGES values('14', 'c7c36', 'Sample Text', '5ef3c', null, '18-April-1903');
INSERT INTO MESSAGES values('15', 'bd049', 'I''m feeling good today', '9ba78', null, '3-February-1984');
INSERT INTO MESSAGES values('16', '25c82', 'asjdklfjlkdf', 'df2b8', null, '11-January-1930');
INSERT INTO MESSAGES values('17', 'b0cb1', 'What''s up?', '8f1b4', null, '31-July-1908');
INSERT INTO MESSAGES values('18', 'ae01f', 'What do you think of Panos?', 'c16bf', null, '16-September-1956');
INSERT INTO MESSAGES values('19', 'b1088', 'Bonjour', '682fc', null, '28-August-1981');
INSERT INTO MESSAGES values('20', '05fb5', 'asjdklfjlkdf', '78178', null, '2-May-1941');
INSERT INTO MESSAGES values('21', 'ca2cf', 'asjdklfjlkdf', '9ba78', null, '22-May-1935');
INSERT INTO MESSAGES values('22', '79d7f', 'What do you think of Panos?', 'ceb89', null, '19-June-1970');
INSERT INTO MESSAGES values('23', 'b1088', 'Hello', '3c69a', null, '17-September-1935');
INSERT INTO MESSAGES values('24', '9ba78', 'I''m feeling good today', '9c1ec', null, '29-November-1985');
INSERT INTO MESSAGES values('25', 'fc81c', 'What do you think of Panos?', '5e4b8', null, '20-September-1979');
INSERT INTO MESSAGES values('26', '3dad9', 'What do you think of Panos?', 'e0564', null, '13-October-1928');
INSERT INTO MESSAGES values('27', '9e88e', 'How is CS1555?', '682fc', null, '24-July-1980');
INSERT INTO MESSAGES values('28', '2b1e4', 'Hello', 'bc4a5', null, '28-September-1948');
INSERT INTO MESSAGES values('29', '9ba78', 'What do you think of Panos?', '32f09', null, '5-October-1959');
INSERT INTO MESSAGES values('30', 'c4686', 'Bonjour', '25c82', null, '31-July-1949');
INSERT INTO MESSAGES values('31', 'a04c7', 'You''re a good person', '6b3ad', null, '24-March-1944');
INSERT INTO MESSAGES values('32', '7335c', 'You''re a good person', 'a29bb', null, '26-January-1902');
INSERT INTO MESSAGES values('33', '70026', 'Bonjour', '78178', null, '12-November-1946');
INSERT INTO MESSAGES values('34', 'ea99f', 'You''re a good person', '34677', null, '19-September-1943');
INSERT INTO MESSAGES values('35', '58c8d', 'What''s up?', 'd42f0', null, '29-June-1925');
INSERT INTO MESSAGES values('36', '39aa8', 'What do you think of Panos?', '7927f', null, '15-April-1917');
INSERT INTO MESSAGES values('37', 'fc81c', 'Bonjour', '9c1ec', null, '22-September-1906');
INSERT INTO MESSAGES values('38', 'c1de3', 'How is CS1555?', 'c522f', null, '16-October-1912');
INSERT INTO MESSAGES values('39', 'ee57d', 'What''s up?', 'e742f', null, '11-August-1949');
INSERT INTO MESSAGES values('40', 'fc81c', 'Bonjour', 'ca2cf', null, '8-May-1922');
INSERT INTO MESSAGES values('41', 'c7c36', 'I''m feeling good today', 'c16bf', null, '19-December-1984');
INSERT INTO MESSAGES values('42', 'ceb89', 'Hello', '58c8d', null, '5-May-1970');
INSERT INTO MESSAGES values('43', 'bde19', 'Hello', 'df2b8', null, '27-December-1957');
INSERT INTO MESSAGES values('44', '25c82', 'Bonjour', '56877', null, '5-May-1979');
INSERT INTO MESSAGES values('45', '70026', 'Hello', '9ba78', null, '6-January-1933');
INSERT INTO MESSAGES values('46', 'dd0b1', 'Hello', '75c3b', null, '21-September-1972');
INSERT INTO MESSAGES values('47', '3af95', 'Sample Text', 'df2b8', null, '24-April-1989');
INSERT INTO MESSAGES values('48', '05fb5', 'Bonjour', 'a6723', null, '13-January-1997');
INSERT INTO MESSAGES values('49', 'a4854', 'Hello', 'bde19', null, '6-June-1936');
INSERT INTO MESSAGES values('50', '8279d', 'Sample Text', 'e9f91', null, '14-February-1966');
INSERT INTO MESSAGES values('51', 'd4d42', 'You''re a good person', '0dd06', null, '26-November-1975');
INSERT INTO MESSAGES values('52', 'ae01f', 'Do you know Harvey Specter?', '6b3ad', null, '22-June-1985');
INSERT INTO MESSAGES values('53', 'e2e0c', 'You''re a good person', 'e0564', null, '28-January-1966');
INSERT INTO MESSAGES values('54', 'c16bf', 'Bonjour', 'dbd1c', null, '30-April-1923');
INSERT INTO MESSAGES values('55', '3af95', 'I''m feeling good today', '78178', null, '18-May-1947');
INSERT INTO MESSAGES values('56', '34677', 'How is CS1555?', 'c7c36', null, '5-January-1947');
INSERT INTO MESSAGES values('57', '45bf9', 'Do you know Harvey Specter?', '38eec', null, '7-October-1989');
INSERT INTO MESSAGES values('58', '63dfb', 'Sample Text', '268de', null, '12-May-1996');
INSERT INTO MESSAGES values('59', '144f6', 'What do you think of Panos?', 'e0564', null, '4-October-1924');
INSERT INTO MESSAGES values('60', 'e9f91', 'What do you think of Panos?', '2b1e4', null, '6-April-1931');
INSERT INTO MESSAGES values('61', 'ab2a2', 'asjdklfjlkdf', 'c1de3', null, '20-April-1900');
INSERT INTO MESSAGES values('62', '3c69a', 'You''re a good person', 'ab9fe', null, '11-January-1912');
INSERT INTO MESSAGES values('63', '682fc', 'Do you know Harvey Specter?', '34677', null, '13-September-1948');
INSERT INTO MESSAGES values('64', '70026', 'What''s up?', '295a0', null, '24-November-1918');
INSERT INTO MESSAGES values('65', '3af95', 'Bonjour', 'df2b8', null, '5-January-1957');
INSERT INTO MESSAGES values('66', '682fc', 'asjdklfjlkdf', 'c16bf', null, '6-December-1912');
INSERT INTO MESSAGES values('67', 'ea99f', 'Do you know Harvey Specter?', '5e4b8', null, '25-June-1964');
INSERT INTO MESSAGES values('68', 'bd049', 'Do you know Harvey Specter?', 'd42f0', null, '30-April-1999');
INSERT INTO MESSAGES values('69', '8279d', 'You''re a good person', 'b1088', null, '28-March-1940');
INSERT INTO MESSAGES values('70', 'c4686', 'Do you know Harvey Specter?', 'e742f', null, '31-August-1981');
INSERT INTO MESSAGES values('71', '144f6', 'Do you know Harvey Specter?', 'c6467', null, '10-November-1968');
INSERT INTO MESSAGES values('72', 'fe394', 'How is CS1555?', '4620b', null, '30-July-1970');
INSERT INTO MESSAGES values('73', 'bde19', 'How is CS1555?', '8279d', null, '14-May-1950');
INSERT INTO MESSAGES values('74', '295a0', 'What''s up?', '32601', null, '20-January-1931');
INSERT INTO MESSAGES values('75', '3af95', 'asjdklfjlkdf', '56877', null, '3-January-1979');
INSERT INTO MESSAGES values('76', '25c82', 'What do you think of Panos?', '2307a', null, '5-January-1962');
INSERT INTO MESSAGES values('77', 'd066b', 'Hello', 'dd0b1', null, '21-April-1945');
INSERT INTO MESSAGES values('78', '75c3b', 'Do you know Harvey Specter?', 'bd049', null, '5-October-1942');
INSERT INTO MESSAGES values('79', 'c522f', 'Do you know Harvey Specter?', '79d7f', null, '1-February-1999');
INSERT INTO MESSAGES values('80', '32f09', 'I''m feeling good today', '1c808', null, '28-August-1961');
INSERT INTO MESSAGES values('81', '32601', 'What do you think of Panos?', '58c8d', null, '1-August-1950');
INSERT INTO MESSAGES values('82', '79d7f', 'What do you think of Panos?', 'ea99f', null, '21-August-1963');
INSERT INTO MESSAGES values('83', 'a04c7', 'Bonjour', 'e2e0c', null, '21-March-1966');
INSERT INTO MESSAGES values('84', '3392a', 'Do you know Harvey Specter?', 'c6538', null, '4-April-1906');
INSERT INTO MESSAGES values('85', '39aa8', 'Bonjour', '79d7f', null, '12-June-1911');
INSERT INTO MESSAGES values('86', 'f508d', 'I''m feeling good today', 'ab9fe', null, '22-July-1928');
INSERT INTO MESSAGES values('87', 'dd0b1', 'Hello', '295a0', null, '2-November-1923');
INSERT INTO MESSAGES values('88', '5ef3c', 'What''s up?', 'c6538', null, '16-May-1964');
INSERT INTO MESSAGES values('89', '28328', 'You''re a good person', 'ca2cf', null, '29-July-1965');
INSERT INTO MESSAGES values('90', '34677', 'Bonjour', 'c6467', null, '5-September-1945');
INSERT INTO MESSAGES values('91', '6b3ad', 'Bonjour', '70026', null, '11-October-1952');
INSERT INTO MESSAGES values('92', 'a29bb', 'Do you know Harvey Specter?', '7c983', null, '18-February-1911');
INSERT INTO MESSAGES values('93', '1c808', 'Sample Text', 'fe394', null, '8-May-1954');
INSERT INTO MESSAGES values('94', '38eec', 'Do you know Harvey Specter?', '1a812', null, '15-May-1965');
INSERT INTO MESSAGES values('95', 'a29bb', 'What do you think of Panos?', '9bf36', null, '30-June-1943');
INSERT INTO MESSAGES values('96', '5e4b8', 'Sample Text', 'c6467', null, '28-May-1980');
INSERT INTO MESSAGES values('97', '7c983', 'I''m feeling good today', 'c16bf', null, '15-October-1903');
INSERT INTO MESSAGES values('98', 'fc81c', 'What do you think of Panos?', 'b1088', null, '11-March-1924');
INSERT INTO MESSAGES values('99', '9ba78', 'Do you know Harvey Specter?', '930ad', null, '28-April-1903');
INSERT INTO MESSAGES values('100', '682fc', 'What do you think of Panos?', '682fc', null, '26-July-1950');
INSERT INTO MESSAGES values('101', '3dad9', 'Hello', 'e2e0c', null, '30-July-1938');
INSERT INTO MESSAGES values('102', 'cf978', 'Do you know Harvey Specter?', '32f09', null, '28-September-1931');
INSERT INTO MESSAGES values('103', 'ab2a2', 'I''m feeling good today', '56877', null, '29-August-1925');
INSERT INTO MESSAGES values('104', '3af95', 'What''s up?', '45bf9', null, '10-February-1986');
INSERT INTO MESSAGES values('105', 'bde19', 'Sample Text', '1e9d9', null, '16-October-1917');
INSERT INTO MESSAGES values('106', 'f1799', 'You''re a good person', '8f1b4', null, '16-March-1943');
INSERT INTO MESSAGES values('107', 'dd0b1', 'Bonjour', '52089', null, '26-June-1962');
INSERT INTO MESSAGES values('108', '3392a', 'I''m feeling good today', '124a6', null, '24-September-1954');
INSERT INTO MESSAGES values('109', '70026', 'You''re a good person', 'f14ee', null, '1-April-1996');
INSERT INTO MESSAGES values('110', '7960d', 'Hello', '150c6', null, '27-November-1935');
INSERT INTO MESSAGES values('111', 'ea99f', 'Do you know Harvey Specter?', '150c6', null, '28-July-1994');
INSERT INTO MESSAGES values('112', 'e0564', 'Sample Text', 'c7443', null, '13-September-1975');
INSERT INTO MESSAGES values('113', 'ab2a2', 'Bonjour', '7927f', null, '14-August-1965');
INSERT INTO MESSAGES values('114', '2307a', 'What''s up?', '95d3d', null, '16-April-1980');
INSERT INTO MESSAGES values('115', '150c6', 'What do you think of Panos?', 'd066b', null, '30-April-1968');
INSERT INTO MESSAGES values('116', '7c983', 'Sample Text', '9ba78', null, '12-August-1987');
INSERT INTO MESSAGES values('117', '58c8d', 'asjdklfjlkdf', '63dfb', null, '31-August-1901');
INSERT INTO MESSAGES values('118', 'c7c36', 'What''s up?', '25c82', null, '7-January-1974');
INSERT INTO MESSAGES values('119', '0dd06', 'You''re a good person', '39aa8', null, '22-February-1946');
INSERT INTO MESSAGES values('120', 'fc81c', 'Hello', '78178', null, '2-November-1934');
INSERT INTO MESSAGES values('121', '79d7f', 'Sample Text', '8f1b4', null, '30-April-1950');
INSERT INTO MESSAGES values('122', '9965c', 'What''s up?', '4d5de', null, '3-March-1987');
INSERT INTO MESSAGES values('123', 'ee57d', 'You''re a good person', '2b1e4', null, '11-August-1913');
INSERT INTO MESSAGES values('124', '1e9d9', 'What''s up?', 'e2e0c', null, '7-April-1991');
INSERT INTO MESSAGES values('125', 'c6538', 'Bonjour', 'c6538', null, '10-June-1926');
INSERT INTO MESSAGES values('126', 'f1799', 'You''re a good person', '713e0', null, '24-September-1916');
INSERT INTO MESSAGES values('127', '5e4b8', 'Hello', 'a6723', null, '5-February-1905');
INSERT INTO MESSAGES values('128', 'ab2a2', 'What''s up?', 'c522f', null, '26-February-1911');
INSERT INTO MESSAGES values('129', '0b034', 'You''re a good person', '3dad9', null, '1-May-1975');
INSERT INTO MESSAGES values('130', 'c16bf', 'How is CS1555?', 'c7443', null, '6-November-1979');
INSERT INTO MESSAGES values('131', 'e9f91', 'asjdklfjlkdf', 'd066b', null, '3-June-1977');
INSERT INTO MESSAGES values('132', '8279d', 'You''re a good person', '4f9d6', null, '20-March-1938');
INSERT INTO MESSAGES values('133', '5ef3c', 'What''s up?', '05fb5', null, '17-August-1961');
INSERT INTO MESSAGES values('134', '8279d', 'How is CS1555?', 'a4854', null, '17-July-1966');
INSERT INTO MESSAGES values('135', '4d5de', 'Do you know Harvey Specter?', 'ca2cf', null, '19-September-1904');
INSERT INTO MESSAGES values('136', '7960d', 'asjdklfjlkdf', '7335c', null, '12-March-1923');
INSERT INTO MESSAGES values('137', '79d7f', 'Hello', 'c7443', null, '8-December-1967');
INSERT INTO MESSAGES values('138', 'ea99f', 'Do you know Harvey Specter?', '4f9d6', null, '26-October-1935');
INSERT INTO MESSAGES values('139', '144f6', 'Sample Text', '45bf9', null, '5-September-1901');
INSERT INTO MESSAGES values('140', 'c16bf', 'asjdklfjlkdf', 'a29bb', null, '31-July-1954');
INSERT INTO MESSAGES values('141', 'ab9fe', 'What do you think of Panos?', 'ae01f', null, '27-April-1913');
INSERT INTO MESSAGES values('142', '3c69a', 'Bonjour', 'c6538', null, '12-June-1948');
INSERT INTO MESSAGES values('143', '1c808', 'Do you know Harvey Specter?', 'c6538', null, '29-September-1908');
INSERT INTO MESSAGES values('144', '75c3b', 'Hello', 'ab9fe', null, '15-April-1955');
INSERT INTO MESSAGES values('145', '34677', 'How is CS1555?', 'f508d', null, '21-August-1930');
INSERT INTO MESSAGES values('146', '4f9d6', 'Do you know Harvey Specter?', 'c6538', null, '14-October-1936');
INSERT INTO MESSAGES values('147', '3af95', 'Hello', 'b1088', null, '4-January-1944');
INSERT INTO MESSAGES values('148', 'fe394', 'Sample Text', '34677', null, '27-April-1953');
INSERT INTO MESSAGES values('149', 'ab9fe', 'Do you know Harvey Specter?', '7927f', null, '2-April-1960');
INSERT INTO MESSAGES values('150', '75c3b', 'How is CS1555?', '7960d', null, '29-May-1977');
INSERT INTO MESSAGES values('151', 'b1088', 'asjdklfjlkdf', '4f9d6', null, '29-October-1964');
INSERT INTO MESSAGES values('152', '9ba78', 'Bonjour', 'b0cb1', null, '6-November-1991');
INSERT INTO MESSAGES values('153', 'd42f0', 'Bonjour', 'ab2a2', null, '22-August-1955');
INSERT INTO MESSAGES values('154', '39aa8', 'asjdklfjlkdf', '3392a', null, '26-June-1917');
INSERT INTO MESSAGES values('155', 'c522f', 'Hello', 'df2b8', null, '13-June-1961');
INSERT INTO MESSAGES values('156', '1a812', 'Sample Text', 'c1de3', null, '14-March-1939');
INSERT INTO MESSAGES values('157', '3c69a', 'Bonjour', 'bde19', null, '17-November-1996');
INSERT INTO MESSAGES values('158', 'd4d42', 'Sample Text', 'd42f0', null, '6-February-1949');
INSERT INTO MESSAGES values('159', '79d7f', 'asjdklfjlkdf', '3dad9', null, '18-February-1987');
INSERT INTO MESSAGES values('160', '31430', 'asjdklfjlkdf', '682fc', null, '12-August-1945');
INSERT INTO MESSAGES values('161', '9ba78', 'Bonjour', '25c82', null, '15-February-1966');
INSERT INTO MESSAGES values('162', '3c69a', 'Do you know Harvey Specter?', '7bc17', null, '3-January-1964');
INSERT INTO MESSAGES values('163', '79d7f', 'Sample Text', '0dd06', null, '25-July-1985');
INSERT INTO MESSAGES values('164', '150c6', 'What''s up?', 'ab2a2', null, '26-November-1915');
INSERT INTO MESSAGES values('165', '28328', 'You''re a good person', '4d5de', null, '14-June-1930');
INSERT INTO MESSAGES values('166', '7335c', 'Hello', 'a04c7', null, '21-June-1907');
INSERT INTO MESSAGES values('167', 'fc81c', 'How is CS1555?', '682fc', null, '24-July-1975');
INSERT INTO MESSAGES values('168', '24746', 'Do you know Harvey Specter?', 'a6723', null, '6-April-1922');
INSERT INTO MESSAGES values('169', '28328', 'Hello', 'd42f0', null, '3-October-1927');
INSERT INTO MESSAGES values('170', 'bde19', 'Do you know Harvey Specter?', '144f6', null, '18-March-1918');
INSERT INTO MESSAGES values('171', 'c4686', 'What do you think of Panos?', 'ae01f', null, '18-May-1922');
INSERT INTO MESSAGES values('172', 'bd049', 'I''m feeling good today', 'e0564', null, '6-November-1968');
INSERT INTO MESSAGES values('173', '3392a', 'I''m feeling good today', '28328', null, '26-July-1965');
INSERT INTO MESSAGES values('174', 'e742f', 'Bonjour', 'f508d', null, '10-August-1942');
INSERT INTO MESSAGES values('175', 'e0564', 'asjdklfjlkdf', '31430', null, '23-January-1970');
INSERT INTO MESSAGES values('176', '682fc', 'How is CS1555?', '28328', null, '6-January-1975');
INSERT INTO MESSAGES values('177', '1a812', 'How is CS1555?', 'dd0b1', null, '4-December-1971');
INSERT INTO MESSAGES values('178', '0dd06', 'I''m feeling good today', '5f6ee', null, '30-August-1929');
INSERT INTO MESSAGES values('179', '32601', 'Sample Text', '56877', null, '15-September-1943');
INSERT INTO MESSAGES values('180', '56877', 'Sample Text', '9965c', null, '24-February-1957');
INSERT INTO MESSAGES values('181', '8279d', 'I''m feeling good today', '45bf9', null, '25-September-1941');
INSERT INTO MESSAGES values('182', 'c6538', 'asjdklfjlkdf', 'dbd1c', null, '25-May-1965');
INSERT INTO MESSAGES values('183', '124a6', 'I''m feeling good today', '9bf36', null, '26-July-1928');
INSERT INTO MESSAGES values('184', '39aa8', 'Sample Text', '4d5de', null, '16-August-1901');
INSERT INTO MESSAGES values('185', '7960d', 'Bonjour', 'a6723', null, '22-March-1902');
INSERT INTO MESSAGES values('186', '79d7f', 'Bonjour', '25c82', null, '22-August-1907');
INSERT INTO MESSAGES values('187', '7927f', 'What do you think of Panos?', 'fc81c', null, '2-May-1901');
INSERT INTO MESSAGES values('188', 'e742f', 'How is CS1555?', '43ec9', null, '7-April-1973');
INSERT INTO MESSAGES values('189', 'c16bf', 'What''s up?', '3dad9', null, '24-May-1961');
INSERT INTO MESSAGES values('190', '32601', 'I''m feeling good today', 'a6723', null, '21-June-1904');
INSERT INTO MESSAGES values('191', 'ee57d', 'Do you know Harvey Specter?', 'c1de3', null, '20-January-1953');
INSERT INTO MESSAGES values('192', 'c6467', 'I''m feeling good today', '2307a', null, '23-April-1918');
INSERT INTO MESSAGES values('193', '45bf9', 'I''m feeling good today', 'ae01f', null, '28-August-1918');
INSERT INTO MESSAGES values('194', '7bc17', 'What''s up?', '28328', null, '2-September-1934');
INSERT INTO MESSAGES values('195', '9965c', 'What do you think of Panos?', 'b1088', null, '17-July-1937');
INSERT INTO MESSAGES values('196', '3dad9', 'asjdklfjlkdf', '930ad', null, '2-November-1911');
INSERT INTO MESSAGES values('197', '9e88e', 'I''m feeling good today', '268de', null, '15-December-1967');
INSERT INTO MESSAGES values('198', 'e2e0c', 'What do you think of Panos?', 'fc81c', null, '29-December-1986');
INSERT INTO MESSAGES values('199', '9e88e', 'Hello', 'a4854', null, '10-March-1935');
INSERT INTO MESSAGES values('200', '28328', 'How is CS1555?', '7335c', null, '5-February-1994');
INSERT INTO MESSAGES values('201', '1e9d9', 'I''m feeling good today', 'ceb89', null, '16-February-1900');
INSERT INTO MESSAGES values('202', '5ef3c', 'What do you think of Panos?', 'c7443', null, '22-February-1972');
INSERT INTO MESSAGES values('203', 'a29bb', 'Hello', '75c3b', null, '17-July-1915');
INSERT INTO MESSAGES values('204', '32601', 'You''re a good person', '713e0', null, '14-March-1903');
INSERT INTO MESSAGES values('205', 'ee57d', 'How is CS1555?', '3392a', null, '22-April-1910');
INSERT INTO MESSAGES values('206', '75c3b', 'What do you think of Panos?', 'f1799', null, '13-September-1939');
INSERT INTO MESSAGES values('207', '930ad', 'What''s up?', 'c1de3', null, '12-February-1943');
INSERT INTO MESSAGES values('208', 'bde19', 'How is CS1555?', '63dfb', null, '13-February-1957');
INSERT INTO MESSAGES values('209', '3dad9', 'asjdklfjlkdf', 'fc81c', null, '5-August-1929');
INSERT INTO MESSAGES values('210', 'b1088', 'You''re a good person', 'e9f91', null, '13-June-1923');
INSERT INTO MESSAGES values('211', 'c6467', 'asjdklfjlkdf', 'd4d42', null, '24-March-1943');
INSERT INTO MESSAGES values('212', '75c3b', 'What''s up?', '5ef3c', null, '12-January-1975');
INSERT INTO MESSAGES values('213', 'c4686', 'I''m feeling good today', '38eec', null, '22-April-1972');
INSERT INTO MESSAGES values('214', '9965c', 'You''re a good person', 'e9f91', null, '12-October-1969');
INSERT INTO MESSAGES values('215', 'a04c7', 'Do you know Harvey Specter?', 'bde19', null, '6-November-1938');
INSERT INTO MESSAGES values('216', '295a0', 'asjdklfjlkdf', '4620b', null, '18-April-1947');
INSERT INTO MESSAGES values('217', '713e0', 'Hello', 'bde19', null, '13-July-1965');
INSERT INTO MESSAGES values('218', '144f6', 'Sample Text', 'e9f91', null, '11-March-1994');
INSERT INTO MESSAGES values('219', 'e0564', 'Do you know Harvey Specter?', 'dd0b1', null, '23-October-1923');
INSERT INTO MESSAGES values('220', '7927f', 'What''s up?', '124a6', null, '25-September-1958');
INSERT INTO MESSAGES values('221', '34677', 'Do you know Harvey Specter?', '0dd06', null, '17-October-1973');
INSERT INTO MESSAGES values('222', 'b0cb1', 'Hello', 'a4854', null, '8-January-1977');
INSERT INTO MESSAGES values('223', '8f1b4', 'Hello', 'f1799', null, '7-October-1928');
INSERT INTO MESSAGES values('224', '9e88e', 'How is CS1555?', '9c1ec', null, '20-December-1958');
INSERT INTO MESSAGES values('225', 'f1799', 'What do you think of Panos?', '32f09', null, '1-February-1958');
INSERT INTO MESSAGES values('226', '0b034', 'I''m feeling good today', '144f6', null, '5-December-1911');
INSERT INTO MESSAGES values('227', '4f9d6', 'Hello', 'fe394', null, '27-October-1990');
INSERT INTO MESSAGES values('228', '144f6', 'Hello', '05fb5', null, '15-December-1918');
INSERT INTO MESSAGES values('229', '5e4b8', 'You''re a good person', '8f1b4', null, '18-July-1935');
INSERT INTO MESSAGES values('230', 'cf978', 'asjdklfjlkdf', 'd066b', null, '15-October-1936');
INSERT INTO MESSAGES values('231', '2b1e4', 'You''re a good person', 'df2b8', null, '22-September-1944');
INSERT INTO MESSAGES values('232', 'ea99f', 'asjdklfjlkdf', '78178', null, '25-December-1917');
INSERT INTO MESSAGES values('233', '1e9d9', 'Sample Text', '7927f', null, '2-July-1915');
INSERT INTO MESSAGES values('234', '39aa8', 'What do you think of Panos?', '2b1e4', null, '27-December-1938');
INSERT INTO MESSAGES values('235', 'e9f91', 'I''m feeling good today', '3c69a', null, '20-December-1983');
INSERT INTO MESSAGES values('236', 'f1799', 'Hello', '4620b', null, '19-October-1952');
INSERT INTO MESSAGES values('237', '713e0', 'Hello', 'a04c7', null, '3-October-1931');
INSERT INTO MESSAGES values('238', 'cf978', 'I''m feeling good today', '05fb5', null, '18-April-1904');
INSERT INTO MESSAGES values('239', 'bc4a5', 'What''s up?', 'b0cb1', null, '19-April-1970');
INSERT INTO MESSAGES values('240', 'c7443', 'Hello', 'd4d42', null, '18-August-1957');
INSERT INTO MESSAGES values('241', '45bf9', 'What do you think of Panos?', '0dd06', null, '2-April-1903');
INSERT INTO MESSAGES values('242', '8f1b4', 'Do you know Harvey Specter?', '4620b', null, '24-October-1943');
INSERT INTO MESSAGES values('243', 'bc4a5', 'Hello', '2307a', null, '14-May-1991');
INSERT INTO MESSAGES values('244', 'f14ee', 'What''s up?', '70026', null, '14-March-1994');
INSERT INTO MESSAGES values('245', 'd42f0', 'How is CS1555?', '79d7f', null, '28-June-1988');
INSERT INTO MESSAGES values('246', '05fb5', 'You''re a good person', 'f508d', null, '27-August-1919');
INSERT INTO MESSAGES values('247', 'f14ee', 'What''s up?', '930ad', null, '12-August-1978');
INSERT INTO MESSAGES values('248', 'b0cb1', 'You''re a good person', '9e88e', null, '30-January-1924');
INSERT INTO MESSAGES values('249', 'a29bb', 'Do you know Harvey Specter?', '713e0', null, '6-June-1911');
INSERT INTO MESSAGES values('250', 'a3cd0', 'Do you know Harvey Specter?', '6b3ad', null, '12-May-1972');
INSERT INTO MESSAGES values('251', '2b1e4', 'Hello', '3c69a', null, '6-August-1947');
INSERT INTO MESSAGES values('252', '3c69a', 'Do you know Harvey Specter?', '930ad', null, '22-December-1991');
INSERT INTO MESSAGES values('253', '144f6', 'You''re a good person', '32601', null, '15-August-1983');
INSERT INTO MESSAGES values('254', 'e0564', 'You''re a good person', '39aa8', null, '31-March-1906');
INSERT INTO MESSAGES values('255', '930ad', 'What do you think of Panos?', '4620b', null, '21-April-1929');
INSERT INTO MESSAGES values('256', '31430', 'Do you know Harvey Specter?', '4d5de', null, '16-September-1976');
INSERT INTO MESSAGES values('257', '75c3b', 'How is CS1555?', '930ad', null, '18-November-1941');
INSERT INTO MESSAGES values('258', '5f6ee', 'Do you know Harvey Specter?', '9e88e', null, '29-January-1971');
INSERT INTO MESSAGES values('259', '0b034', 'asjdklfjlkdf', 'c1de3', null, '16-March-1991');
INSERT INTO MESSAGES values('260', 'e0564', 'asjdklfjlkdf', '3392a', null, '31-January-1990');
INSERT INTO MESSAGES values('261', 'ceb89', 'What''s up?', 'cf978', null, '7-October-1982');
INSERT INTO MESSAGES values('262', 'f14ee', 'What''s up?', '56877', null, '26-November-1977');
INSERT INTO MESSAGES values('263', '45bf9', 'I''m feeling good today', 'b0cb1', null, '2-February-1971');
INSERT INTO MESSAGES values('264', 'bd049', 'How is CS1555?', 'dd0b1', null, '10-November-1926');
INSERT INTO MESSAGES values('265', 'a04c7', 'I''m feeling good today', 'a3cd0', null, '26-July-1961');
INSERT INTO MESSAGES values('266', '0dd06', 'Hello', 'ae01f', null, '17-November-1911');
INSERT INTO MESSAGES values('267', 'a04c7', 'Sample Text', '8279d', null, '16-December-1974');
INSERT INTO MESSAGES values('268', 'c4686', 'Hello', '6b3ad', null, '5-July-1988');
INSERT INTO MESSAGES values('269', 'a6723', 'What''s up?', 'e742f', null, '14-September-1979');
INSERT INTO MESSAGES values('270', 'a29bb', 'I''m feeling good today', '70026', null, '14-May-1946');
INSERT INTO MESSAGES values('271', '8279d', 'What do you think of Panos?', 'b0cb1', null, '12-June-1906');
INSERT INTO MESSAGES values('272', 'e9f91', 'How is CS1555?', 'c522f', null, '9-July-1963');
INSERT INTO MESSAGES values('273', '295a0', 'How is CS1555?', '58c8d', null, '24-August-1989');
INSERT INTO MESSAGES values('274', '268de', 'You''re a good person', 'e742f', null, '23-September-1963');
INSERT INTO MESSAGES values('275', '39aa8', 'I''m feeling good today', '05fb5', null, '30-July-1944');
INSERT INTO MESSAGES values('276', 'c7c36', 'asjdklfjlkdf', 'ceb89', null, '11-May-1901');
INSERT INTO MESSAGES values('277', '0b034', 'How is CS1555?', 'ea99f', null, '12-October-1980');
INSERT INTO MESSAGES values('278', 'e2e0c', 'asjdklfjlkdf', '144f6', null, '20-July-1928');
INSERT INTO MESSAGES values('279', '6b3ad', 'asjdklfjlkdf', '5ef3c', null, '27-November-1960');
INSERT INTO MESSAGES values('280', '38eec', 'I''m feeling good today', 'ab2a2', null, '9-June-1926');
INSERT INTO MESSAGES values('281', 'c4686', 'What do you think of Panos?', '43ec9', null, '3-November-1938');
INSERT INTO MESSAGES values('282', '7c983', 'Sample Text', 'c4686', null, '26-March-1983');
INSERT INTO MESSAGES values('283', 'f14ee', 'Hello', '9bf36', null, '26-March-1964');
INSERT INTO MESSAGES values('284', 'c7c36', 'Do you know Harvey Specter?', '70026', null, '14-August-1993');
INSERT INTO MESSAGES values('285', '0b034', 'Sample Text', '7927f', null, '26-October-1976');
INSERT INTO MESSAGES values('286', 'f1799', 'What''s up?', 'c7c36', null, '18-February-1962');
INSERT INTO MESSAGES values('287', 'ceb89', 'I''m feeling good today', '31430', null, '23-June-1913');
INSERT INTO MESSAGES values('288', '7927f', 'asjdklfjlkdf', '2307a', null, '27-February-1957');
INSERT INTO MESSAGES values('289', 'd066b', 'Do you know Harvey Specter?', '3392a', null, '30-June-1989');
INSERT INTO MESSAGES values('290', '7927f', 'asjdklfjlkdf', '1a812', null, '19-October-1933');
INSERT INTO MESSAGES values('291', 'ee57d', 'What do you think of Panos?', '0b034', null, '19-June-1915');
INSERT INTO MESSAGES values('292', 'ceb89', 'asjdklfjlkdf', '124a6', null, '3-February-1924');
INSERT INTO MESSAGES values('293', '25c82', 'I''m feeling good today', 'df2b8', null, '23-December-1975');
INSERT INTO MESSAGES values('294', 'ceb89', 'Bonjour', '0dd06', null, '24-November-1913');
INSERT INTO MESSAGES values('295', 'bd049', 'What''s up?', '78178', null, '21-August-1930');
INSERT INTO MESSAGES values('296', '70026', 'You''re a good person', '4620b', null, '25-June-1999');
INSERT INTO MESSAGES values('297', 'ea99f', 'Bonjour', '56877', null, '24-November-1930');
INSERT INTO MESSAGES values('298', 'a3cd0', 'What''s up?', '34677', null, '11-November-1926');
INSERT INTO MESSAGES values('299', '38eec', 'Sample Text', '1a812', null, '13-December-1928');
INSERT INTO MESSAGES values('300', 'a29bb', 'asjdklfjlkdf', '2b1e4', null, '6-January-1955');

commit;
--duplicate friends trigger
CREATE OR REPLACE TRIGGER DUPL_FRIEND_TRIGGER
BEFORE INSERT ON FRIENDS
FOR EACH ROW
DECLARE cnt number:=0;
BEGIN
	SELECT COUNT(*) INTO cnt FROM FRIENDS WHERE userID1 = :new.userID2 AND userID2 = :new.userID1;
	IF cnt>0 THEN
		raise_application_error(405, 'Duplicate friend detected');
	END IF;
END;
/
--duplicate pendingfriends trigger
CREATE OR REPLACE TRIGGER DUPL_PENDINGFRIEND_TRIGGER
BEFORE INSERT ON PENDINGFRIENDS
FOR EACH ROW
DECLARE cnt number:=0;
BEGIN
	SELECT COUNT(*) INTO cnt FROM PENDINGFRIENDS WHERE toID = :new.fromID AND fromID = :new.toID;
	IF cnt>0 THEN
		raise_application_error(406, 'Duplicate friend request detected');
	END IF;
END;
/
--after inserting into MESSAGES, insert that corresponding entry into MESSAGERECIPIENT
CREATE OR REPLACE TRIGGER MSGRECEIVE_TRIGGER
AFTER INSERT ON MESSAGES
FOR EACH ROW
BEGIN
	IF :new.toUserID IS NOT NULL THEN
		INSERT INTO MESSAGERECIPIENT VALUES(:new.msgID,:new.toUserID);
	ELSIF :new.toGroupID IS NOT NULL THEN
		INSERT INTO MESSAGERECIPIENT(msgID, userID)
		SELECT :new.msgID, userID FROM GROUPMEMBERSHIP
		WHERE gID = :new.toGroupID;
	END IF;
END;
/
--after inserting into FRIENDS, delete that corresponding entry from PENDINGFRIENDS
CREATE OR REPLACE TRIGGER PENDINGFRIENDS_TRIGGER
AFTER INSERT ON FRIENDS
FOR EACH ROW
BEGIN
	DELETE FROM PENDINGFRIENDS
	WHERE (:new.userID1 = fromID AND :new.userID2 = toID)
		OR (:new.userID1 = toID AND :new.userID2 = fromID);
END;
/

--after inserting into GROUPMEMBERSHIP, delete that corresponding entry from PENDINGGROUPMEMBERS
CREATE OR REPLACE TRIGGER PENDINGGROUPMEMBERS_TRIGGER
AFTER INSERT ON GROUPMEMBERSHIP
FOR EACH ROW
BEGIN
	DELETE FROM PENDINGGROUPMEMBERS
	WHERE (:new.gID = gID AND :new.userID = userID);
END;
/

--checks a group's size limit before adding a new entry to PENDINGGROUPMEMBERS
CREATE OR REPLACE TRIGGER INIT_ADDGROUP_TRIGGER
BEFORE INSERT ON PENDINGGROUPMEMBERS
FOR EACH ROW
DECLARE 
groupSize integer:=0;
groupLimit integer:=0;
BEGIN
	SELECT COUNT(*) INTO groupSize FROM GROUPS WHERE :new.gID = gID;
	SELECT lim INTO groupLimit FROM GROUPS WHERE :new.gID = gID;
	IF groupSize >= groupLimit THEN
		raise_application_error(404, 'Group size limit reached, unable to insert into PENDINGGROUPMEMBERS');
	END IF;
END;
/
--delete messages that have both the fromID and toUserID deleted as a result of profile deletions
CREATE OR REPLACE TRIGGER MSG_HANDLING_TRIGGER
AFTER DELETE ON PROFILE
BEGIN
	DELETE FROM MESSAGES WHERE msgID IN 
		(SELECT msgID FROM MESSAGES WHERE fromID = null AND toUserID = null AND toGroupID = null);
END;
/

CREATE OR REPLACE TRIGGER DELETE_USER_TRIGGER
AFTER DELETE ON PROFILE
FOR EACH ROW
BEGIN
	DELETE FROM FRIENDS WHERE userID1 = :old.userID OR userID2 = :old.userID;
	DELETE FROM PENDINGFRIENDS WHERE fromID = :old.userID OR toID = :old.userID;
	UPDATE MESSAGES SET fromID = null WHERE fromID = :old.userID;
	UPDATE MESSAGES SET toUserID = null WHERE toUserID = :old.userID;
	DELETE FROM MESSAGES WHERE fromID = null AND toUserID = null;
	DELETE FROM MESSAGERECIPIENT WHERE userID = :old.userID;
	DELETE FROM GROUPMEMBERSHIP WHERE userID = :old.userID;
	DELETE FROM PENDINGGROUPMEMBERS WHERE userID = :old.userID;
END;
/

--SELECT * FROM SYS.USER_ERRORS WHERE NAME = 'DELETE_USER_TRIGGER' AND TYPE = 'TRIGGER';