create database bbss;  
use bbss; 

create table mission(
	id 				int not null primary key,
	startdatetime 	datetime, #not null,
	enddatetime 	datetime, #not null,
	description 	varchar(100) #not null unique
);

create table agent(
	eid					int not null primary key,
	securityclearance	int, #not null,
	ispilot				boolean, #not null,
	isoperator			boolean #not null
);

create table pilot(
	eid 			int not null primary key,
	pilotlicense	char(8), #not null unique,
	expirydate		date, #not null,
	#constraint pilot_pk primary key (EID),
	constraint pilot_fk foreign key (eid) references agent(eid)
);

create table operator (
	eid					int not null primary key,
	oplicense			char(8), #not null,
	expirydate 			date, #not null,
	opcertificationid	char(8),
	constraint operator_fk foreign key (eid) references agent(eid)
);

create table dronegroup(
	id				int not null,
	operatoreid		int not null,
	piloteid 		int not null,
    constraint dronegroup_pk primary key (id, operatoreid, piloteid),
	constraint dronegroup_fk1 foreign key (id) references mission(id),
	constraint dronegroup_fk2 foreign key (operatoreid) references operator(eid),
	constraint dronegroup_fk3 foreign key (piloteid) references pilot(eid)
);

create table drone(
	id			int not null primary key,
	Dronemodel	varchar(50) not null
);

create table grpdrones(
	id				int not null,
	operatoreid		int not null,
	piloteid		int not null,
	droneid			int not null,
    constraint grpdrones_pk primary key (id, operatoreid, piloteid, droneid),
	constraint grpdrones_fk1 foreign key (id, operatoreid, piloteid) references dronegroup(id, operatoreid, piloteid),
	constraint grpdrones_fk2 foreign key (droneid) references drone(id)
);

create table dronecamera(
	id			int not null,
	number		int not null,
	cameramodel varchar(50), #not null unique,
    constraint dronecamera_pk primary key (id, number),
	constraint dronecamera_fk foreign key (id) references drone(id)
);

create table camera(
	serialno	int not null primary key,
	model		varchar(15), #not null,
	status		varchar(15), #not null,
	isip68		boolean #not null
);

create table tracker(
	id				int primary key not null ,
	disposedate		date, #not null,
	assigndate		date, #not null,
	droneid			int, #not null,
	camerasn 		int, #not null,
	constraint tracker_fk1 foreign key (droneid) references drone(id),
	constraint tracker_fk2 foreign key (camerasn) references camera(serialno)
);

create table record(
	trackid		int not null ,
	datetime	datetime not null,
	latitude	double, #not null,
	longitude	double, #not null,
	altitude	double, #not null,
    constraint record_pk primary key (trackid, datetime),
	constraint record_fk foreign key (trackid) references tracker(id)
);

create table nearby(
	id			int not null,
	trackid		int not null,
	datetime	datetime not null,
    constraint nearby_pk primary key (id, trackid, datetime),
	constraint nearby_fk1 foreign key (id) references tracker(id),
	constraint nearby_fk2 foreign key (trackid, datetime) references RECORD(trackid, datetime)
);

create table photo(
	id			int primary key not null,
	datetime	datetime, #not null,
	droneid		int, #not null,
	dronecamnum int, #not null,
	camerasn 	int, #not null,
	constraint photo_fk1 foreign key (droneid, dronecamnum) references dronecamera(id, number),
	constraint photo_fk2 foreign key (camerasn) references camera(serialno)
);

create table poi(
	id		int primary key not null ,
	name	varchar(100) #not null
);

create table photopoi(
	photoid		int not null,
	poiid		int not null,
	confidence	double, #not null,
    constraint photopoi_pk primary key (photoid, poiid),
	constraint photopoi_fk1 foreign key (photoid) references photo(id),
	constraint photopoi_fk2 foreign key (poiid) references poi(id)
);

create table poirelation(
	poi1 		int not null,
	poi2 		int not null,
	description varchar(100) not null,
    constraint poirelation_pk primary key (poi1, poi2),
	constraint poirelation_fk1 foreign key (poi1) references poi(id),
	constraint poirelation_fk2 foreign key (poi2) references poi(id)
);

show variables like "secure_file_priv"; #C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
#LOAD DATA INFILE "C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\data\mission.txt" INTO TABLE mission FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/mission.txt" into table mission fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/agent.txt" into table agent fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/pilot.txt" into table pilot fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/operator.txt" into table operator fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/dronegroup.txt" into table dronegroup fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/drone.txt" into table drone fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/grpdrones.txt" into table grpdrones fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/dronecamera.txt" into table dronecamera fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/camera.txt" into table camera fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/tracker.txt" into table tracker fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/record.txt" into table record fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/nearby.txt" into table nearby fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/photo.txt" into table photo fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/poi.txt" into table poi fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/photopoi.txt" into table photopoi fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/poiRelation.txt" into table poirelation fields terminated by '\t' lines terminated by '\r\n' ignore 1 lines;

select * from  grpdrones;

insert into grpdrones value (1,3,1,1);

DROP TRIGGER IF EXISTS before_insert_GrpDrones;
DELIMITER $$
CREATE TRIGGER before_insert_GrpDrones 
BEFORE INSERT ON GRPDRONES FOR EACH ROW
BEGIN
    DECLARE X INT;
    DECLARE msgTxt VARCHAR(256); 
    
    select t3.mission_id into x
    FROM (
        SELECT 
            t1.mission_id
        FROM (
            SELECT 
                d.droneid, 
                m.id AS mission_id, 
                m.startdatetime AS mission_start, 
                m.enddatetime AS mission_end
            FROM 
                GRPDRONES d
            INNER JOIN 
                mission m ON d.id = m.id
            WHERE  
                m.id = NEW.id
        ) AS t1
        INNER JOIN (
            SELECT 
                d.droneid, 
                m.id AS mission_id, 
                m.startdatetime AS mission_start, 
                m.enddatetime AS mission_end
            FROM 
                GRPDRONES d
            INNER JOIN 
                mission m ON d.id = m.id
            WHERE  
                m.id = NEW.id
        ) AS t2 ON t1.droneid = t2.droneid AND t1.mission_id > t2.mission_id
        WHERE 
            (
                (t1.mission_start BETWEEN t2.mission_start AND t2.mission_end)
                OR (t1.mission_end BETWEEN t2.mission_start AND t2.mission_end)
                OR (t1.mission_start <= t2.mission_start AND t1.mission_end >= t2.mission_end)
                OR (t1.mission_start >= t2.mission_start AND t1.mission_end <= t2.mission_end)
            )
    ) AS t3;
    
		if x is not null then
         SET msgTxt = CONCAT('Trigger Error: Drone is involved in Mission ID ', X, ' with overlapping mission dates');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msgTxt;
    END IF;
END$$

DELIMITER ;











