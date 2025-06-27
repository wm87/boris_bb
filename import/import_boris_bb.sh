#!/bin/bash

dbname="boris_bb"
dbtable="boris_bb"
insertdatum=$(date +%Y-%m-%d)
cores=6

# get Connection
source $HOME/boris_bb/params/db_params.sh $dbname

insert_folder="/data/import/bb/boris_bb"

if [ ! -d "$insert_folder/logs" ]; then
  mkdir $insert_folder/logs
fi
postnas_logfile="$insert_folder/logs/"$insertdatum"-postnas_import_single.log"

# close connection
psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid),pg_stat_activity.usename,pg_stat_activity.application_name,pg_stat_activity.client_addr,pg_stat_activity.client_hostname,pg_stat_activity.client_port  FROM pg_stat_activity WHERE pg_stat_activity.datname = '$dbname' AND pid <> pg_backend_pid();" $CON

# delete db
dropdb --if-exists -p $dbport $dbname -U $dbuser

# create db
createdb -E UTF8 -T postgis_template -p $dbport $dbname -D $dbtablespace -U $dbuser
psql -c "ALTER DATABASE $dbname SET search_path TO public;" $CON

# Tabelle erstellen
psql -f $HOME/boris_bb/import/create_boris_table.sql $CON

# Daten importieren
psql -c "COPY boris_bb(gesl,gena,gasl,gabe,genu,gema,ortst,wnum,brw,wae,stag,brke,bedw,plz,basbe,basma,xybrw,posb,posa,apma,bezug,epsg,entw,beit,nuta,ergnuta,bauw,gez,gezm,wgfz,wgfzm,grz,grzm,bmz,bmzm,flae,flaem,fmass,gtie,gtiem,gbrei,gbreim,erve,verg,verf,vnum,bod,acza,aczam,grza,grzam,aufw,weer,geom,bem,frei,brzname,umart,lumnum,status,degl) FROM '/data/import/bb/boris_bb/BRW_2022_Land_BB.csv' DELIMITER '|' CSV HEADER;" $CON

psql -c "ALTER TABLE $dbtable ALTER COLUMN geom TYPE geometry(Polygon, 25833) USING ST_SetSRID(geom,25833); CREATE INDEX boris_bb_the_geom_gist ON boris_bb USING gist (geom);" $CON

psql -c"
UPDATE boris_bb 
SET brw = REPLACE(brw,',','.');

UPDATE boris_bb 
SET brw = (round( CAST(brw as numeric), 0))
where 
  ROUND(CAST(brw AS DOUBLE PRECISION)) >= 0
  AND entw != 'LF';" $CON

# Point Geometry erzeugen
psql -c "ALTER TABLE $dbtable ADD COLUMN geom_point geometry; ALTER TABLE $dbtable ALTER COLUMN geom_point TYPE geometry(Point, 25833) USING ST_SetSRID(geom_point,25833); CREATE INDEX boris_bb_geom_point_gist ON $dbtable USING gist (geom_point);" $CON
psql -c "UPDATE boris_bb SET geom_point = ST_GeomFromText(xybrw, 25833);" $CON

# DB mit INDEX säubern
psql -c "VACUUM FULL" $CON
