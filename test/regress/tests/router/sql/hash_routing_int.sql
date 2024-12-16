\c spqr-console

CREATE DISTRIBUTION ds1 COLUMN TYPES INT hash;

CREATE KEY RANGE krid1 FROM 0 ROUTE TO sh1 FOR DISTRIBUTION ds1;
CREATE KEY RANGE krid2 FROM 2147483648 ROUTE TO sh2 FOR DISTRIBUTION ds1;

-- the set of all unsigned 32-bit integers (0 to 4294967295)
ALTER DISTRIBUTION ds1 ATTACH RELATION xx DISTRIBUTION KEY col1 HASH FUNCTION MURMUR;

\c regress

DROP TABLE IF EXISTS xx;
CREATE TABLE xx (col1 INT);

INSERT INTO xx (col1) VALUES (1);
INSERT INTO xx (col1) VALUES (2);
INSERT INTO xx (col1) VALUES (3);
INSERT INTO xx (col1) VALUES (4);
INSERT INTO xx (col1) VALUES (5);
INSERT INTO xx (col1) VALUES (6);
INSERT INTO xx (col1) VALUES (7);
INSERT INTO xx (col1) VALUES (8);
INSERT INTO xx (col1) VALUES (9);
INSERT INTO xx (col1) VALUES (10);
INSERT INTO xx (col1) VALUES (11);

INSERT INTO xx (col1) VALUES (65535);
INSERT INTO xx (col1) VALUES (65536);
INSERT INTO xx (col1) VALUES (65537);
INSERT INTO xx (col1) VALUES (65538);
INSERT INTO xx (col1) VALUES (65539);

INSERT INTO xx (col1) VALUES (2147483644);
INSERT INTO xx (col1) VALUES (2147483645);
INSERT INTO xx (col1) VALUES (2147483646);
INSERT INTO xx (col1) VALUES (2147483647);

SELECT col1 FROM xx ORDER BY col1 /* __spqr__execute_on: sh1 */;
SELECT col1 FROM xx ORDER BY col1 /* __spqr__execute_on: sh2 */;

COPY xx (col1) FROM STDIN /* __spqr__allow_multishard: true */ ;
1
2
3
4
5
6
7
8
9
10
11
65535
65536
65537
65538
65539
2147483644
2147483645
2147483646
2147483647
\.

SELECT col1 FROM xx ORDER BY col1 /* __spqr__execute_on: sh1 */;
SELECT col1 FROM xx ORDER BY col1 /* __spqr__execute_on: sh2 */;

SELECT * FROM xx WHERE col1 = 1;
SELECT * FROM xx WHERE col1 = 2;
SELECT * FROM xx WHERE col1 = 3;
SELECT * FROM xx WHERE col1 = 4;
SELECT * FROM xx WHERE col1 = 5;
SELECT * FROM xx WHERE col1 = 6;
SELECT * FROM xx WHERE col1 = 7;
SELECT * FROM xx WHERE col1 = 8;
SELECT * FROM xx WHERE col1 = 9;
SELECT * FROM xx WHERE col1 = 10;
SELECT * FROM xx WHERE col1 = 11;

SELECT * FROM xx WHERE col1 = 65535;
SELECT * FROM xx WHERE col1 = 65536;
SELECT * FROM xx WHERE col1 = 65537;
SELECT * FROM xx WHERE col1 = 65538;
SELECT * FROM xx WHERE col1 = 65539;

SELECT * FROM xx WHERE col1 = 2147483644;
SELECT * FROM xx WHERE col1 = 2147483645;
SELECT * FROM xx WHERE col1 = 2147483646;
SELECT * FROM xx WHERE col1 = 2147483647;

DROP TABLE xx;

\c spqr-console
DROP DISTRIBUTION ALL CASCADE;
DROP KEY RANGE ALL;
