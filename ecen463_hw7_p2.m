%{
Problem 2: Fast Convolution on a Data Stream

Demonstrate Fast Convolution on a data stream by performing either
overlap-add or overlap-save on a large input stream of data.

Please make your FIR filter at least 1000 taps and do at least 10 blocks of
data from your large input stream of data.

You can use random noise at the input and the FIR filter choice is up to
you. The FFT length is also up to you, but should be >= two times the
number of filter coefficients.

I want you to code the algorithm you choose yourself -- do not hand in
Matlab code you found online. As a hint: try small, nontrivial values of N,
L, and P as you debug, then use the large values I ask for above. N should
be a power of two, and P is the filter length. L = N - P +1.

To verify your code, compare the output between your implementation and
direct convolution by using the built-in filter() command (or conv() ). Try
looking at the maximum absolute difference between the two filtered
datasets (see max() and abs()).

Please hand in a short description of your program, comments about
differences between your output and direct convolution, some informative
plots, and your original code.
%}

%Arbitrary specs
Fs = 8000;
fco = 1000;
wco = 2*fco/Fs;

%Select N and P, calculate L values, and specify number of blocks
P = 2000;
N = 2^12;
L = N-P+1;
NB = 10;

%Create a Hamming Window Filter with 2000 coefficients
h = fir1(P-1,wco);
H = fft(h,N);

%Specify size of large input stream, randn to generate random noise input
%Calculate number of blocks to look at all data (optional)
inLen = 10^6;
x = randn(1,inLen);
% NB = floor(inLen/L);

%Initialize NBxN array to store sample blocks
%Initialize 1x(NB*L) array to store output
x1 = zeros(NB,N);
y = zeros(1,NB*L);

%For the number of signal blocks specified
for b1 = 1:NB
    %Check to see if the current block is the first block
    if b1 == 1
        %Pad with P-1 zeros
        for a1 = 1:L
            x1(1,a1+(P-1)) = x(1,a1);
        end
    else
        %Take last P-1 data from previous block
        %and place as first P-1 data for this block
        for b2 = 1:(P-1)
            x1(b1,b2) = x1((b1-1),L+b2);
        end

        %Fill remaining points with next data from input stream
        for b3 = 1:L
            x1(b1,b3+(P-1)) = x(1,(b1-1)*L+b3);
        end
    end

    % Perform DFT on current sample
    % Multiply element by element with filter coefficients (i.e. fast
    % convolution)
    % Perform inverse DFT to get time domain convolution
    X1 = fft(x1(b1,:),N);
    Y1 = X1.*H;
    y1 = ifft(Y1,N);

    % Discard first (P-1) output points, include next L output points at
    % the end of the ouput array (y)
    for c1 = 1:L
        y(1,(b1-1)*L+c1) = y1(1,(P-1)+c1);
    end
end

% Use filter() to convolve the input data stream (x) with the filter (h)
z = filter(h,1,x(1:NB*L));

% Subtract the elements of filter() output (z) from implemented algorithm
% output(z) and find the max absolute difference (MAD)(should be in the
% range of 10^-15 to 10^-13)
diff = y - z;
MAD = max(abs(diff))

figure
subplot(3,1,1)
plot(y,'g','LineWidth',1)
title("Output via Algorithm",'FontSize',16)
xlabel("No. of Samples",'FontSize',14)
ylabel("Magnitude", 'FontSize',14)
axis([2*L+1 3*L min(y) max(y)])

subplot(3,1,2)
plot(z,'r','LineWidth',1)
title("Output via filter(*)",'FontSize',16)
xlabel("No. of Samples",'FontSize',14)
ylabel("Magnitude", 'FontSize',14)
axis([2*L+1 3*L min(z) max(z)])

subplot(3,1,3)
plot(diff,'LineWidth',1)
title("Algorithm & filter(*) Difference",'FontSize',16)
xlabel("No. of Samples",'FontSize',14)
ylabel("Magnitude", 'FontSize',14)
axis([2*L+1 3*L min(diff) max(diff)])

figure
subplot(2,1,1)
plot(f1,Y,'g','LineWidth',1)
title("Frequency Response via Algorithm",'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude (dB)", 'FontSize',14)
axis([0 fco*2 min(Y) max(Y)])

subplot(2,1,2)
plot(f1,Z,'r','LineWidth',1)
title("Frequency Response via filter(*)",'FontSize',16)
xlabel("Frequency (Hz)",'FontSize',14)
ylabel("Magnitude (dB)", 'FontSize',14)
axis([0 fco*2 min(Z) max(Z)])f1 = Fs*((-N/2):((N-1)/2))/N;
Y = 20*log10(abs(fftshift(fft(y,N)))/N);
Z = 20*log10(abs(fftshift(fft(z,N)))/N);
