%{
Zach Swanson
12/15/17
ECEN-463 HW8
Frequency Shuffle Scrambler
%}

%Extract the audio file data
[x1, FS] = audioread('voice_samp_8k.wav');
L1 = length(x1);

%Perfom the fft to get to frequency domain
X1 = fft(x1,L1);
X1_plot = abs(fftshift(X1));
f1 = FS*((-L1/2):((L1-1)/2))/L1;
w1 = 2*pi*f1/FS;
figure
plot(w1/pi,X1_plot);

%Create keys for scrambling and descrambling
NB = 5;
key1 = (1:1:NB);
key2 = randperm(NB);

%Extract the positive freqency components
posX1 = X1(L1/2+1:end,1);
L2 = length(posX1);
L3 = floor(L2/NB);
freqBlocksIn = zeros(NB,L3);
freqBlocksOut = zeros(NB,L3);

%Break the positive frequencies into blocks
for m = 1:NB
    freqBlocksIn(m,:) = posX1(((m-1)*L3+1):(m*L3));
end

%Scramble frequency components by "shuffling"
for n = 1:length(key1)
    freqBlocksOut(key1(1,n),:) = freqBlocksIn(key2(1,n),:);
end

L5 = 2*L3*NB;
Y1 = zeros(L5,1);

%Store the scrambled frequency components
for p = 1:NB
    Y1(((p-1)*L3+1):(p*L3)) = freqBlocksOut(p,:);
end

%Create a full spectrum of frequency components
Y1 = fftshift(Y1+flip([Y1(2:end);0]));
Y1_plot = abs(fftshift(Y1));
f2 = FS*((-L5/2):((L5-1)/2))/L5;
w2 = 2*pi*f2/FS;
figure
plot(w2/pi,Y1_plot);
title("Scrambled Message Frequency Spectrum",'fontsize',16);
xlabel("Frequency (x\pi rad/sample)",'fontsize',14);
ylabel("Magnitude",'fontsize',14);

%Perform the inverse fft to return to a time domain signal
y1 = ifft(Y1,L5);
% soundsc(real(y1));
% pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%     DESCRAMBLE     %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Perform the fft on the scrambled signal to return to the freqency domain
L11 = length(y1);
Y11 = fft(y1,L11);
Y11_plot = abs(fftshift(Y11));
f11 = FS*((-L11/2):((L11-1)/2))/L11;
w11 = 2*pi*f11/FS;
figure
plot(w11/pi,Y11_plot);

%Extract the positive frequency components
posY1 = Y11(L11/2+1:end,1);
L12 = length(posY1);
L13 = floor(L12/NB);
freqBlocksIn = zeros(NB,L13);
freqBlocksOut = zeros(NB,L13);

%Break the positive frequency components into blocks and store
for m = 1:NB
    freqBlocksIn(m,:) = posY1(((m-1)*L13+1):(m*L13));
end

%"Unshuffle" the the scrambled frequency components
for n = 1:length(key1)
    freqBlocksOut(key2(1,n),:) = freqBlocksIn(key1(1,n),:);
end

L15 = 2*L13*NB;
XR = zeros(L15,1);

%Load the unscrambled blocks into an output array
for p = 1:NB
    XR(((p-1)*L13+1):(p*L13)) = freqBlocksOut(p,:);
end

%Create a full spectrum of unscrambled frequencies
XR = fftshift(XR+flip([XR(2:end);0]));
XR_plot = abs(fftshift(XR));
f12 = FS*((-L15/2):((L15-1)/2))/L15;
w12 = 2*pi*f12/FS;
figure
plot(w12/pi,XR_plot,w1/pi,X1_plot);

%Perform an inverse fft to return the unscrambled message
xr = ifft(XR,L15);
soundsc(real(xr));
figure
plot(real(x1))
hold
plot(real(xr))
