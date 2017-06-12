# Matlab-NestedMap

Matlab implementation for nested maps (map of maps). This class implements easy set and get access for multible keys. It is a subclass from the 'containers.Map' class. The syntax is the following: 
Generate a new MapNested object:

    NMapobj = MapNested(); %generate a new object

Write values to the Map (2 possibilites):

    %possibility 1 syntax: 
    NMapobj('key1', 'key2', 'key3') = 10; %assign value 10 to the keyList 
    NMapobj({'key1', 'key2', 'key4'}) = 5; %assign value 5 using a cell array for the keyList

    %possibility 2 - use the 'setValueNested' function 
    NMapobj = setValueNested(NMapobj, {key1, key2, key3}, 10); 
    NMapobj = setValueNested(NMapobj, {key1, key2, key4}, 5);

Retrieve values from the Map (2 possibilites):

    %possibility 1: 
    value1 = NMapobj(key1, key2, key3); %returns '10' 
    value2 = NMapobj({key1, key2, key4}); %return '5'

    %possibility 2 - using 'getValueNested' - function 
    value1 = getValueNested(NMapobj ,{key1, key2, key3}); %returns '10' 
    value2 = getValueNested(NMapobj ,{key1, key2, key4}); %returns '5'

Call superclass Methods (see containers.Map: eg isKey, keys, length, remove, size, values):

    NMapobj.superclassMethod()

Retrieve properties (see containers.Map: eg. Count, KeyType, ValueType):

    NMapobj.property

Delete Entries:
    
    NMapobj('Key') = [];
    remove(NMapobj, 'Key');

ATTENTION: Cell-arrays can not be assigned to the map

 NMapobj('key1', 'key2', 'key3') = {'a', 'cell', 'array'}; %throws error

The github-repository can be accessed via: 
https://github.com/RolandRitt/Matlab-NestedMap
