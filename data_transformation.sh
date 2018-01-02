# use NCO/ncks to extract (keep) a single variable from a netCDF4 (HD5) file
time find . -name '*.nc' | xargs -I '{}' -P 16 ncks -O --create_ram --mk_rec_dmn time -v u-component_of_wind_surface {} {}
