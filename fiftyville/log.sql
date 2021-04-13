-- Keep a log of any SQL queries you execute as you solve the mystery.

-- The theft took place on July 28, 2020 and that it took place on Chamberlin Street
-- Get the description from the crime scene report
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = "Chamberlin Street";

-- Description says: Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
-- Interviews were conducted today with three witnesses who were present at the time — 
-- each of their interview transcripts mentions the courthouse.

--Get the names of the interviewees and their transcripts
SELECT name, transcript FROM interviews WHERE month = 7 AND day = 28;
/*
Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away. If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.
Eugene | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
Raymond | As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
*/

-- Check the courthouse parking lot within 10 minutes of the theft
-- Check the ATM on Fifer Street, early in the morning, thief was withdrawing money
-- Check the earliest flight out of fiftyville 
-- Thief called accomplice to buy ticket


-- Check the logs at the courthouse when people left within 10 minutes of the crime
SELECT activity, minute FROM courthouse_security_logs WHERE month = 7 AND day = 28 AND hour = 10;

-- Check the courthouse liscence_plates around this time
SELECT license_plate FROM courthouse_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit";

-- Get the names and numbers of the people with the cars
SELECT name, phone_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit");
/*
Patrick | (725) 555-4692
Amber | (301) 555-4174
Elizabeth | (829) 555-5269
Roger | (130) 555-0289
Danielle | (389) 555-5198
Russell | (770) 555-1861
Evelyn | (499) 555-9472
Ernest | (367) 555-5533
*/

-- Find the person that made a call on July 28th that was less than a minute and their passport
SELECT name, phone_number, passport_number FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration <= 60 INTERSECT SELECT phone_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit"));

/*
Roger | (130) 555-0289 | 1695452385
Russell | (770) 555-1861 | 3592750733
Evelyn | (499) 555-9472 | 8294398571
Ernest | (367) 555-5533 | 5773159633
*/ 

-- List of airports

SELECT full_name, abbreviation, city, id FROM airports WHERE id IN (SELECT DISTINCT origin_airport_id FROM flights);
/*
full_name | abbreviation | city | id
O'Hare International Airport | ORD | Chicago | 1
Beijing Capital International Airport | PEK | Beijing | 2
Los Angeles International Airport | LAX | Los Angeles | 3
Heathrow Airport | LHR | London | 4
Dallas/Fort Worth International Airport | DFS | Dallas | 5
Logan International Airport | BOS | Boston | 6
Dubai International Airport | DXB | Dubai | 7
Fiftyville Regional Airport | CSF | Fiftyville | 8
*/

-- Check the earliest flight out of fiftyville
SELECT id, hour, minute, destination_airport_id FROM flights WHERE year = 2020 AND month = 7 AND day = 29 AND origin_airport_id = 8;

-- Flights of the day for July 29th, 2020 out of CSF
/*
id | hour | minute | destination_airport_id
18 | 16 | 0 | 6
23 | 12 | 15 | 11
36 | 8 | 20 | 4
43 | 9 | 30 | 1
53 | 15 | 20 | 9
*/

-- Find the person that booked a flight the next day
SELECT name FROM people WHERE passport_number IN (SELECT passport_number FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration <= 60 INTERSECT SELECT phone_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit")) INTERSECT SELECT passport_number FROM passengers WHERE flight_id = 36);
/*
Roger
Evelyn
Ernest
*/

-- Check who used the ATM the morning of July 28th and is on a flight
SELECT name FROM people WHERE id IN (SELECT person_id FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location = "Fifer Street" AND transaction_type = "withdraw")) INTERSECT SELECT name FROM people WHERE passport_number IN (SELECT passport_number FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration <= 60 INTERSECT SELECT phone_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit")) INTERSECT SELECT passport_number FROM passengers WHERE flight_id = 36);;

--Ernest

-- Who received calls from Ernest

SELECT name FROM people WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE caller IN (SELECT phone_number FROM people WHERE name = "Ernest") AND year = 2020 AND month = 7 AND day = 28 AND duration < 60);
/*
Ernest (367) 555-5533 | Berthold (375) 555-8161
*/
