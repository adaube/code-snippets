# reversed_taus = list(reversed(taus))
# reversed_tau_list = list(reversed(tau_list))
# pd_start = start_date_min.replace(hour=0)
# pd_range = pd.date_range(pd_start, periods=len(taus), freq='H')[::-1]
panda_test = pd.DataFrame(taus, tau_list)
panda_test = panda_test.assign(timestamp=pd.date_range(start_date_min.replace(hour=min(tau_list)),
                                                       periods=len(tau_list), freq='H'))
panda_reverse = panda_test[::-1]
tau_df = selected_df[['tau']]
tau_df['tau'] = tau_df['tau'].convert_objects(convert_numeric=True)
# panda_test = panda_test.assign(timestamp=pd_range)

min_key = min(get_keys)
max_key = max(get_keys)
key_series = pd.Series(sorted(get_keys))

df = df.reindex(np.repeat(df.index.values, df['N']), method='ffill')
df['start'] += pd.TimedeltaIndex(df.groupby(level=0).cumcount(), unit='h')

def monotonic(x):
    dx = np.diff(x)
    return np.all(dx <= 0) or np.all(dx >= 0)


def test_regional_range(hybrid_df):
    # this evaluates the range of data required by user request and determines if regionals will fail
    water_columns = ['curr_ucmp', 'curr_vcmp']
    wind_columns = ['wnd_ucmp', 'wnd_vcmp']
    global_currents = config.CAGIPS_FNMOC['HYCOM_12']['prefix']
    global_winds = config.CAGIPS_FNMOC['NAVGEM']['prefix']
    for _ in water_columns:
        series_cell = hybrid_df.T[_]
        global_bool_currents = series_cell.str.contains(global_currents)
        test_global_currents = hybrid_df.T[global_bool_currents].index
        last_regional = (d - pd.Timedelta('1h')).strftime("%Y-%m-%d %H%MZ")
        print(json.JSONEncoder().encode({
            'data': {'RegionalData': True,
                     'lastRegional': last_regional}
        }))
        import sys
        sys.exit()

    for _ in wind_columns:
        series_cell = hybrid_df.T[_]
        global_bool_winds = series_cell.str.contains(global_winds)
        test_global_winds = hybrid_df.T[global_bool_winds].index
        print(test_global_winds.values[0])
        
        
def cartesian_product(arrays):
    broadcastable = np.ix_(*arrays)
    broadcasted = np.broadcast_arrays(*broadcastable)
    rows, cols = reduce(np.multiply, broadcasted[0].shape), len(broadcasted)
    out = np.empty(rows * cols, dtype=broadcasted[0].dtype)
    start, end = 0, rows
    for a in broadcasted:
        out[start:end] = a.reshape(-1)
        start, end = end, end + rows
    return out.reshape(cols, rows).T

