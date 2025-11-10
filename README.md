# Mars Rover Photo API

API Version: [![Version](https://img.shields.io/badge/version-1.1.2-brightgreen.svg)](http://github.com/chrisccerami/mars-photo-api)

Build status: [![CircleCI](https://dl.circleci.com/status-badge/img/gh/corincerami/mars-photo-api/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/corincerami/mars-photo-api/tree/master)

## Introduction

The Nebulum Mars Rover Photo API (https://rovers.nebulum.one/) provides live images from NASA’s Perseverance and Curiosity rovers on Mars. It’s designed to make rover photo data accessible to developers, educators, artists, and citizen scientists.

Data is served from https://rovers.nebulum.one.

## Photo Attributes

Each rover stores photos organized by:

sol – Martian rotation or day since landing

earth_date – Earth calendar date

You can also filter by the camera that took the photo. Each camera has a unique perspective and function.

## Cameras

### Perseverance Rover

| Abbreviation           | Camera Name                       |
|------------------------|----------------------------------|
| EDL_RUCAM              | Rover Up-Look Camera             |
| EDL_RDCAM              | Rover Down-Look Camera           |
| EDL_DDCAM              | Descent Stage Down-Look Camera   |
| EDL_PUCAM1             | Parachute Up-Look Camera A       |
| EDL_PUCAM2             | Parachute Up-Look Camera B       |
| NAVCAM_LEFT            | Navigation Camera - Left         |
| NAVCAM_RIGHT           | Navigation Camera - Right        |
| MCZ_RIGHT              | Mast Camera Zoom - Right         |
| MCZ_LEFT               | Mast Camera Zoom - Left          |
| FRONT_HAZCAM_LEFT_A    | Front Hazard Avoidance Camera - Left |
| FRONT_HAZCAM_RIGHT_A   | Front Hazard Avoidance Camera - Right |
| REAR_HAZCAM_LEFT       | Rear Hazard Avoidance Camera - Left |
| REAR_HAZCAM_RIGHT      | Rear Hazard Avoidance Camera - Right |
| SKYCAM                 | MEDA Skycam                      |
| SHERLOC_WATSON         | SHERLOC WATSON Camera            |

### Curiosity Rover

| Abbreviation | Camera Name                      |
|--------------|---------------------------------|
| FHAZ         | Front Hazard Avoidance Camera    |
| RHAZ         | Rear Hazard Avoidance Camera     |
| MAST         | Mast Camera                      |
| CHEMCAM      | Chemistry and Camera Complex     |
| MAHLI        | Mars Hand Lens Imager            |
| MARDI        | Mars Descent Imager              |
| NAVCAM       | Navigation Camera                |

## Querying the API

Base URL: https://rovers.nebulum.one/api/v1

## Photos Endpoint

## By ID
GET /photos/<id>

Example: https://rovers.nebulum.one/api/v1/photos/878

## By Martian sol:
GET /rovers/<rover>/photos?sol=<sol_number>

Example: https://rovers.nebulum.one/api/v1/rovers/Curiosity/photos?sol=3718

## By Earth date:
GET /rovers/<rover>/photos?earth_date=yyyy-mm-dd

Example: https://rovers.nebulum.one/api/v1/rovers/Perseverance/photos?earth_date=2025-11-06

## Filter by camera:
GET /rovers/<rover>/photos?sol=<sol_number>&camera=<camera_abbr>

Example: https://rovers.nebulum.one/api/v1/rovers/perseverance/photos?sol=1676&camera=NAVCAM_LEFT

## Latest photos:
GET /rovers/<rover>/latest_photos

Example: https://rovers.nebulum.one/api/v1/rovers/Perseverance/latest_photos


## Mission Manifest Endpoint

## Get mission info:
GET /manifests/<rover_name>

## Response includes:

name

landing_date

max_sol

max_date

total_photos

photos (array of photo objects per sol)

Example:
https://rovers.nebulum.one/api/v1/manifests/curiosity

## Respository is maintained by Nebulum: 

Reach out @ https://nebulum.one/
