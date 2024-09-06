-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Initiaization
DROP TABLE IF EXISTS "equipments";
DROP TABLE IF EXISTS "sensors";
DROP TABLE IF EXISTS "sensor_readings";
DROP TABLE IF EXISTS "maintenance_logs";
DROP TABLE IF EXISTS "spare_parts";
DROP VIEW IF EXISTS "preventive_maintenance";
DROP VIEW IF EXISTS "predictive_maintenance";
DROP VIEW IF EXISTS "corrective_maintenance";

--** CREATE TABLE **--
--// Equipment table contains all information on equipments //--
CREATE TABLE "equipments" (
    "id" INT,
    "type" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "model_number" TEXT NOT NULL,
    "serial_number" TEXT NOT NULL,
    "installation_date" DATETIME NOT NULL,
    "last_maintenance_date" DATETIME NOT NULL,
    PRIMARY KEY("id")
);

--// Sensors table contains all sensor information //--
CREATE TABLE "sensors" (
    "id" INT,
    "type" TEXT NOT NULL,
    "equipment_id" INT NOT NULL,
    "location" TEXT NOT NULL,
    "calibration_date" DATETIME NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("equipment_id") REFERENCES "equipments"("id")
);

--// Sensor readings log //--
CREATE TABLE "sensor_readings" (
    "id" INT,
    "sensor_id" INT NOT NULL UNIQUE,
    "timestamp" DATETIME NOT NULL,
    "value" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("sensor_id") REFERENCES "sensors"("id")
);

--// Maintenance log that recorded by man when perform maintenance //--
CREATE TABLE "maintenance_logs" (
    "id" INT,
    "equipment_id" INT NOT NULL UNIQUE,
    "maintenance_type" TEXT NOT NULL CHECK("maintenance_type" IN("Preventive", "Corrective", "Predictive")),
    "start_date" DATETIME NOT NULL,
    "end_date" DATETIME NOT NULL,
    "performed_by" TEXT NOT NULL,
    "notes" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("equipment_id") REFERENCES "equipments"("id")
);

--// Inventory table //--
CREATE TABLE "spare_parts" (
    "id" INT,
    "name" TEXT NOT NULL,
    "serial_number" NUMERIC,
    "equipment_id" TEXT NOT NULL,
    "quantity" INT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("equipment_id") REFERENCES "equipments"("id")
);

--** INSERT TABLE **--
INSERT INTO "equipments" ("id", "type", "name", "manufacturer", "model_number", "serial_number", "installation_date", "last_maintenance_date")
VALUES
('1', 'Machine Tool', 'Machine A','Acme Corporation', 'MT-1234', 'SN123', '2023-01-01', '2024-07-15'),
('2', 'Conveyor Belt', 'Machine B', 'Beta Industries', 'CB-5678', 'SN1234','2022-05-10', '2024-06-20'),
('3', 'Bearing', 'Machine C', 'Citaa Company', 'PL-4238', 'SN01923','2022-05-10', '2024-06-20');

INSERT INTO "sensors" ("id", "type", "equipment_id", "location", "calibration_date")
VALUES
('1', 'Temperature', '1', 'Bearing 1', '2024-05-20'),
('2', 'Vibration', '2', 'Motor', '2024-04-10'),
('3', 'Pressure', '3', 'Belt Tensioner', '2023-12-15');

INSERT INTO "sensor_readings" ("id", "sensor_id", "timestamp", "value")
VALUES
('001', '1', '2024-08-23 10:00:00', 45.2),
('002', '2', '2024-08-23 10:05:00', 0.2),
('003', '3', '2024-08-23 10:10:00', 15.5);

INSERT INTO "maintenance_logs" ("id", "equipment_id", "maintenance_type", "start_date", "end_date", "performed_by", "notes")
VALUES
('001', '1', 'Preventive', '2024-07-15', '2024-07-16', 'John Doe', 'Replaced oil filter and checked belts.'),
('002', '2', 'Corrective', '2024-06-20', '2024-06-21', 'Jane Smith', 'Repaired motor belt.'),
('003', '3', 'Predictive', '2024-04-23', '2024-5-21', 'Carter Lken', 'Apply lubrication');

INSERT INTO "spare_parts" ("id", "serial_number", "name", "equipment_id", "quantity")
VALUES
('001', 'SN23904', 'Oil Filter', '1', 10),
('002', 'SN23904','Belt', '2', 5),
('003', 'SN19483','Motor', '3', 2);

--** CREATE INDEX **--
CREATE INDEX "equipment_search" ON "equipments" ("name");
CREATE INDEX "sparepart_search" ON "spare_parts" ("name");
CREATE INDEX "last_maintenance_search" ON "maintenance_logs" ("start_date", "end_date");

--** CREATE VIEW **--
--// Preventive maintennace activities //--
CREATE VIEW "preventive_maintenance" AS
SELECT * FROM "maintenance_logs"
WHERE "maintenance_type" = 'Preventive';

--// Predictive maintennace activities //--
CREATE VIEW "predictive_maintenance" AS
SELECT * FROM "maintenance_logs"
WHERE "maintenance_type" = 'Predictive';

--// Corrective maintennace activities //--
CREATE VIEW "corrective_maintenance" AS
SELECT * FROM "maintenance_logs"
WHERE "maintenance_type" = 'Corrective';
