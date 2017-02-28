psql -d test -c 'drop view nextmoves;' 
psql -d test -c 'drop view assetsummary;' 
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
psql -d test -f lab2-10-assert.sql
psql -d test -f roadtriggers.sql
psql -d test -f persontriggers.sql
psql -d test -f hotelstriggers.sql
psql -d test -f views2.sql

psql -d test -f shouldwork/test1.sql
#psql -d test -f shouldfail/createTwoHotels.sql
#psql -d test -f shouldfail/nomoneyznotome.sql
#psql -d test -f shouldfail/roadmoney.sql
#psql -d test -f shouldfail/updatehotel.sql
#psql -d test -f shouldfail/hotelGovernment.sql
#psql -d test -f shouldfail/noroad.sql
#psql -d test -f shouldfail/roadSwitched.sql
#psql -d test -f shouldfail/updateroad.sql
#psql -d test -f shouldfail/hotelNoMoneyz.sql
#psql -d test -f shouldfail/roadtoself.sql
#psql -d test -f shouldfail/movetosamelocation.sql
#psql -d test -f shouldfail/personnummer.sql
