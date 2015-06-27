%
% This script shows how to read ns-ALEX data stored in a Photon-HDF5 file.
%
% MATLAB R2011b or more recent is required.
%

filename = '../data/Pre.hdf5';


%% Read the data
timestamps = h5read(filename, '/photon_data/timestamps');
timestamps_unit = h5read(filename, '/photon_data/timestamps_specs/timestamps_unit');
detectors = h5read(filename, '/photon_data/detectors');
nanotimes = h5read(filename, '/photon_data/nanotimes');
tcspc_unit = h5read(filename, '/photon_data/nanotimes_specs/tcspc_unit');
tcspc_num_bins = h5read(filename, '/photon_data/nanotimes_specs/tcspc_num_bins');

% Read the TITLE attribute in timestamps (containing the array description)
timestamps_desc = h5readatt(filename, '/photon_data/timestamps', 'TITLE');

donor_ch = h5read(filename, '/photon_data/measurement_specs/detectors_specs/spectral_ch1');
acceptor_ch = h5read(filename, '/photon_data/measurement_specs/detectors_specs/spectral_ch2');

laser_rep_rate = h5read(filename, '/photon_data/measurement_specs/laser_repetition_rate');
donor_period = h5read(filename, '/photon_data/measurement_specs/alex_excitation_period1');
acceptor_period = h5read(filename, '/photon_data/measurement_specs/alex_excitation_period2');

%% Print data summary
fprintf('Number of photons: %d\n', size(timestamps));
fprintf('Timestamps unit:   %.2e seconds\n', timestamps_unit);
fprintf('TCSPC unit:        %.2e seconds\n', tcspc_unit);
fprintf('TCSPC number of bins:    %d\n', tcspc_num_bins);
fprintf('Detectors:         %s\n', unique(detectors));
fprintf('Donor CH: %d     Acceptor CH: %d\n', [donor_ch; acceptor_ch]);
fprintf('Laser repetion rate:     %d  \nDonor period:    %d, %d      \nAcceptor period: %d, %d\n', ...
        [laser_rep_rate; donor_period; acceptor_period]);

%% Select nanotimes
nanotimes_donor = nanotimes(detectors == donor_ch);
nanotimes_acceptor = nanotimes(detectors == acceptor_ch);

%% Plot TCSPC histogram
bin_centers = [0:1:double(tcspc_num_bins)-1] + 0.5;
[tcspc_counts_d, bin_centers] = hist(nanotimes_donor, bin_centers);
[tcspc_counts_a, bin_centers] = hist(nanotimes_acceptor, bin_centers);

semilogy(bin_centers, tcspc_counts_d, 'g');
hold on;
semilogy(bin_centers, tcspc_counts_a, 'r');

title('TCSPC histogram')
xlabel('Nanotimes');
legend('donor','acceptor');
