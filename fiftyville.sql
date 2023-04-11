-- Keep a log of any SQL queries you execute as you solve the mystery.
-- crime scene reports on day of robbery

SELECT description FROM crime_scene_reports
WHERE year = 2021 AND month = 7 AND day = 28;

-- learn of three interviews at humphrey bakery will look at transcripts, ROBBERY AT 1015AM
SELECT transcript FROM interviews
WHERE year = 2021 AND month = 7 AND day = 28;

-- learned from interview 1 - LOOK FOR CARS LEAVING BAKERY AT BAKERY PARKING LOT AROUND 1015
SELECT * FROM bakery_security_logs
WHERE year = 2021 AND month = 7 AND day = 28 AND activity = "exit" AND hour = 10;

-- don't learn much from this 9 cars exit after 1015, regardless the 9 car owners are below
SELECT * FROM people
WHERE license_plate IN
(SELECT license_plate FROM bakery_security_logs
WHERE year = 2021 AND month = 7 AND day = 28 AND activity = "exit" AND hour = 10 AND minute > 14 AND minute < 26)
ORDER BY name;

-- learned from interview 2- THIEF WITHDRAWING MONEY FROM ATM AT LEGGETT STREET
SELECT * FROM atm_transactions
WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = "Leggett Street" AND transaction_type = "withdraw";

-- lets learn the names of everyone withdrawing this day from this location
SELECT * FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
WHERE account_number IN
(SELECT account_number FROM atm_transactions
WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = "Leggett Street" AND transaction_type = "withdraw")
ORDER BY name;

-- learned from interview 3- CALLED SOMEONE AFTER ROBBERY TALKED FROM < 60S, TAKING EARLIEST FLIGHT OUT THE NEXT DAY
SELECT * from phone_calls
WHERE year = 2021 AND month = 7 AND day = 28 and duration < 60;

-- lets make a database of all people who fit this description, lets focus on the caller first
SELECT * FROM people
WHERE phone_number IN
(SELECT caller FROM phone_calls
WHERE year = 2021 AND month = 7 AND day = 28 and duration < 60)
ORDER BY name;

-- ok now lets look at who purchased tickets on the first flight out the next day
-- First we need to find the first flight out

SELECT * FROM flights
WHERE year = 2021 AND month = 7 AND day = 29
ORDER BY hour;

-- looks like the first flight out is to LGA id 36 now lets look at the passengers

SELECT * FROM passengers
WHERE flight_id = 36;

-- now lets make a database of all these passengers
SELECT * FROM people
WHERE passport_number IN
(SELECT passport_number FROM passengers
WHERE flight_id = 36)
ORDER BY name;

-- NAMES OF PEOPLE WHO APPEAR IN ALL DATABASES: BRUCE

-- last thing we do is find his accomplice using bruce's phone number

SELECT * FROM people
WHERE phone_number IN
(SELECT receiver from phone_calls
WHERE caller = "(367) 555-5533" AND year = 2021 AND month = 7 AND day = 28 AND duration < 60)

-- It's ROBIN
-- The THIEF is: Bruce
-- The city the thief ESCAPED TO: New York
-- The ACCOMPLICE is: Robin

-- cat log.sql|sqlite3 fiftyville.db

