"""
This script shows how to read us-ALEX data stored in a Photon-HDF5 file.

For more info see the notebooks in the same folder.
"""

import numpy as np
import tables


filename = '../data/0023uLRpitc_NTP_20dT_0.5GndCl.hdf5'

h5file = tables.open_file(filename)
photon_data = h5file.root.photon_data

#%% Read the data
timestamps = photon_data.timestamps.read()
timestamps_unit = photon_data.timestamps_specs.timestamps_unit.read()
detectors = photon_data.detectors.read()

donor_ch = photon_data.measurement_specs.detectors_specs.spectral_ch1.read()
acceptor_ch = photon_data.measurement_specs.detectors_specs.spectral_ch2.read()

alex_period = photon_data.measurement_specs.alex_period.read()
offset = photon_data.measurement_specs.alex_offset.read()
donor_period = photon_data.measurement_specs.alex_excitation_period1.read()
acceptor_period = photon_data.measurement_specs.alex_excitation_period2.read()

#%% Print data summary
print('Number of photons: %d' % timestamps.size)
print('Timestamps unit:   %.2e seconds' % timestamps_unit)
print('Detectors:         %s' % np.unique(detectors))
print('Donor CH: %d     Acceptor CH: %d' % (donor_ch, acceptor_ch))
print('ALEX period: %4d \nOffset: %4d \nDonor period: %s \nAcceptor period: %s' % \
      (alex_period, offset, donor_period, acceptor_period))

## Compute timestamp selections
timestamps_donor = timestamps[detectors == donor_ch]
timestamps_acceptor = timestamps[detectors == acceptor_ch]

timestamps_mod = (timestamps - offset) % alex_period
donor_excitation = (timestamps_mod < donor_period[1])*(timestamps_mod > donor_period[0])
acceptor_excitation = (timestamps_mod < acceptor_period[1])*(timestamps_mod > acceptor_period[0])
timestamps_Dex = timestamps[donor_excitation]
timestamps_Aex = timestamps[acceptor_excitation]

#%% Plot ALEX histogram
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.hist((timestamps_acceptor - offset) % alex_period, bins=100, alpha=0.8, color='red', label='donor')
ax.hist((timestamps_donor - offset) % alex_period, bins=100, alpha=0.8, color='green', label='acceptor')
ax.axvspan(donor_period[0], donor_period[1], alpha=0.3, color='green')
ax.axvspan(acceptor_period[0], acceptor_period[1], alpha=0.3, color='red')
ax.set_xlabel('(timestamps - offset) MOD alex_period')
ax.set_title('ALEX histogram')
ax.legend()
