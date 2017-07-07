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

if (testMap('A')~=5)
    error('Test ''A'' went wrong');
end


if (testMap('C', 'd', 1, 'u')~= 'hallo')
    error('Test ''C d 1 i'' went wrong');
end


if (testMap({'C', 'd', 1, 'v'}) ~= 'servus')
    error('Test ''C d 1 v'' went wrong');
end


if ~isKey(testMap, {'C', 'd'})
    error('test is Key');
end


if isKey(testMap, {'C', 'f'})
    error('test is Key');
end

if isKey(testMap, {'C', 'f', 'g', 'h'})
    error('test is Key');
end

if isKey(testMap, {'E', 'f', 'g', 'h'})
    error('test is Key');
end


testMap = setValueNested(testMap, {'ad', 'c'}, 7);
testMap = setValueNested(testMap, {'ad', 'e'}, 8);


if (getValueNested(testMap, {'ad', 'c'}) ~= 7)
    error('Test ''ad c'' went wrong');
end
if (getValueNested(testMap, {'ad', 'e'})~= 8)
    error('Test ''ad e'' went wrong');
end

% override value ('A' = 5, with a map)
testMap = setValueNested(testMap, {'A', 'x'}, 10);


keys(testMap)


if getValueNested(testMap, {'A', 'x'}) ~= 10
    error('Test ''A x'' went wrong');
end

try
    val5 = getValueNested(testMap, {'B', 'x'});
    
catch ME
    if ME.message ~= 'key ''B'' is not a key'
        error('Test wrong key went wrong');
    end
    
    
end

if ~isequal(keys(testMap),{'A', 'C', 'ad'})
    error('Test ''keys'' function went wrong');
end


if ~isequal(keys(testMap('C')) ,{'d'})
    error('Test ''keys'' function went wrong');
end

try
    values(testMap('C'));
catch
    error('Test ''values'' function went wrong');
end

% test remove Key
testMap('C') = [];

if ~isequal(keys(testMap),{'A', 'ad'})
    error('Test remove when assigning an empty array went wrong');
end

remove(testMap, 'A')

if ~isequal(keys(testMap),{ 'ad'})
    error('Test remove when use remove function went wrong');
end



M = MapNested();


M(1, 'a')     = 'a string value';
M(1, 'b')     = 287.2;
M(2)          = [1 2 3; 4 5 6];
try
    M(2, 'x', pi) = {'a' 'cell' 'array'};
catch ME
    if ~isequal(ME.message, 'Something went wrong in indexing')
        error('Test assign cell array went wrong');
    end
end



try
    M('s') = 4;
catch ME
    if ~isequal(ME.message, 'Something went wrong in indexing')
        error('Test assign cell array went wrong');
    end
end



if ~isequal(M.keys, {1,2})
    error('Test ''.''-assignment went wrong');
end
if ~isequal(M.values{2} , [1 2 3; 4 5 6])
    error('Test ''.''-assignment went wrong');
end