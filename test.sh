cd build
wget http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf
./osrm-extract -p ../profiles/car.lua ./berlin-latest.osm.pbf
./osrm-partition ./berlin-latest.osrm
./osrm-customize ./berlin-latest.osrm
./osrm-routed --algorithm mld ./berlin-latest.osrm
# curl "http://127.0.0.1:5000/route/v1/driving/13.388860,52.517037;13.385983,52.496891"           
# curl "http://127.0.0.1:5000/table/v1/driving/13.388860,52.517037;13.385983,52.496891?sources=0&destinations=1&annotations=distance,duration"           