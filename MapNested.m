classdef MapNested < containers.Map & handle
    
    %(c) Roland Ritt 
    methods
        
        function obj = MapNested(varargin)
            obj = obj@containers.Map(varargin{:}); 
        end
        
        function obj = setValue1(obj, keyList, value)
            
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
        
        function value = getValue1(obj, keyList)
            
            if ~iscell(keyList)
                error('first input is no cellArray');
            end
            
            if ~obj.isKey(keyList{1})
                error(['key ''', keyList{1}, ''' is not a key'] );
                return
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