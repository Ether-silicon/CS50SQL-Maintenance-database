-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

--Find all the machine list in the manufacturing plant
SELECT * FROM equipments;

--Find the sensor that locate in machine model number starts with MT-
SELECT * FROM sensors WHERE equipment_id = (
    SELECT id FROM equipments WHERE model_number LIKE 'MT%'
);

--Find sensor type and their reading on which machine
SELECT "s"."type", "e"."name", "value" FROM "sensors" "s"
JOIN "equipments" "e" ON "e"."id" = "s"."equipment_id"
JOIN "sensor_readings" "r" ON "r"."sensor_id" = "s"."id";

--Find spare part that is replaced in machine A
SELECT * FROM spare_parts WHERE equipment_id = (
    SELECT id FROM equipments WHERE name = 'Machine A'
);

--Select preventive maintenance view
SELECT * FROM preventive_maintenance;

--Select predictive maintenance view
SELECT * FROM predictive_maintenance;

--Select corrective maintenance view
SELECT * FROM corrective_maintenance;

--Add a new machine
INSERT INTO "equipments" ("id", "type", "name", "manufacturer", "model_number", "serial_number", "installation_date", "last_maintenance_date")
VALUES ('4', 'Shaft', 'Machine D', 'Delta Company', 'ASJN-3471', 'SN1237','2024-07-30', '2024-08-23');

-- Add a new sensor
INSERT INTO "sensors" ("id", "type", "equipment_id", "location", "calibration_date")
VALUES ('4', 'Pressure', '4', 'Printer', '2024-08-23');
