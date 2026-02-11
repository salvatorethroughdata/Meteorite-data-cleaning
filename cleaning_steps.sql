CREATE TABLE IF NOT EXISTS "meteorites_temp"(
    "name" TEXT,
    "id" INTEGER,
    "nametype" TEXT,
    "class" TEXT,
    "mass" DECIMAL,
    "discovery" TEXT,
    "year" INTEGER,
    "latitude" DECIMAL,
    "longitude" DECIMAL,
    PRIMARY KEY("id")
);

.import --csv --skip 1 meteorites.csv meteorites_temp

UPDATE "meteorites_temp"
SET "mass" = NULL
WHERE "mass" = '';

UPDATE "meteorites_temp"
SET "year" = NULL
WHERE "year" = '';

UPDATE "meteorites_temp"
SET "latitude" = NULL
WHERE "latitude" = '';

UPDATE "meteorites_temp"
SET "longitude" = NULL
WHERE "longitude" = '';

UPDATE "meteorites_temp"
SET "mass" = ROUND("mass",2)
WHERE "mass" IS NOT NULL;

UPDATE "meteorites_temp"
SET "latitude" = ROUND("latitude",2)
WHERE "latitude" IS NOT NULL;

UPDATE "meteorites_temp"
SET "longitude" = ROUND("longitude",2)
WHERE "longitude" IS NOT NULL;

DELETE FROM "meteorites_temp"
WHERE "nametype" = 'Relict';

CREATE TABLE "meteorites_temp2" AS
SELECT *
FROM "meteorites_temp"
ORDER BY "year" ASC, "name" ASC;

ALTER TABLE "meteorites_temp2"
ADD "new_id" INTEGER;

WITH "ranked" AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY "year" ASC, "name" ASC) AS rn,
        rowid
    FROM "meteorites_temp2"
)
UPDATE "meteorites_temp2"
SET "new_id" = (SELECT rn FROM "ranked" WHERE "ranked".rowid = "meteorites_temp2".rowid);

ALTER TABLE "meteorites_temp2"
DROP COLUMN "id";

ALTER TABLE "meteorites_temp2"
RENAME COLUMN "new_id" TO "id";

CREATE TABLE IF NOT EXISTS "meteorites"(
    "name" TEXT,
    "id" INTEGER,
    "class" TEXT,
    "mass" DECIMAL,
    "discovery" TEXT,
    "year" INTEGER,
    "lat" DECIMAL,
    "long" DECIMAL,
    PRIMARY KEY("id")
);

INSERT INTO "meteorites" ("name","id","class","mass","discovery","year","lat","long")
SELECT "name","id","class","mass","discovery","year","latitude","longitude"
FROM "meteorites_temp2";

DROP TABLE "meteorites_temp";
DROP TABLE "meteorites_temp2";