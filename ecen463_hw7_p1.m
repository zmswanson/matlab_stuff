%{
Problem 1 -- zero padding and nonexact frequencies

Assume an underlying sample rate of 8kHz.

Generate a sinusoid with an exact integer number of cycles in 128 samples
(i.e. x[n+128] = x[n]).

Plot the DFT magnitude of 128 samples, 256 samples, 128 samples padded with
128 zeros (256 points total), and 128 samples padded with 896 zeros (1024
points total). (Use a four-in-one plot -- try subplot()).

Now generate another sinusoid but change the frequency so that there is not
an exact integer number of cycles in 128 samples, but the frequency is
similar to the previous case.

Plot the DFT magnitude of 128 samples, 256 samples, 128 samples padded with
128 zeros (256 points total), and 128 samples padded with 896 zeros (1024
points total). (Use a four-in-one plot).

Briefly describe your results in a couple of typed paragraphs.
%}

%Sample frequency = 8 kHz
Fs = 8000;
Ts = 1/Fs;
Fc1 = Fs / 16;
Fc2 = Fs / 15;

%Produce a signal that is 1000 samples long
L = 1000;
n = (0:L - 1);
x = sin(2*pi*(Fc1/Fs)*n);
y = sin(2*pi*(Fc2/Fs)*n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s1 = 128;
f1 = Fs*((-s1/2):((s1-1)/2))/s1;
X1 = abs(fftshift(fft(x,s1)))/s1;
Y1 = abs(fftshift(fft(y,s1)))/s1;

s2 = 256;
f2 = Fs*((-s2/2):((s2-1)/2))/s2;
X2 = abs(fftshift(fft(x,s2)))/s2;
Y2 = abs(fftshift(fft(y,s2)))/s2;

s3 = 256;
f3 = Fs*((-s3/2):((s3-1)/2))/s3;
X3 = abs(fftshift(fft(x(1:128),s3)))/s3;
Y3 = abs(fftshift(fft(y(1:128),s3)))/s3;

s4 = 1024;
f4 = Fs*((-s4/2):((s4-1)/2))/s4;
X4 = abs(fftshift(fft(x(1:128),s4)))/s4;
Y4 = abs(fftshift(fft(y(1:128),s4)))/s4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(2,2,1)
plot(f1,X1,'LineWidth',1.5)
axis([-1500 1500 0 max(X1)])
title("Specific f 128 Point DFT",'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

subplot(2,2,2)
plot(f2,X2,'LineWidth',1.5)
axis([-1500 1500 0 max(X2)])
title("Specific f 256 Point DFT",'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

subplot(2,2,3)
plot(f3,X3,'LineWidth',1.5)
axis([-1500 1500 0 max(X3)])
title(["Specific f 256 Point DFT";"128 Padded Zeros"],'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

subplot(2,2,4)
plot(f4,X4,'LineWidth',1.5)
axis([-1500 1500 0 max(X4)])
title(["Specific f 1024 Point DFT";"896 Padded Zeros"],'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(2,2,1)
plot(f1,Y1,'LineWidth',1.5)
axis([-1500 1500 0 max(Y1)])
title("Non-Specific f 128 Point DFT",'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

subplot(2,2,2)
plot(f2,Y2,'LineWidth',1.5)
axis([-1500 1500 0 max(Y2)])
title("Non-Specific f 256 Point DFT",'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

subplot(2,2,3)
plot(f3,Y3,'LineWidth',1.5)
axis([-1500 1500 0 max(Y3)])
title(["Non-Specific f 256 Point DFT";"128 Padded Zeros"],'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)

subplot(2,2,4)
plot(f4,Y4,'LineWidth',1.5)
axis([-1500 1500 0 max(Y4)])
title(["Non-Specific f 1024 Point DFT";"896 Padded Zeros"],'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude",'FontSize',14)
