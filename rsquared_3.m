clear all

% Step1: Import Data from excel file

load ('AllDrops_Nocodazole_XX.mat')

a = table2array(TracksAllDrops);
a = round(a,1);
%a(1:4,:) = []; %remove rows with info

% Step2: Segment whole matrix into individual particle matrices and analyze
% individual particle tracks

k = 0;
k1 = 1;

all_rsquared = [];
all_deltat = [];

for i = 1: (length(a)-1)
    if a(i,1) == a(i+1,1)
    else
        trcklngth(k1) = i-(k+1);        
        if trcklngth(k1) > 300        %choose trancks that are longer than 10 frames; can be varied if necessary
            if trcklngth(k1) < 6000
            a1 = [];
            a1 = a(k+1:i,:);           % segment the individual particle matrix
            a2 = sortrows(a1,2);       % sort according to time points
            mean_r_squared = [];
            for deltat = 1: (size(a2,1) - 1)
                r_squared = [];
                for i2 = 1: (size(a2,1) - deltat)
                    r_squared (i2) = ((a2(deltat + i2,3)-a2(i2,3))^2 + (a2(deltat + i2,4)-a2(i2,4))^2);
                    mean_r_squared(deltat) = mean(r_squared);
                end
            end
             

            x1 = log10(1.36*(1:deltat));

            figure(1); plot(x1,log10(mean_r_squared), 'b')
            %figure(2); plot(log10(1:deltat),log10(mean_r_squared))
            hold on
            mdl = fitlm(x1(10:end),log10(mean_r_squared(10:end)));
            slope(k1) = table2array(mdl.Coefficients(2,1));
            intercept (k1) = table2array(mdl.Coefficients(1,1));
            k1 = k1+1;
            end
        end
        k = i;
        
    end
end





