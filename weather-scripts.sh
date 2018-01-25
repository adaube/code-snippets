# finds the 29 january months and uses cat! awesome!!!
find . -type f -name multi_reanal.glo_30m.dp*01.grb2 | xargs -I '{}' cat {} > outfile_glo_30m_dp.grb2

# don't use this unless i figure out how to fix the weird stuff cdo does
find . -type f -name multi_reanal.glo_30m.wind*01.grb2 | xargs -I '{}' cdo -f nc4 cat {} test_cdo_glo_wind_cat.nc

ncra -d time,1,7192,124 test_cdo_glo_wind_cat.nc ncra_test.nc

java -Xmx1g -classpath /home/adaube/process_data/netcdfAll-4.6.11.jar ucar.nc2.write.Nccopy -f netcdf4 -i outfile_glo_30m_dp.grb2 -o outfile_glo_30m_dp.nc

# finds files containing string in name and uses xargs to use cdo to convert GRIB2 into netcdf4 ***(CURRENTLY DOESN'T OUTPUT INTO INTELLIGABLE LATLON COORD VALS)***
find $PWD -name '*bounding_box*' | xargs -i -t -n1 -P8 cdo -f nc4 -R -z zip copy {} {}.nc

# using CDO to select params with wildcards then read output
cdo -select,name=t 2010-06-*.grb2 2010-06-t.grb2
cdo sinfon 2010-06-t.grb2

# convert using netcdf-tools
time find $PWD -name '*curr_vcmp&format=GRIB2*' | xargs -i -t -n1 -P4 sudo java -Xmx256m -classpath /home/adam/PycharmProjects/drift-sar/lib/drift_modules/downloader/netcdfAll-4.6.6.jar ucar.nc2.dataset.NetcdfDataset -in {} -out {}.nc

# crazy ncclimo!!! examples invoke reshaping mode in the three possible ways
#+
# Pipe list to stdin
cd $drc_in;ls *mdl*000[1-9]*.nc | ncclimo -v T,Q,RH -s 1 -e 9 -o $drc_out
# Redirect list from file to stdin
cd $drc_in;ls *mdl*000[1-9]*.nc > foo;ncclimo -v T,Q,RH -s 1 -e 9 -o $drc_out < foo
# List as positional arguments
ncclimo -v T,Q,RH -s 1 -e 9 -o $drc_out $drc_in/*mdl*000[1-9]*.nc
# Glob directory
ncclimo -v T,Q,RH -s 1 -e 9 -i $drc_in -o $drc_out

# garbage collect after converting GRIB to netcdf
find $PWD -name '*.[gn][bc][x][39]' | xargs -i -t -n1 -P8 rm {}
# Use NCO to overwrite, in RAM, making record dimension set to time, extraction of single variable.
ncks -O --create_ram --mk_rec_dmn time -v u-component_of_wind_surface 02.nc 02.nc

# Make the record dimension time so we can append the files along record dim
ncks -O --mk_rec_dmn time pgbh06.gdas.2015011500.test.nc pgbh06.gdas.2015011500.test.nc

# Selectively remove garbage dimension and variable
ncks -C -O -x -v time1_bounds -d time1_bounds_Dim1,1 pgbh06.gdas.2015011500.test.nc pgbh06.gdas.2015011500.test.nc

# Simultaneously rename the dimension and the variable
Mon Dec 18 14:02:09 2017: 
ncrename -d time1,time -v time1,time pgbh06.gdas.2015011500.test.nc

# Here we extract a single parameter
Mon Dec 18 13:31:47 2017: 
ncks -v Categorical_Rain_surface_6_Hour_Average pgbh06.gdas.2015011500.nc pgbh06.gdas.2015011500.test.nc

# original data extraction for 22 of 174 parameters (file already netCDF4)
Sat Nov 11 08:41:22 2017: 
ncks -O -a --create_ram --no_tmp_fl -v Geopotential_height_isobaric,Temperature_surface,u-component_of_wind_isobaric,v-component_of_wind_isobaric,u-component_of_wind_height_above_ground,v-component_of_wind_height_above_ground,Ice_cover_surface,Ice_thickness_surface,Maximum_temperature_height_above_ground_6_Hour_Interval,Minimum_temperature_height_above_ground_6_Hour_Interval,Precipitation_rate_surface_6_Hour_Average,Pressure_reduced_to_MSL_msl,Relative_humidity_isobaric,Relative_humidity_height_above_ground,Temperature_isobaric,Temperature_height_above_ground,Total_cloud_cover_entire_atmosphere_single_layer_6_Hour_Average,Categorical_Rain_surface_6_Hour_Average,Categorical_Rain_surface,Categorical_Freezing_Rain_surface_6_Hour_Average,Categorical_Ice_Pellets_surface_6_Hour_Average,Categorical_Snow_surface_6_Hour_Average /skynet/ACAF5_data/cfsrv2/201501/pgbh06.gdas.2015011500.nc /skynet/ACAF5_data/cfsrv2/201501/pgbh06.gdas.2015011500.nc.extracted
# NCO examples!
# makes the dimension "time" the record dimension.
ncks --mk_rec_dmn time in.nc out.nc

# find CFSRv2 files for Dec 01 to Dec 15 for data experiment and copy them to backup dir
find . -maxdepth 1 -name 'pgbh06.gdas.201512[01][0-5]*' | xargs -I '{}' cp {} adam_data_experiment/

# only keep var1,var2 variables
ncks -O -v var1,var2 filein.nc fileout.nc

# Variables needed from CFSRv2 for ACAF5
Geopotential_height_isobaric,Temperature_surface,u-component_of_wind_isobaric,v-component_of_wind_isobaric,u-component_of_wind_height_above_ground,v-component_of_wind_height_above_ground,Ice_cover_surface,Ice_thickness_surface,Maximum_temperature_height_above_ground_6_Hour_Interval,Minimum_temperature_height_above_ground_6_Hour_Interval,Precipitation_rate_surface_6_Hour_Average,Pressure_reduced_to_MSL_msl,Relative_humidity_isobaric,Relative_humidity_height_above_ground,Temperature_isobaric,Temperature_height_above_ground,Total_cloud_cover_entire_atmosphere_single_layer_6_Hour_Average,Categorical_Rain_surface_6_Hour_Average,Categorical_Rain_surface,Categorical_Freezing_Rain_surface_6_Hour_Average,Categorical_Ice_Pellets_surface_6_Hour_Average,Categorical_Snow_surface_6_Hour_Average

# Experiment: extracting 22 required variables from CFSRv2 for 2016 span for ACAF5
time find . -maxdepth 1 -name 'pgbh06.gdas.201512[01][0-5]*' | \
xargs -I '{}' -P 8 \
ncks -v 'Geopotential_height_isobaric,Temperature_surface, \
u-component_of_wind_isobaric,v-component_of_wind_isobaric, \
u-component_of_wind_height_above_ground, \
v-component_of_wind_height_above_ground, \
Ice_cover_surface,Ice_thickness_surface, \
Maximum_temperature_height_above_ground_6_Hour_Interval, \
Minimum_temperature_height_above_ground_6_Hour_Interval, \
Precipitation_rate_surface_6_Hour_Average, \
Pressure_reduced_to_MSL_msl,Relative_humidity_isobaric, \
Relative_humidity_height_above_ground,Temperature_isobaric, \
Temperature_height_above_ground, \
Total_cloud_cover_entire_atmosphere_single_layer_6_Hour_Average, \
Categorical_Rain_surface_6_Hour_Average,Categorical_Rain_surface, \
Categorical_Freezing_Rain_surface_6_Hour_Average, \
Categorical_Ice_Pellets_surface_6_Hour_Average, \
Categorical_Snow_surface_6_Hour_Average' \
{} {}.extracted
# real	1m0.818s
# user	3m50.144s
# sys	0m6.864s

# Experiment: extracting 22 required variables from CFSRv2 for 2016 span for ACAF5
time find /skynet/ACAF5_data/cfsrv2/ -maxdepth 2 -name 'pgbh06.gdas.2016*' | \
xargs -I '{}' -P 8 \
ncks -O -a --create_ram --no_tmp_fl -v Geopotential_height_isobaric,Temperature_surface,\
u-component_of_wind_isobaric,v-component_of_wind_isobaric,\
u-component_of_wind_height_above_ground,\
v-component_of_wind_height_above_ground,\
Ice_cover_surface,Ice_thickness_surface,\
Maximum_temperature_height_above_ground_6_Hour_Interval,\
Minimum_temperature_height_above_ground_6_Hour_Interval,\
Precipitation_rate_surface_6_Hour_Average,\
Pressure_reduced_to_MSL_msl,Relative_humidity_isobaric,\
Relative_humidity_height_above_ground,Temperature_isobaric,\
Temperature_height_above_ground,\
Total_cloud_cover_entire_atmosphere_single_layer_6_Hour_Average,\
Categorical_Rain_surface_6_Hour_Average,Categorical_Rain_surface,\
Categorical_Freezing_Rain_surface_6_Hour_Average,\
Categorical_Ice_Pellets_surface_6_Hour_Average,\
Categorical_Snow_surface_6_Hour_Average \
{} {}.extracted
# real    32m42.279s
# user    128m27.560s
# sys     3m55.032s

# Experiment: extracting 22 required variables from CFSRv2 for 1979 span for ACAF5
# Command to find netCDF files for ACAF5 cfsrv2 (PWD as /skynet/ACAF5_data/cfsrv2/)
time find /skynet/ACAF5_data/cfsrv2/ -maxdepth 2 -name 'pgbh06.gdas.197*' | \
xargs -I '{}' -P 8 \
ncks -O -a --create_ram --no_tmp_fl -v Geopotential_height_isobaric,Temperature_surface,\
u-component_of_wind_isobaric,v-component_of_wind_isobaric,\
u-component_of_wind_height_above_ground,\
v-component_of_wind_height_above_ground,\
Ice_cover_surface,Ice_thickness_surface,\
Maximum_temperature_height_above_ground_6_Hour_Interval,\
Minimum_temperature_height_above_ground_6_Hour_Interval,\
Precipitation_rate_surface_6_Hour_Average,\
Pressure_reduced_to_MSL_msl,Relative_humidity_isobaric,\
Relative_humidity_height_above_ground,Temperature_isobaric,\
Temperature_height_above_ground,\
Total_cloud_cover_entire_atmosphere_single_layer_6_Hour_Average,\
Categorical_Rain_surface_6_Hour_Average,Categorical_Rain_surface,\
Categorical_Freezing_Rain_surface_6_Hour_Average,\
Categorical_Ice_Pellets_surface_6_Hour_Average,\
Categorical_Snow_surface_6_Hour_Average \
{} {}.extracted

# Command to find netCDF files for ACAF5 cfsrv2 (PWD as /skynet/ACAF5_data/cfsrv2/)
time find /skynet/ACAF5_data/cfsrv2/ -maxdepth 2 -name 'pgbh06.gdas.20*' | \
xargs -I '{}' -P 8 \
ncks -O -a --create_ram --no_tmp_fl -v Geopotential_height_isobaric,Temperature_surface,\
u-component_of_wind_isobaric,v-component_of_wind_isobaric,\
u-component_of_wind_height_above_ground,\
v-component_of_wind_height_above_ground,\
Ice_cover_surface,Ice_thickness_surface,\
Maximum_temperature_height_above_ground_6_Hour_Interval,\
Minimum_temperature_height_above_ground_6_Hour_Interval,\
Precipitation_rate_surface_6_Hour_Average,\
Pressure_reduced_to_MSL_msl,Relative_humidity_isobaric,\
Relative_humidity_height_above_ground,Temperature_isobaric,\
Temperature_height_above_ground,\
Total_cloud_cover_entire_atmosphere_single_layer_6_Hour_Average,\
Categorical_Rain_surface_6_Hour_Average,Categorical_Rain_surface,\
Categorical_Freezing_Rain_surface_6_Hour_Average,\
Categorical_Ice_Pellets_surface_6_Hour_Average,\
Categorical_Snow_surface_6_Hour_Average \
{} {}.extracted

# Find above and use xargs to pass to nco command ncks that extracts and overwrites
find . -maxdepth 2 -name 'pgbh06.gdas.*'

# Failed experiments with multiple xargs
echo $(cat cfsrv2_params_required_acaf5_flat.csv) $(find . -maxdepth 1 -name 'pgbh06.gdas.201512[01][0-5]*') | xargs -l bash -c 'ncks -O -v $1 $2 $2' | xargs

echo $(cat cfsrv2_params_required_acaf5_flat.csv) $(find . -maxdepth 1 -name 'pgbh06.gdas.201512[01][0-5]*') | xargs -l bash -c 'echo $1 $2 $2' | xargs

echo $(cat cfsrv2_params_required_acaf5_flat.csv) $(find . -maxdepth 1 -name 'pgbh06.gdas.201512[01][0-5]*') | xargs -l bash -c 'echo $*' | xargs

# add extension nc
find . -maxdepth 1 -name 'pgbh06.gdas.201512[01][0-5]' | xargs -I '{}' -P8 rename -n s/$/.nc/ {}

# remove var1 and var2 variables from netcdf file
ncks -x -v var1,var2 in.nc out.nc

# extract and display information about variable
ncks -H -v Temperature_surface Jan_01_00_daily_ltm.nc

# dumps the netcdf file, swaps the time dimension of 1 for "unlimited" time currently 1, and generates a new
# netCDF file, use NCO to concatenate files
set str1 = 'time = 1 ;'
set str2 = 'time = UNLIMITED ; // (1 currently)'
ncdump in.nc  | sed -e "s#^.$str1# $str2#" | ncgen -o out.nc

# convert time from a fixed dimension to a record dimension, so we can append time slices to data
ncks -O --mk_rec_dmn time 01-01-00_hourly_lt_max.nc test_make_record_dim_time.nc

# convert time to record dimension across all nc files
time find . -name '01*.nc' | xargs -I '{}' -P 8 ncks -O --mk_rec_dmn time {} {}

# append along record time dimension
ncrcat --rec_apn --no_tmp_fl 01-*_hourly_lt_max.nc test_ncrcat_01-01.nc

# make a record dimension for all netCDF files in each subdirectory, append along record dimension for respective subdirectory to a file
for d in */ ; do     
time find $d -name '*.nc' | xargs -I '{}' -P 128 ncks -O --mk_rec_dmn time {} {};
time ncrcat --rec_apn --no_tmp_fl $d/*.nc $d/another_test.nc; 
done

# display
ncrcat --cnk_plc nco -r --rec_apm -H -d time -v Temperature_surface -n --no_tmp_fl 1464 Jan_01_06_daily_ltm.nc Jan_01_00_daily_ltm.nc
