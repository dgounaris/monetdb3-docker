# monetdb3-docker
A docker image for MonetDB with python3 support

## Getting started

This image is based on python:3.8-slim-bullseye. As such, it has native support for adding extra python packages to import in MonetDB UDFs. 

An example command to run this image would be:
`docker run -e 'MONET_DATABASE=testdb' -e 'MONETDB_PASSWORD=testpw' -e 'ADDITIONAL_PKGS=python3-pandas' -p 50000:50000 -d -v monetdbvolume:/var/lib/monetdb gounad/monetdb3:latest`

Environment variables:
| Variable name | Required | Default value | Description |
|---|---|---|---|
| MONET_DBFARM | false | /var/lib/monetdb/dbfarm | The MonetDB farm directory. |
| MONET_DATABASE | true | N/A | The MonetDB database name. |
| MONETDB_PASSWORD | false | N/A | The MonetDB database connection password. |
| ADDITIONAL_PKGS | false | '' | Additional packages to install (comma-separated). These packages will be installed using `apt-get install`. |

The username of the database connection is always `monetdb`.
