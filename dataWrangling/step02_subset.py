# step02_subset.py

import pandas as pd
pd.set_option("display.max_rows", None, "display.max_columns", None)


# read in rawData
raw_df = pd.read_csv('rawData.csv', sep=',', header=0)


# extract lists of the site names and dune positions
def make_lists():
    global site_list, dune_list
    site_list = raw_df['Site'].dropna().unique().tolist()
    dune_list = raw_df['Dune Zone'].dropna().unique().tolist()


# set global variables
site_dict = {}
grid_dict = {}
dune_dict = {}
plot_dict = {}
frames_dict = {}
frames = []



def subset_by(site):
	#
	global site_dict, grid_dict, dune_dict, plot_dict, frames_dict, frames
	#
	site_dict = {}
	site_dict[site] = raw_df[raw_df['Site'] == site]
	#
	grid_list = site_dict[site]['Grid'].dropna().unique().tolist()
	#
	grid_dict = {}
	#
	for grid in grid_list:
		grid_dict[grid] = site_dict[site][site_dict[site]['Grid'] == grid]
		#
		dune_dict = {}
		#
		for dune in dune_list:
			dune_dict[dune] = grid_dict[grid][grid_dict[grid]['Dune Zone'] == dune]
			#
			plot_list = dune_dict[dune]['Plot'].unique().tolist()
			plot_dict = {}
			#
			for plot in plot_list:
				plot_dict[plot] = dune_dict[dune][dune_dict[dune]['Plot'] == plot]
				#
				frame = '{}.{}.{}.{}'.format(site, grid, dune, plot)
				burn_list = plot_dict[plot]['TREATMENTS'].dropna().unique().tolist()
				burn = burn_list[0]
				#
				frames_dict[frame] = plot_dict[plot][['Species']].dropna()
				frames_dict[frame]['Total'] = plot_dict[plot]['Total (incl. spin husks)']
				frames_dict[frame] = frames_dict[frame].set_index('Species').transpose()
				#
				frames_dict[frame]['ID'] = '{}.{}.{}'.format(site, grid, dune)
				frames_dict[frame]['Plot'] = frame
				frames_dict[frame]['Burn'] = burn
				frames_dict[frame]['Dune'] = dune
				#
				frames_dict[frame] = frames_dict[frame].loc[:, frames_dict[frame].columns.notnull()]
				frames_dict[frame] = frames_dict[frame].loc[:,~frames_dict[frame].columns.duplicated()]
				#
				frames.append(frames_dict[frame])






def main():
	make_lists()
	for site in site_list:
		subset_by(site)


if __name__ == '__main__':
    main()


subsetData = pd.concat(frames, sort=False)
subsetData.fillna(0, inplace=True)

# print(subsetData)

subsetData.to_csv(r'/Users/kyleclaravall/Google Drive/UNI DOCS/2020_SEM2/BIOL3907/Seed Banks/local_panda/subsetData.csv', index=False)

