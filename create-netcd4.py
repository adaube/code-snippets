import netCDF4 as nc4
import numpy as np

# Lets quickly create 3 NetCDF files with 3 dimensions
for i in range(3):
    f = nc4.Dataset('test_{0:1d}.nc'.format(i), 'w')

    # Create the 3 dimensions
    dim_x = f.createDimension('x', 2)
    dim_y = f.createDimension('y', 3)
    dim_z = f.createDimension('z', 4)
    var_t = f.createVariable('temperature', 'double', ('x','y','z'))

    # Add some dummy data
    var_t[:,:,:] = np.random.random(2*3*4).reshape(2,3,4)

    f.close()

# Now the actual merging:
# Get the dimensions (sizes) from the first file:
f_in = nc4.Dataset('test_0.nc', 'r')
dim_size_x = f_in.dimensions['x'].size
dim_size_y = f_in.dimensions['y'].size
dim_size_z = f_in.dimensions['z'].size
dim_size_t = 3
f_in.close()

# Create new NetCDF file:
f_out = nc4.Dataset('test_merged.nc', 'w')

# Add the dimensions, including an unlimited time dimension:
dim_x = f_out.createDimension('x', dim_size_x)
dim_y = f_out.createDimension('y', dim_size_y)
dim_z = f_out.createDimension('z', dim_size_z)
dim_t = f_out.createDimension('time', None)

# Create new variable with 4 dimensions
var_t = f_out.createVariable('temperature', 'double', ('time','x','y','z'))

# Add the data
for i in range(3):
    f_in = nc4.Dataset('test_{0:1d}.nc'.format(i), 'r')
    var_t[i,:,:,:] = f_in.variables['temperature'][:,:,:]
    f_in.close()

f_out.close()
