# use NCO/ncks to extract (keep) a single variable from a netCDF4 (HD5) file
time find . -name '*.nc' | xargs -I '{}' -P 16 ncks -O --create_ram --mk_rec_dmn time -v u-component_of_wind_surface {} {}

# result: 23m 16s
time find . -name '*.nc' | xargs -I '{}' -P 96 ncks -O --create_ram --mk_rec_dmn time -v v-component_of_wind_surface {} {}
find . -name '*.nc'  0.02s user 0.07s system 0% cpu 26.171 total
xargs -I '{}' -P 96 ncks -O --create_ram --mk_rec_dmn time -v  {} {}  22312.24s user 1069.00s system 1675% cpu 23:15.30 total
                                                                                                 
# result: 32m 19s on an r610 with dual Xeon 6-core (24 threads) and 64 GB RAM connected to a RAID6 NAS for data store/retrieve
time find . -name '*.nc' | xargs -I '{}' -P 96 ncks -O --create_ram --mk_rec_dmn time -v v-component_of_wind_surface {} {}
find . -name '*.nc'  0.01s user 0.11s system 0% cpu 6:12.80 total
xargs -I '{}' -P 96 ncks -O --create_ram --mk_rec_dmn time -v  {} {}  28529.13s user 2178.72s system 1583% cpu 32:18.81 total
