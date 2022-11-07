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
|AZURE_SIGN_BLOBS|Append SAS Read tokens to blob urls specified with |
|AZURE_STORAGE_CONNECTION_STRING| Azure storage string used to sign private blobs|
|AZURE_STORAGE_BLOB_NAME_FOR_STAC_ITEMS|Container name for storing the blobs|

## Notes
- Build process uses docker container created by https://github.com/SpatialDays/stac-api-server

