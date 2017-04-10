classdef MapNested < containers.Map & handle
    % A nested map container
    %
    % A MapNested object implements nested maps (map of maps).
    %
    % MapN is a handle class.
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
    %   M(2, 'x', pi) = {'a' 'cell' 'array'};
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
    
    %(c) Roland Ritt, 04.2017 
    methods
        
        function obj = MapNested(varargin)
            obj = obj@containers.Map(varargin{:}); 
        end
        
        function obj = setValueNested(obj, keyList, value)
            
            if ~iscell(keyList)
                error('first input is no cellArray');
            end
            
            KeyType = class(keyList{1});
            if length(keyList)==1
                
                if isempty(obj)
                    obj = MapNested('KeyType', KeyType,'ValueType', 'any');
                    obj = [obj;MapNested(keyList{1},value)];
                else
                    obj = [obj; MapNested(keyList{1}, value)];
                end
                return
            else
                
                if obj.isKey(keyList{1})
                    temp = values(obj, keyList(1));
                    temp = temp{1};
                    if ~isa(temp ,'containers.Map')
                        temp = MapNested('KeyType', KeyType,'ValueType', 'any');
                    end
                    
                else
                    temp = MapNested('KeyType', KeyType,'ValueType', 'any');
                    
                end
                temp = setValue1(temp, keyList(2:end), value);
                
                if isempty(obj)
                    obj = MapNested(keyList{1}, temp);
                else
                    obj = [obj;MapNested(keyList{1}, temp)];
                end
                
            end
            
        end
        
        function value = getValueNested(obj, keyList)
            
            if ~iscell(keyList)
                error('first input is no cellArray');
            end
            
            if ~obj.isKey(keyList{1})
                error(['key ''', keyList{1}, ''' is not a key'] );
            end
            if length(keyList)==1
                value = values(obj, {keyList{1}});
                value=value{1};
                return
            else
                
                temp = values(obj, {keyList{1}});
                temp = temp{1};
                if ~isa(temp ,'containers.Map')
                    error(['key ''', keyList{2}, ''' is not a key'] );
                end
                value = getValue1(temp, keyList(2:end));
                
                
                
            end
            
        end
        
        function v = subsref(M, S)
            % returns value associated with key list
            %
            % Implements the syntax
            %
            %   value = MapNobj(key1, key2, ...)
            %
            % See also: MapN, MapN/subsasgn, MapN/values
            
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
                v = getValue1(M, temp);
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
            % See also: MapN, MapN/subsasgn, MapN/values
            
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
                M = setValue1(M, temp, v);
            catch me
                % default is handled in subsrefError for efficiency
                error('MapNested:Subsasgn:IndexingError', ...
                    'Something went wrong in indexing');
            end
        end
        
    end
    
end