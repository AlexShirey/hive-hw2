--create database

CREATE DATABASE IF NOT EXISTS ${db}
	COMMENT "The database for hive_hw1, hive_hw2";

USE ${db};

--create external table carrier_ext to get the data from, textformat, using OpenCSVSerde to remove quotes
CREATE EXTERNAL TABLE IF NOT EXISTS carrier_ext
	(code STRING, description STRING)  	
	ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
	WITH SERDEPROPERTIES ("separatorChar" = ",", "quoteChar"     = "\"")    
	STORED AS TEXTFILE
	LOCATION "${carrier_data_dir}"
	TBLPROPERTIES ('creator'="${creator}", 'date'="${date}");

--create external table airport_ext to get the data from, textformat, using OpenCSVSerde to remove quotes
CREATE EXTERNAL TABLE IF NOT EXISTS airport_ext
	(code CHAR(5), name STRING, city STRING, state CHAR(4), country STRING, lat DOUBLE, long DOUBLE)  	
	ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
	WITH SERDEPROPERTIES ("separatorChar" = ",", "quoteChar"     = "\"")     
	STORED AS TEXTFILE
	LOCATION "${airport_data_dir}"
	TBLPROPERTIES ('creator'="${creator}", 'date'="${date}");

--create external table flight_ext to get the data from, textformat
CREATE EXTERNAL TABLE IF NOT EXISTS flight_ext
	(Year SMALLINT, Month TINYINT, DayofMonth TINYINT, DayOfWeek TINYINT, DepTime SMALLINT, CRSDepTime SMALLINT, rrTime SMALLINT, CRSArrTime SMALLINT,
	UniqueCarrier STRING, FlightNum INT, TailNum STRING, ActualElapsedTime SMALLINT,CRSElapsedTime SMALLINT,AirTime SMALLINT,ArrDelay SMALLINT,
	DepDelay SMALLINT, Origin CHAR(3), Dest CHAR(3), Distance SMALLINT, TaxiIn SMALLINT, TaxiOut SMALLINT, Cancelled CHAR(1), CancellationCode CHAR(1),
	Diverted CHAR(1), CarrierDelay SMALLINT, WeatherDelay SMALLINT, NASDelay SMALLINT, SecurityDelay SMALLINT, LateAircraftDelay SMALLINT) 
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	STORED AS TEXTFILE
	LOCATION "${flight_data_dir}"
	TBLPROPERTIES ('creator'="${creator}", 'date'="${date}");

--create a working table carrier that will be used in all queries, orc format
CREATE TABLE IF NOT EXISTS carrier
	(code STRING, description STRING)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	STORED AS ORC 
	TBLPROPERTIES ('creator'="${creator}", 'date'="${date}");

--create a working table airport that will be used in all queries, orc format
CREATE TABLE IF NOT EXISTS airport
	(code CHAR(3), name STRING, city STRING, state CHAR(2), country STRING, lat DOUBLE, long DOUBLE)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	STORED AS ORC 
	TBLPROPERTIES ('creator'="${creator}", 'date'="${date}");

--create a working table carrier that will be used in all queries, orc format
CREATE TABLE IF NOT EXISTS flight
	(Year SMALLINT, Month TINYINT, DayofMonth TINYINT, DayOfWeek TINYINT, DepTime SMALLINT, CRSDepTime SMALLINT, rrTime SMALLINT, CRSArrTime SMALLINT,
	UniqueCarrier STRING, FlightNum INT, TailNum STRING, ActualElapsedTime SMALLINT,CRSElapsedTime SMALLINT,AirTime SMALLINT,ArrDelay SMALLINT,
	DepDelay SMALLINT, Origin CHAR(3), Dest CHAR(3), Distance SMALLINT, TaxiIn SMALLINT, TaxiOut SMALLINT, Cancelled CHAR(1), CancellationCode CHAR(1),
	Diverted CHAR(1), CarrierDelay SMALLINT, WeatherDelay SMALLINT, NASDelay SMALLINT, SecurityDelay SMALLINT, LateAircraftDelay SMALLINT) 
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	STORED AS ORC 
	TBLPROPERTIES ('creator'="${creator}", 'date'="${date}");

--fill tables with data
INSERT OVERWRITE TABLE carrier SELECT * FROM carrier_ext;
INSERT OVERWRITE TABLE airport SELECT * FROM airport_ext;
INSERT OVERWRITE TABLE flight SELECT * FROM flight_ext;
