# STAC Browser
A full-fledged UI for browsing static STAC catalogs and STAC APIs
Custom fork of https://github.com/radiantearth/stac-browser

## Build Jobs

Two build jobs set up, for building both prod and dev docker image
from Dockerfile_dev and Dockerfile_prod.

## Environment variables

|Var name|Used for|
| --- | --- |
|POSTGRES_USER| Postgres username|
|POSTGRES_PASS| Postgres password|
|POSTGRES_DBNAME| Postgres database name storign stac records|
|POSTGRES_HOST_READER| Hostname of the database for read connections|
|POSTGRES_HOST_WRITER| Hostname of the database for write connections|
|POSTGRES_PORT| Postgress port|

## Notes
- Build process uses docker container created by https://github.com/SpatialDays/stac-api-server

