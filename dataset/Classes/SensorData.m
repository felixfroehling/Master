classdef SensorData
    %SENSORDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Timestamp
        Detections
    end
    
    methods
        function obj = SensorData(ts, detect)
            %SENSORDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.Timestamp = ts;
            obj.Detections = detect;
        end
        
    end
end

