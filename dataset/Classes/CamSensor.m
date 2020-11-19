classdef CamSensor
    %SENSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Parameters
        Object
        Data
    end
    
    methods
        function obj = CamSensor(file)
            %SENSOR Construct an instance of this class
            %   Detailed explanation goes here
            param = load(file);
            param = param.cameraParams;
            obj.Parameters = param;
            obj.Object = monoCamera(obj.Parameters.Intrinsics, 1.3, 'WorldUnits', 'meters');
        end
       
        function obj = set.Data(obj, data)
            obj.Data = data;
        end
        
    end

end

