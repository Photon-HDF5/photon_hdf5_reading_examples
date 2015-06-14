%
% This script shows how to read us-ALEX data stored in a Photon-HDF5 file.
% 
% MATLAB R2011b or more recent is required.
%

filename = '../data/0023uLRpitc_NTP_20dT_0.5GndCl.hdf5';


%% Read the data
timestamps = h5read(filename, '/photon_data/timestamps');
timestamps_unit = h5read(filename, '/photon_data/timestamps_specs/timestamps_unit');
detectors = h5read(filename, '/photon_data/detectors');

donor_ch = h5read(filename, '/photon_data/measurement_specs/detectors_specs/spectral_ch1');
acceptor_ch = h5read(filename, '/photon_data/measurement_specs/detectors_specs/spectral_ch2');

alex_period = h5read(filename, '/photon_data/measurement_specs/alex_period');
donor_period = h5read(filename, '/photon_data/measurement_specs/alex_period_spectral_ch1');
acceptor_period = h5read(filename, '/photon_data/measurement_specs/alex_period_spectral_ch2');


%% Print data summary
fprintf('Number of photons: %d\n', size(timestamps));
fprintf('Timestamps unit:   %.2e seconds\n', timestamps_unit);
fprintf('Detectors:         %s\n', unique(detectors));
fprintf('Donor CH: %d     Acceptor CH: %d\n', [donor_ch; acceptor_ch]);
fprintf('ALEX period: %d  \nDonor period: %d , %d      Acceptor period: %d , %d\n', [alex_period; donor_period; acceptor_period]);

%% Compute timestamp selections
timestamps_donor = timestamps(detectors == donor_ch);
timestamps_acceptor = timestamps(detectors == acceptor_ch);

timestamps_mod = mod(timestamps, int64(alex_period));
donor_excitation = (timestamps_mod < donor_period(2)) | (timestamps_mod > donor_period(1));
acceptor_excitation = (timestamps_mod < acceptor_period(2)) & (timestamps_mod > acceptor_period(1));
timestamps_Dex = timestamps(donor_excitation);
timestamps_Aex = timestamps(acceptor_excitation);
