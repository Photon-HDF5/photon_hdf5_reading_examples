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

% Read the TITLE attribute in timestamps (containing the array description)
timestamps_desc = h5readatt(filename, '/photon_data/timestamps', 'TITLE');

donor_ch = h5read(filename, '/photon_data/measurement_specs/detectors_specs/spectral_ch1');
acceptor_ch = h5read(filename, '/photon_data/measurement_specs/detectors_specs/spectral_ch2');

alex_period = h5read(filename, '/photon_data/measurement_specs/alex_period');
offset = h5read(filename, '/photon_data/measurement_specs/alex_offset');
donor_period = h5read(filename, '/photon_data/measurement_specs/alex_excitation_period1');
acceptor_period = h5read(filename, '/photon_data/measurement_specs/alex_excitation_period2');

%% Print data summary
fprintf('Number of photons: %d\n', size(timestamps));
fprintf('Timestamps unit:   %.2e seconds\n', timestamps_unit);
fprintf('Detectors:         %s\n', unique(detectors));
fprintf('Donor CH: %d     Acceptor CH: %d\n', [donor_ch; acceptor_ch]);
fprintf('ALEX period: %d \nOffset: %d \nDonor period: %d , %d      Acceptor period: %d , %d\n', [alex_period; offset; donor_period; acceptor_period]);


%% Compute timestamp selections
timestamps_donor = timestamps(detectors == donor_ch);
timestamps_acceptor = timestamps(detectors == acceptor_ch);

timestamps_mod = mod(timestamps - int64(offset), int64(alex_period));
donor_excitation = (timestamps_mod < donor_period(2)) & (timestamps_mod > donor_period(1));
acceptor_excitation = (timestamps_mod < acceptor_period(2)) & (timestamps_mod > acceptor_period(1));

% Create modulus array
timestamps_Dex = timestamps(donor_excitation);
timestamps_Aex = timestamps(acceptor_excitation);


%% Plot ALEX histogram
% NOTE: If Matlab version is earlier than R2014b, use the following code:

% Plotting the alternation histogram

nbins = 100;
acceptor = double(mod(timestamps_acceptor-int64(offset),int64(alex_period)));
donor = double(mod(timestamps_donor-int64(offset),int64(alex_period)));

figure(1)
[nb_donor,xb_donor] = hist(donor,nbins);
[nb_acceptor,xb_acceptor] = hist(acceptor,nbins);

bar(xb_acceptor,nb_acceptor,'facecolor','green');
hold on;
bar(xb_donor,nb_donor,'facecolor','red');

title('ALEX histogram')
xlabel('(timestamps - offset) MOD alex\_period');
legend('donor','acceptor');

% Timestamps in different excitation periods

nbins_ex = [0:40:double(alex_period)];
Aex = double(mod(timestamps_Aex-int64(offset),int64(alex_period)));
Dex = double(mod(timestamps_Dex-int64(offset),int64(alex_period)));

figure(2)
[nb_Dex,xb_Dex] = hist(Dex,nbins_ex);
[nb_Aex,xb_Aex] = hist(Aex,nbins_ex);

bar(xb_Dex,nb_Dex,'facecolor','green');
hold on;
bar(xb_Aex,nb_Aex,'facecolor','red');

title('ALEX histogram (selected periods only)')
xlabel('(timestamps - offset) MOD alex\_period');
legend('D\_ex','A\_ex');

%% NOTE: If Matlab version is R2014b or later, use the following code:
%
% % Plotting the alternation histogram
% nbins = 100;
% acceptor = mod(timestamps_acceptor-int64(offset),int64(alex_period));
% donor = mod(timestamps_donor-int64(offset),int64(alex_period));
%
% figure(1)
% histogram(acceptor,nbins,'facecolor','green');
% hold on;
% histogram(donor,nbins,'facecolor','red');
%
% title('ALEX histogram')
% xlabel('(timestamps - offset) MOD alex\_period');
% legend('donor','acceptor');
%
% % Timestamps in different excitation periods
% nbins_ex = 40;
% Dex = mod(timestamps_Aex-int64(offset),int64(alex_period));
% Aex = mod(timestamps_Dex-int64(offset),int64(alex_period));
%
% figure(2)
% histogram(Dex,nbins_ex,'facecolor','red');
% hold on;
% histogram(Aex,nbins_ex,'facecolor','green');
%
% title('ALEX histogram (selected periods only)')
% xlabel('(timestamps - offset) MOD alex\_period');
% legend('D\_ex','A\_ex');
