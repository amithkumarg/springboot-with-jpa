/**
 Author: AmithKumar
 Model : lnevent
**/

DROP SCHEMA IF EXISTS lnevent;

CREATE SCHEMA lnevent;
USE lnevent;

/* Table: Event */
CREATE TABLE event (
	event_id		INT NOT NULL,
    event_code		VARCHAR(20) NOT NULL,
    event_name		VARCHAR(100) NOT NULL,
   	CONSTRAINT event_id_pk PRIMARY KEY(event_id),
   	CONSTRAINT event_code_unique UNIQUE(event_code),
   	CONSTRAINT event_name_unique UNIQUE(event_name)
);

/* Table: Seat */
CREATE TABLE seat (
  seat_id		INT NOT NULL,
  venue_code	VARCHAR(20) NOT NULL,
  seat_code		CHAR(3) NOT NULL,
  aisle			BOOLEAN,
  seat_type		VARCHAR(10) NOT NULL,
  CONSTRAINT seat_id_pk PRIMARY KEY(seat_id),
  CONSTRAINT venue_seat_unique UNIQUE(venue_code, seat_code)
);

/* Table: Inventory */
CREATE TABLE inventory (
  inventory_id	INT NOT NULL,
  event_id		INT NOT NULL,
  seat_id		INT NOT NULL,
  available		BOOLEAN,
  CONSTRAINT inventory_id_pk PRIMARY KEY(inventory_id),
  CONSTRAINT event_seat_unique UNIQUE (event_id, seat_id)
);

/* Foreign Key: Inventory */
ALTER TABLE inventory ADD CONSTRAINT fk_inventory__event FOREIGN KEY (event_id) REFERENCES event(event_id);
ALTER TABLE inventory ADD CONSTRAINT fk_inventory__seat FOREIGN KEY (seat_id) REFERENCES seat(seat_id);

/* Views */
CREATE OR replace VIEW event_inventory
AS
  SELECT i.inventory_id,
         e.event_code,
         e.event_name,
         s.venue_code,
         s.seat_code,
         s.aisle,
         s.seat_type,
         i.available         
  FROM   inventory i,
         event e,
         seat s
  WHERE  i.event_id = e.event_id
         AND i.seat_id = s.seat_id; 