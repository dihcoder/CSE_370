CREATE DATABASE IF NOT EXISTS club_collab;
USE club_collab;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Earns;
DROP TABLE IF EXISTS Volunteers_In;
DROP TABLE IF EXISTS Resource_Booking;
DROP TABLE IF EXISTS Collaboration;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Phone_Numbers;
DROP TABLE IF EXISTS Contact_Emails;
DROP TABLE IF EXISTS Maintenance_Log;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Club_Executive;
DROP TABLE IF EXISTS General_Student;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS Badge;
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================
-- 1. BASE ENTITIES
-- =====================================

CREATE TABLE Club (
    Club_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(100),
    Office_Room VARCHAR(50)
);

CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    -- Composite Attribute: Address
    Street VARCHAR(200),
    City VARCHAR(50),
    Zip VARCHAR(10)
);

CREATE TABLE Badge (
    Badge_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Tier VARCHAR(50),
    Description TEXT,
    Hrs_Required DECIMAL(5, 2)
);

-- =====================================
-- 2. MULTIVALUED ATTRIBUTES
-- =====================================

CREATE TABLE Contact_Emails (
    Club_ID INT NOT NULL,
    Email VARCHAR(100) NOT NULL,
    PRIMARY KEY (Club_ID, Email),
    FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID) ON DELETE CASCADE
);

CREATE TABLE Phone_Numbers (
    Student_ID INT NOT NULL,
    Phone_Number VARCHAR(20) NOT NULL,
    PRIMARY KEY (Student_ID, Phone_Number),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE
);

-- =====================================
-- 3. ISA HIERARCHY (STUDENT SPECIALIZATIONS)
-- =====================================

CREATE TABLE General_Student (
    Student_ID INT PRIMARY KEY,
    Year_of_Study INT,
    Major VARCHAR(100),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE
);

CREATE TABLE Club_Executive (
    Student_ID INT PRIMARY KEY,
    Position VARCHAR(50),
    Term_Start DATE,
    Term_End DATE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE
);

-- =====================================
-- 4. 1:N RELATIONSHIPS (owns & organizes)
-- =====================================

CREATE TABLE Equipment (
    Equip_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    Status VARCHAR(50),
    Purchase_Date DATE,
    -- 1:N Relationship 'owns' (Club owns Equipment)
    Club_ID INT, 
    FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID) ON DELETE SET NULL
);

CREATE TABLE Event (
    Event_ID INT PRIMARY KEY,
    Title VARCHAR(200),
    Date DATE,
    Venue VARCHAR(200),
    Description TEXT,
    -- 1:N Relationship 'organizes' (Club organizes Event)
    Club_ID INT, 
    FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID) ON DELETE SET NULL
);

-- =====================================
-- 5. WEAK ENTITY (has_logs)
-- =====================================

CREATE TABLE Maintenance_Log (
    Equip_ID INT NOT NULL,
    Log_ID INT NOT NULL,
    Date DATE,
    Cost DECIMAL(10, 2),
    Description TEXT,
    PRIMARY KEY (Equip_ID, Log_ID),
    FOREIGN KEY (Equip_ID) REFERENCES Equipment(Equip_ID) ON DELETE CASCADE
);

-- =====================================
-- 6. M:N RELATIONSHIPS (Junction Tables)
-- =====================================

CREATE TABLE Membership (
    Club_ID INT NOT NULL,
    Student_ID INT NOT NULL,
    Role VARCHAR(50),
    Join_Date DATE,
    PRIMARY KEY (Club_ID, Student_ID),
    FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE
);

CREATE TABLE Collaboration (
    Club_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Contribution_Type VARCHAR(100),
    PRIMARY KEY (Club_ID, Event_ID),
    FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID) ON DELETE CASCADE,
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID) ON DELETE CASCADE
);

CREATE TABLE Resource_Booking (
    Equip_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Borrow_Time DATETIME,
    Return_Time DATETIME,
    Status VARCHAR(50),
    PRIMARY KEY (Equip_ID, Event_ID),
    FOREIGN KEY (Equip_ID) REFERENCES Equipment(Equip_ID) ON DELETE CASCADE,
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID) ON DELETE CASCADE
);

CREATE TABLE Volunteers_In (
    Student_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Hours_Worked DECIMAL(5, 2),
    Role VARCHAR(100),
    Verification VARCHAR(50),
    Verifier VARCHAR(100),
    PRIMARY KEY (Student_ID, Event_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID) ON DELETE CASCADE
);

CREATE TABLE Earns (
    Student_ID INT NOT NULL,
    Badge_ID INT NOT NULL,
    Earned_Date DATE,
    Total_Hours DECIMAL(6, 2),
    PRIMARY KEY (Student_ID, Badge_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Badge_ID) REFERENCES Badge(Badge_ID) ON DELETE CASCADE
);
