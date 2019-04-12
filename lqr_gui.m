classdef lqr_gui < handle
    %LQR_GUI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        %% LQR controller tuning software parameters
        % rho
        RHO_MIN = -1;
        RHO_MAX = 4;
        dRHO = 0.01;
        % to be initiated in the constructor algorithm
        Q0
        R0
        
        %% poles
        % hover
        poles_Real_hover
        poles_Imag_hover
        
        %% figure and axis handles
        figHandle
        axHoverHandle
        
        %% UI slider handles
        slideRho
        
        %% variables
        rho
        
    end
    
    methods
        
        function obj = lqr_gui(A,B,C,D,Qo,Ro)
            
            %% init figure and axis for plotting root loci
            obj.figHandle = figure;
            obj.axHoverHandle = axes('Parent',obj.figHandle,'position',[0.05 0.25  0.90 0.70]);
            plot(obj.axHoverHandle, [0], [0], 'x');
            xlim(obj.axHoverHandle, [-10 1]);
            ylim(obj.axHoverHandle, [-10 10]);
            bgcolor = obj.figHandle.Color;
            
            %% init UI slider for rho
            min = obj.RHO_MIN; 
            max = obj.RHO_MAX;
            N = length(obj.RHO_MIN:obj.dRHO:obj.RHO_MAX);
            obj.slideRho = uicontrol('Parent',obj.figHandle,'Style','slider','Units','normalized','Position',[0.05,0.05,0.90,0.05],...
              'value',min, 'min',min, 'max',max, 'SliderStep', obj.dRHO/(max-min)*[1 1]);
            obj.rho = 10^min;
            bgcolor = obj.figHandle.Color;
            obj.slideRho.Callback = @(es,ed) obj.update_rho(10^es.Value);
            uicontrol('Parent',obj.figHandle,'Style','text','Units','normalized','Position',[0.05 0.10 0.25 0.05],...
                'String','rho:','BackgroundColor',bgcolor);
            
            %% common set-up for root loci computation
            obj.Q0 = Qo;
            obj.R0 = Ro;
            
            %% compute hover root loci
            
            % init data structure for keeping all root locus poles
            obj.poles_Real_hover = zeros(length(Qo),length(obj.RHO_MIN:obj.dRHO:obj.RHO_MAX));
            obj.poles_Imag_hover = zeros(length(Qo),length(obj.RHO_MIN:obj.dRHO:obj.RHO_MAX));
            
            % loop through all rho and ki to precompute close-loop poles
            % for all gains
            rho_i = 1;
            for rho = obj.RHO_MIN:obj.dRHO:obj.RHO_MAX
                Q = Qo ;                 
                R = (10^rho)*Ro;
                [K,S,~] = lqr(A,B,Q,R);
                sys = ss(A-B*K,0*B,C,0*B);
                obj.poles_Real_hover(:,rho_i) = real(pole(sys));
                obj.poles_Imag_hover(:,rho_i) = imag(pole(sys));
                rho_i = rho_i + 1;
            end
            
            
            %% intial plot to the screen
            obj.EDPplot();
            
        end
        
        function update_rho(obj,rho)
            obj.rho = rho;
            obj.EDPplot();
        end
        
        function EDPplot(obj)
            
            %% plotting parameters
            % root loci color
            LGRCOLOR = 'gx';
            ROOTCOLOR = 'ko';
            
            %% set current working figure
            figure(obj.figHandle);
            
            %% set axis limits for the overall plot and release the plot
            
            %% finally, we print in the screen state of the drone
            clc;
            disp(['rho =      ', num2str(obj.rho    )]);
            
            %% plot hover loci
            obj.figHandle.CurrentAxes = obj.axHoverHandle;
            xlim(obj.axHoverHandle, [-6 1]);
            ylim(obj.axHoverHandle, [-6 6]);
            hold('on');
            cla;
            
            % accumulate pole points in a single vector
            acum = zeros(2,length(obj.poles_Real_hover(:,1,1))*length(obj.RHO_MIN:obj.dRHO:obj.RHO_MAX));
            i_dumb = 1;
            for i = 1:length(obj.RHO_MIN:obj.dRHO:obj.RHO_MAX)
                for j = 1:length(obj.poles_Real_hover(:,1,1))
                    acum(:,i_dumb) = [obj.poles_Real_hover(j,i,1); obj.poles_Imag_hover(j,i,1)];
                    i_dumb = i_dumb + 1;
                end
            end
            
            plot( acum(1,:), acum(2,:), LGRCOLOR );
            
            rho_i = round( (log10(obj.rho)-obj.RHO_MIN)/obj.dRHO + 1 );
            for j = 1:length(obj.poles_Real_hover(:,1,1))
                plot( obj.poles_Real_hover(j,rho_i,1), obj.poles_Imag_hover(j,rho_i,1), ROOTCOLOR );
            end
            hold('off');
            
            
        end
        
    end
    
end






