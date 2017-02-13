psql -d test -c 'drop view nextmoves;' 
psql -d test -c 'drop view assetssummary;' 
psql -d test -c 'drop table roads;' 
psql -d test -c 'drop table hotels;'
psql -d test -c 'drop table towns;'
psql -d test -c 'drop table cities;'
psql -d test -c 'drop table persons;'
psql -d test -c 'drop table areas;'
psql -d test -c 'drop table countries;'
psql -d test -c 'drop table constants;'
psql -d test -f createTables.sql
psql -d test -f lab2-20-constants.sql
psql -d test -f roadtriggers.sql
psql -d test -f persontriggers.sql
psql -d test -f views.sql
psql -d test -f persontest.sql
