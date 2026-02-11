# Mars Rover Photo API
API Version: [![Version](https://img.shields.io/badge/version-1.1.2-brightgreen.svg)](http://github.com/chrisccerami/mars-photo-api)
Build status: [![CircleCI](https://dl.circleci.com/status-badge/img/gh/corincerami/mars-photo-api/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/corincerami/mars-photo-api/tree/master)

## Introduction
The Nebulum Mars Rover Photo API (https://rovers.nebulum.one/) provides live images from NASA's Perseverance and Curiosity rovers on Mars. It's designed to make rover photo data accessible to developers, educators, artists, and citizen scientists.

Data is served from https://rovers.nebulum.one.

## Photo Attributes
Each rover stores photos organized by:
- **sol** – Martian rotation or day since landing
- **earth_date** – Earth calendar date

You can also filter by the camera that took the photo. Each camera has a unique perspective and function.

## Cameras

### Perseverance Rover

| Abbreviation           | Camera Name                       | Type | Color | Purpose |
|------------------------|----------------------------------|------|-------|---------|
| EDL_RUCAM              | Rover Up-Look Camera             | EDL  | ✓ | Captures parachute deployment during landing |
| EDL_RDCAM              | Rover Down-Look Camera           | EDL  | ✓ | Records terrain during descent |
| EDL_DDCAM              | Descent Stage Down-Look Camera   | EDL  | ✓ | Documents landing sequence from descent stage |
| EDL_PUCAM1             | Parachute Up-Look Camera A       | EDL  | ✓ | Monitors parachute during descent |
| EDL_PUCAM2             | Parachute Up-Look Camera B       | EDL  | ✓ | Backup parachute monitoring |
| NAVCAM_LEFT            | Navigation Camera - Left         | Navigation | ✗ | Stereo navigation and path planning (grayscale) |
| NAVCAM_RIGHT           | Navigation Camera - Right        | Navigation | ✗ | Stereo navigation and path planning (grayscale) |
| MCZ_RIGHT              | Mast Camera Zoom - Right         | Science | ✓ | High-resolution color panoramas and geology (zoomable) |
| MCZ_LEFT               | Mast Camera Zoom - Left          | Science | ✓ | High-resolution color panoramas and geology (zoomable) |
| FRONT_HAZCAM_LEFT_A    | Front Hazard Avoidance Camera - Left | Engineering | ✗ | Detects obstacles in rover's path (grayscale) |
| FRONT_HAZCAM_RIGHT_A   | Front Hazard Avoidance Camera - Right | Engineering | ✗ | Detects obstacles in rover's path (grayscale) |
| REAR_HAZCAM_LEFT       | Rear Hazard Avoidance Camera - Left | Engineering | ✗ | Monitors terrain behind rover (grayscale) |
| REAR_HAZCAM_RIGHT      | Rear Hazard Avoidance Camera - Right | Engineering | ✗ | Monitors terrain behind rover (grayscale) |
| SKYCAM                 | MEDA Skycam                      | Atmospheric | ✓ | Color imaging of sky, clouds, and atmospheric conditions |
| SHERLOC_WATSON         | SHERLOC WATSON Camera            | Science | ✓ | Extreme close-up color macro imaging of rock textures |

**Camera Types:**
- **EDL (Entry, Descent, Landing)**: One-time use cameras that documented Perseverance's landing sequence
- **Science**: Primary instruments for geological research and public outreach
- **Navigation**: Autonomous driving and path planning
- **Engineering**: Hazard detection and rover safety
- **Atmospheric**: Weather and sky monitoring

### Curiosity Rover

| Abbreviation | Camera Name                      | Type | Color | Purpose |
|--------------|----------------------------------|------|-------|---------|
| FHAZ         | Front Hazard Avoidance Camera    | Engineering | ✗ | Detects obstacles ahead of rover (grayscale) |
| RHAZ         | Rear Hazard Avoidance Camera     | Engineering | ✗ | Monitors terrain behind rover (grayscale) |
| MAST         | Mast Camera                      | Science | ✓ | High-resolution color panoramas and geology |
| CHEMCAM      | Chemistry and Camera Complex     | Science | ✗ | Remote imaging of laser target spots (grayscale) |
| MAHLI        | Mars Hand Lens Imager            | Science | ✓ | Close-up color images of rocks and soil |
| MARDI        | Mars Descent Imager              | EDL | ✓ | Color images during landing descent |
| NAVCAM       | Navigation Camera                | Navigation | ✗ | Stereo navigation and path planning (grayscale) |

### Understanding Color vs Grayscale
**Color cameras** (marked with ✓) capture full RGB images ideal for:
- Scientific analysis of rock composition and layering
- Public engagement and education
- Atmospheric and lighting studies
- Detailed geological documentation

**Grayscale cameras** (marked with ✗) are used for:
- Faster image processing and data transmission
- Real-time navigation and hazard detection
- Efficient autonomous driving operations
- Reduced bandwidth requirements

## Querying the API
Base URL: https://rovers.nebulum.one/api/v1

### Photos Endpoint

#### By ID
```
GET /photos/<id>
```
Example: https://rovers.nebulum.one/api/v1/photos/878

#### By Martian sol:
```
GET /rovers/<rover>/photos?sol=<sol_number>
```
Example: https://rovers.nebulum.one/api/v1/rovers/Curiosity/photos?sol=3718

#### By Earth date:
```
GET /rovers/<rover>/photos?earth_date=yyyy-mm-dd
```
Example: https://rovers.nebulum.one/api/v1/rovers/Perseverance/photos?earth_date=2025-11-06

#### Filter by camera:
```
GET /rovers/<rover>/photos?sol=<sol_number>&camera=<camera_abbr>
```
Example: https://rovers.nebulum.one/api/v1/rovers/perseverance/photos?sol=1676&camera=NAVCAM_LEFT

#### Latest photos:
```
GET /rovers/<rover>/latest_photos
```
Example: https://rovers.nebulum.one/api/v1/rovers/Perseverance/latest_photos

### Mission Manifest Endpoint

#### Get mission info:
```
GET /manifests/<rover_name>
```

Response includes:
- name
- landing_date
- max_sol
- max_date
- total_photos
- photos (array of photo objects per sol)

Example: https://rovers.nebulum.one/api/v1/manifests/curiosity

## Repository is maintained by Nebulum
Reach out @ https://nebulum.one/  
Find more projects at Nebulum Labs @ https://nebulum.one/labs/
