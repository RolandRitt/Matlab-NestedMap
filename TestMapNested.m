%% TestNestedMap.m
% 
% Description : Quick and dirty script for testing 'MapNested'-class.
% Simple syntax test/presentation of the class
%
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{10 April 2017}{Original}
%
% --------------------------------------------------
% (c) 2017, Roland Ritt

clear
close all hidden
clc;



testMap = MapNested(); % create new MapNested- object
% assign values to keys
testMap('A') = 5;
testMap('C', 'd', 1, 'u') = 'hallo';
testMap({'C', 'd', 1, 'v'}) = 'servus';

% retrieve values
testMap('C', 'd', 1, 'u')
testMap({'C', 'd', 1, 'v'})


testMap = setValueNested(testMap, {'ad', 'c'}, 7);
testMap = setValueNested(testMap, {'ad', 'e'}, 8);

% override value ('A' = 5, with a map)
testMap = setValueNested(testMap, {'A', 'x'}, 10);
val1 = getValueNested(testMap, {'ad', 'e'});

val2 = getValueNested(testMap, {'ad', 'c'})
val3 = getValueNested(testMap, {'A'});

val4 = getValueNested(testMap, {'A', 'x'});

try
val5 = getValueNested(testMap, {'B', 'x'});

catch ME
    
    disp(ME.message)
    
end

keys(testMap)
keys(testMap('C'))
values(testMap('C'))