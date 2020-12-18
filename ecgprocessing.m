val=load('FileName.csv');
Fs=500;
% Ts sampling period
Ts=1/Fs;
% Length of the signal
N=5000;
% Time vector
t=(0:Ts:9.999);
figure(1)
%ploting the signal
subplot(3,1,1)
plot(t,val);
ylabel('Amplitude (mV)')
title('Raw ECG')
grid on;
% Compute fft
ECG=fft(val);
% Take abs and scale it
ECG1=abs(ECG/N);
% Pick the first half
ecg=ECG1(1:N/2+1);
% Multiply by 2 (except the DC part), to compenseate
% the removed side from the spectrum.
ecg(2:end-1) = 2*ecg(2:end-1);
% Frequency range
F = Fs*(0:(N/2))/N;
%plot(F,ecg,'r')

%DTFT Magnitude and Phase Response
n=length(ECG);
k=0:n-1;
w=2*pi*k/n;


subplot(3,1,2)
plot(w/pi,angle(ECG));
xlabel('\omega(rads)');
ylabel('\angleX(\omega)');
title('DTFT Phase Respose');


%Filtering
%Low Pass Power-Line Interference 
[b,a]=cheby2(8,80,60/Fs);
x2=filtfilt(b,a,val);
tf(b,a,1/Fs)

plot(t,x2);
grid on;
ylabel('Amplitude (mV)')
title('ECG after 50/60 Hz removed')

%High Pass Baseline Wander Noise filtering

[b1,a1]=butter(8,8/Fs,'high'); 
x3=filtfilt(b1,a1,x2);
subplot(3,1,3)
tf(b1,a1,1/Fs)

plot(t,x3);
title('ECG Filtered (Baseline Noise Removed)')
xlabel('Time (s)')
ylabel('Amplitude (mV)')
grid on;