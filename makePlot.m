close all;
clear;

Amplitude = 1;
Frequency = 1;
AngularFrequency = 2 * pi * Frequency;
MaximumTime = -3 / 4;
Phase = -AngularFrequency * MaximumTime;

Period = 1 / Frequency;

DcComponent = 1 / 2;

StartTime = 0;
StopTime = 2 * Period;

Fs = 8000;

Time = StartTime:(1 / Fs):StopTime;
Signal = cos(AngularFrequency * Time + Phase) + DcComponent;

plot(Time, Signal);
xlabel('Time');
ylabel('Signal');