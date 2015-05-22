import numpy as np
import tables


filename = 'data/0023uLRpitc_NTP_20dT_0.5GndCl.hdf5'

h5file = tables.open_file(filename)
photon_data = h5file.root.photon_data

## Read the data
timestamps = photon_data.timestamps.read()
timestamps_unit = photon_data.timestamps_specs.timestamps_unit.read()
detectors = photon_data.detectors.read()

donor_ch = photon_data.measurement_specs.detectors_specs.spectral_ch1.read()
acceptor_ch = photon_data.measurement_specs.detectors_specs.spectral_ch2.read()

alex_period = photon_data.measurement_specs.alex_period.read()
donor_period = photon_data.measurement_specs.alex_period_spectral_ch1.read()
acceptor_period = photon_data.measurement_specs.alex_period_spectral_ch2.read()

## Print data summary
print('Number of photons: %d' % timestamps.size)
print('Timestamps unit:   %.2e seconds' % timestamps_unit)
print('Detectors:         %s' % np.unique(detectors))
print('Donor CH: %d     Acceptor CH: %d' % (donor_ch, acceptor_ch))
print('ALEX period: %d  \nDonor period: %s      Acceptor period: %s' %\
      (alex_period, donor_period, acceptor_period))

## Compute timestamp selections
timestamps_donor = timestamps[detectors == donor_ch]
timestamps_acceptor = timestamps[detectors == acceptor_ch]

timestamps_mod = timestamps % alex_period
donor_excitation = (timestamps_mod < donor_period[1]) + \
                   (timestamps_mod > donor_period[0])
acceptor_excitation = (timestamps_mod < acceptor_period[1]) * \
                      (timestamps_mod > acceptor_period[0])
timestamps_Dex = timestamps[donor_excitation]
timestamps_Aex = timestamps[acceptor_excitation]

