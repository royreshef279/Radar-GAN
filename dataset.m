

% Radar parameters
N = 16;
waveforms = {'chu', 'golomb'};
G = .8;
fc = 2e9; % 2GHz
c = 3e8; % meters/second
lambda = c/fc;
Pt = 1e4; %watts
B = 1e5; %100KHz
fs = 2*B;
PRF = 12000;

% Clutter related parameters
% tau,L,B,sigma0, rho,zeta,phi,
Horizontal_C = [-72.76 21.11 24.78 4.917 0.6216 0.02949 26.19 0.09345 0.05031];
Vertical_C = [-48.56 26.30 29.05 -0.5183 1.057 0.04839 21.37 0.07466 0.04623];
rho =N;
L = 1;
%phi = [1.9 1.2 .8]; %degree for 2,3,4 GHz
phi = 1.9; %degree for 2 GHz
tau = rho/B; % we know that: rho = B*tau;

%radar clutter
theta0 = pi*1/180;
SS = 1:5; % sea state
C = Horizontal_C;
for ri = 1-N:N-1
    temp = ones(N-abs(ri),1);
    J(:,:,ri+N)= diag(temp,ri);
end

% target parameters
R = [5e2,5e3,5e4,Inf];
rcs_sep = 3; % or 2 would be a good choice
rcs_low_flying = [1,3:rcs_sep:30];
rcs_surface = 1:rcs_sep:10;
target_mode = {'surface', 'low_flying'};
all_rcs = {rcs_surface,rcs_low_flying};
velocity_sep = 5;
vel_low_flying = [1,5:velocity_sep:50];
vel_surface = [1,5:velocity_sep:20];
velocity = [vel_low_flying,vel_surface];
number_of_thetas = 10;
theta = 2*pi * rand(number_of_thetas,1);

% Noise Parameters

Delta_f = 1.11*fs;
sigma2dbm = -174+10*log10(Delta_f);
sigma2 = db2mag(sigma2dbm)*1e-3;
sigma = sqrt(sigma2);

counter = 1;
%output = [];
for waveform_counter = 1:length(waveforms)
    for R_counter = 1:length(R)
        for mode_counter = 1:length(target_mode)
            out.target_mode = target_mode(mode_counter);
            rcs = cell2mat(all_rcs(mode_counter));
            for rcs_counter = 1:length(rcs)
                for vel_counter = 1:length(velocity)
                    for theta_counter =1:length(theta)
                        for sea_state = SS
                            out.waveform = waveforms{waveform_counter};
                            out.range = R(R_counter);
                            out.rcs = rcs(rcs_counter);
                            out.vel = velocity(vel_counter);
                            out.theta = theta(theta_counter);
                            out.sea_state = sea_state;
                            out.rcs = rcs(rcs_counter);
                          
                            out.alpha = sqrt(Pt*G^2*lambda^2*out.rcs/(out.range)^4 *(4*pi)^2);
                            out.nu_T = 2 * out.vel*cos(out.theta)*fc/(fs*c) ;
                            sigma0 = db2pow( C(1)+C(2)*log10(sin(out.theta))+ ...
                            ((C(3)+C(4)*out.theta ) * log10(fc))/(1+C(5)*out.theta+C(6)*sea_state) +C(7) * (1+sea_state)^( 1/(2+C(8)*out.theta+C(9)*sea_state)));
                            if (strcmp(out.waveform, 'chu'))
                                out.s = Chu(N);
                            elseif (strcmp(out.waveform,'golomb'))
                                out.s = golomb(N);
                            else
                                error('unfamiliar waveform')
                            end
                            Pcr = (rho * Pt * G^2 * lambda^2 * phi * c * sigma0)/(2*B *(4*pi*out.range)^3 * L);
                            n = sigma * randn(N,1);
                            p = p_func(out.nu_T,N);
                            d = zeros(N,1);
                            ii = 1;
                            Rho = [];
                            while(ii<=1)
                                Nt = randi(20); % better option might be randomly chosen
                                abs_rho = sqrt(Pcr/(5*Nt))*randn(Nt,1)+ sqrt(Pcr/Nt);
                                temp = Pcr-norm(abs_rho(1:end-1))^2;
                                if(0<=temp)
                                    abs_rho(end) = sqrt(temp);
                                    Nts(ii) = Nt;
                                    rho_i = abs_rho.*exp(1i*2*pi*rand(size(abs_rho)));
                                    ii = ii +1;
                                    nu_hat = 1/(sea_state+1) * rand(Nt,1);

                                    for ri = 1:Nt
                                        eps_i = min(nu_hat(ri),1-nu_hat(ri))*rand;
                                        nu_i = 2*eps_i*rand+nu_hat(ri)-eps_i;
                                        d = d+rho_i(ri)*squeeze(J(:,:,ri)) * (out.s.*p_func(nu_i,N));
                                    end
                                    out.r = out.alpha * out.s .* p + d+n;
                                    if out.alpha
                                        out.label='present';
                                    else
                                        out.label='absent';
                                    end

                                    %The following lines takes time for computation,
                                    %comment it if you need fast computation
                                    % out.ambg=ambgfun(out.r,fs,PRF);
                                    % ambg(counter,:,:) = out.ambg;
                                    
                                    output(counter) = out;
                                    counter = counter + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
%save('adversarial_radar_data_no_amb.mat','out')
 save('adversarial_radar_data.mat','output')
Chu(16)
function p = p_func(nu,N)
p = exp(1i* 2 * pi * [0:N-1] * nu).';
end


function x = golomb(N)
 % x = golomb(N), generate a Golomb sequence x of length N

 alpha = exp(1i * 2*pi /N);
 exponent = (0:(N-1))' .* (1:N)' / 2;
 x = alpha.^exponent;
end

function x = Chu(N)

    chu = zeros(N,1);
    for j = 0:N-1
    
        if mod(j,2) == 0
            chu(j+1) = exp(1i*2*pi*(j^2/(2*N)));
        else
            chu(j+1) = exp(1i*2*pi*(j*(j+1)/(2*N)));
        end
    end
    x = chu;
end

