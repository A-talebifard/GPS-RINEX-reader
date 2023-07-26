clc
clear all
%% GPS <read rinex file>
% The code reads a RINEX file in MATLAB using the uigetfile and GPSfileread function
% It then stores the data in a table format
% Finally, the code converts the table to a cell array using the table2cell function.
%% written by A-Talebifard.

[name path]=uigetfile('.12o','selct rinex file','algo0010.12o');
addpath 'GPS function'\
data=GPSfileread([path name]);

dd=table2cell(data);
