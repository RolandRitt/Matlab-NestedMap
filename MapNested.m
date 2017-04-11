classdef MapNested < containers.Map & handle
    
    % A nested map container
    %
    % A MapNested object implements nested maps (map of maps).
    %
    % MapN is a handle class.
    % Since MapNested is a subclass from containers.Map, all functions from
    % containers.Map will be inherited (eg. keys, values, ...)
    %
    % Description - basic outline
    % ---------------------------
    %
    % A MapNested object is constructed like this:
    %
    %   M = MapNested();
    %
    % Values are stored using M(key1, key2, ...) = value, for example:
    %
    %   M(1, 'a')     = 'a string value';
    %   M(1, 'b')     = 287.2;
    %   M(2)          = [1 2 3; 4 5 6];
    %
    % Attention: you can not assign cell-arrays in this implementation:
    %   M(2, 'x', pi) = {'a' 'cell' 'array'}; %throws error
    %
    % another possibility is to define the keys as cell-array like:
    %   M({key1, key2, key3}) = value;
    %
    %
    % Values are retrieved using M(key1, key2, ...), for example
    %
    %   v = M(1, 'b');
    %   u = M(2);
    %
    % or with using cell-arrays for the keys
    %   v = M({key1, key2, key3});
    %
    % Set and get - methods
    % -----------------------------
    %
    % for setting and retrieving values there are also two methods
    % implemented, for setting a value:
    %
    %   MapObj = setValueNested(MapObj, {key1, key2, key3, ...}, value);
    %
    %   here the second input parameter has to be a cell-array with the
    %   keys.
    %
    % For retrieving values one can use:
    %   value = getValueNested(MapObj, {key1, key2, key3,...});
    %
    %   here the second input parameter has to be a cell-array with the
    %   keys.
    %
    %
    % Updating and removing entries
    % -----------------------------
    %
    % The value for a given key list is updated using the usual assignment;
    % the previous value is overwritten.
    %
    %   M(pi, 'x') = 1;     % 1 is current value
    %   M(pi, 'x') = 2;     % 2 replaces 1 as the value for this key list
    %
    %
    % Method call syntax
    % ------------------
    %
    % Methods of MapNested must be called using the syntax func(MapNobj, ...),
    % not MapNobj.func(...).
    %
    % Methods and properties
    % ----------------------
    %
    % MapN methods:
    %   MapNested        - constructor for MapNested objects
    %   subsref     - implements value = Mobj(keylist)
    %   subsasgn    - implements M(keylist) = value
    %   setValueNested  - implements Mobj = setValueNested(Mobj, keyList,
    %   value)
    %   getValueNested  - implements value = getValueNested(Mobj, keyList);
    %
    % See also: containers.Map
    
    % (c) 2017, Roland Ritt
    methods
        function obj = MapNested(varargin)
            % constructor, calls Superclass-constructor with varargin;
                        obj = obj@containers.Map(varargin{:});
            

        end
        
        function obj = setValueNested(obj, keyList, value)
            % method which recursively constructs a map of maps and add
            % a a value at the specified keys
            %
            % Implements the syntax
            %
            %   MapNestedObj = setValueNested(MapNestedObj, keyList,
            %   value);
            %       (keyList is of type 'CellArray')
            %
            % See also: MapNested, MapNested/setValueNested
            if ~iscell(keyList)
                %check if the keyList is a cell array
                error('second input (keylist) is no cellArray');
            end
            
            KeyType = class(keyList{1});
            %find the class-type of first key
            if length(keyList)==1
                % check if the object is defined
                if isempty(obj)
                    %if the object does not exist...
                    obj = MapNested('KeyType', KeyType,'ValueType', 'any');
                    % generate a new MapNested-object with the specified
                    % key-Type, and default ValueType set to 'any'
                    obj = [obj;MapNested(keyList{1},value)];
                    % concatenate the two objects
                else
                    %if the object exists, concatenate to add the new value
                    obj = [obj; MapNested(keyList{1}, value)];
                end
                return
            else
                % if more than one key
                if obj.isKey(keyList{1})
                    % check if the key is in the map
                    temp = values(obj, keyList(1));
                    temp = temp{1};
                    % retrieve the MapNested-object from the map
                    if ~isa(temp ,'containers.Map')
                        % if the value is not a MapObject, generate a new
                        % one
                        temp = MapNested('KeyType', KeyType,'ValueType', 'any');
                    end
                    
                else
                    % if the key does not exist, generate a new
                    % MapNested-object
                    temp = MapNested('KeyType', KeyType,'ValueType', 'any');
                    
                end
                temp = setValueNested(temp, keyList(2:end), value);
                % set the value in the MapNested-object (recursive call)
                
                if isempty(obj)
                    %if obj is empty, generate a new MapNested-object
                    obj = MapNested(keyList{1}, temp);
                else
                    %if obj exists, concatenate the new entry
                    obj = [obj;MapNested(keyList{1}, temp)];
                end
                
            end
            
        end
        
        function value = getValueNested(obj, keyList)
            % method for retrieving values from a MapNested object by
            % recursively calls to this method
            %
            % Implements the syntax
            %
            %   value = getValueNested(MapNestedObj, keyList, value);
            %       (keyList is of type 'CellArray')
            %
            % See also: MapNested, MapNested/setValueNested
            if ~iscell(keyList)
                %check if the keyList is a cellArray
                error('second input is no cellArray');
            end
            
            if ~obj.isKey(keyList{1})
                %check if the first key is in the list, if not, throw an
                %error (maybe should be changed to empty object)
                error(['key ''', keyList{1}, ''' is not a key'] );
            end
            if length(keyList)==1
                % if the keyList is only of length 1, return the value of
                % this list
                value = values(obj, {keyList{1}});
                % call the method from the superclass
                value=value{1}; %retrieve the value
                return
            else
                % if there are more than one keys Left in the keyList
                temp = values(obj, {keyList{1}});
                % retrieve the MapNested object (key1)
                temp = temp{1};
                if ~isa(temp ,'containers.Map')
                    % if the retrieved value is not a Map, the
                    % MapNested object was misused --> throw error message
                    error(['key ''', keyList{2}, ''' is not a key'] );
                end
                value = getValueNested(temp, keyList(2:end));
                % recursively call the getValueNested method.
                
                
            end
            
        end
        
        function v = subsref(M, S)
            % returns value associated with key list
            %
            % Implements the syntax
            %
            %   value = MapNobj(key1, key2, ...)
            %
            % See also: MapNested, MapNested/subsasgn
            
            if ~isscalar(S) || ~strcmp(S.type, '()') || length(S)<1
                error('MapNested:Subsref:LimitedIndexing', ...
                    'Only ''()'' indexing is supported by a MapNested');
            end
            
            
            
            try
                
                if iscell(S.subs{1})
                    temp = S.subs{1};
                else
                    temp = S.subs;
                end
                v = getValueNested(M, temp);
            catch me
                % default is handled in subsrefError for efficiency
                error('MapNested:Subsref:IndexingError', ...
                    'Something went wrong in indexing');
            end
        end
        
        
        function M = subsasgn(M, S, v)
            % sets value associated with key list
            %
            % Implements the syntax
            %
            %   MapNobj(key1, key2, ...) = value
            %
            % See also: MapNested, MapNested/subsasgn
            
            if ~isscalar(S) || ~strcmp(S.type, '()') || length(S)<1
                error('MapNested:Subsasgn:LimitedIndexing', ...
                    'Only ''()'' indexing is supported by a MapNested');
            end
            
            
            
            try
                
                if iscell(S.subs{1})
                    temp = S.subs{1};
                else
                    temp = S.subs;
                end
                M = setValueNested(M, temp, v);
            catch me
                % default is handled in subsrefError for efficiency
                error('MapNested:Subsasgn:IndexingError', ...
                    'Something went wrong in indexing');
            end
        end
        
    end
    
end