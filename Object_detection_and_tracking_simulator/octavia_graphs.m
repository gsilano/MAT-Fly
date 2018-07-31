function [sys, x0, str, ts, simStateCompliance] = octavia_graphs(t, ~, u, flag, ax, worldfile)
%OCTAVIA_GRAPHS S-function that displays a figure with virtual reality
%   canvas combined with three graphs.
%   This MATLAB function is designed to be used in a Simulink S-function block.
%   The S-function block inputs are displayed under the virtual canvas in
%   three graphs.
%   Block parameters define graph ranges and the associated virtual scene file.
%   It is expected that the same scene is driven by a VR Sink block
%   present in the same model.

%   Copyright 1998-2015 HUMUSOFT s.r.o. and The MathWorks, Inc.

% Store the block handle
blockHandle = gcbh;

switch flag

  % Initialization
  case 0
    [sys, x0, str, ts, simStateCompliance] = mdlInitializeSizes(ax);
    SetBlockCallbacks(blockHandle, worldfile);

  % Update
  case 2
    sys = mdlUpdate(t, u, ax, blockHandle);

  % Start
  case 'Start'
    LocalBlockStartFcn(blockHandle, worldfile)

  % Stop
  case 'Stop'
    LocalBlockStopFcn(blockHandle)

  % NameChange
  case 'NameChange'
    LocalBlockNameChangeFcn(blockHandle)

  % CopyBlock, LoadBlock
  case { 'CopyBlock', 'LoadBlock' }
    LocalBlockLoadCopyFcn(blockHandle)

  % DeleteBlock
  case 'DeleteBlock'
    LocalBlockDeleteFcn(blockHandle)

  % DeleteFigure
  case 'DeleteFigure'
    LocalFigureDeleteFcn();

  % Unused flags
  case { 3, 9 }
    sys = [];

  % Unexpected flags
  otherwise
     if ischar(flag)
       DAStudio.error('sl3d:demos:unhandledflag', flag);
     else
       DAStudio.error('sl3d:demos:unhandledflag', num2str(flag));
     end

end

% end switchyard



%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================

function [sys, x0, str, ts, simStateCompliance] = mdlInitializeSizes(ax)

if length(ax)~=6
  DAStudio.error('sl3d:demos:axislimitsmustbedefined');
end

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

x0  = [];
str = [];
ts  = [-1 0];

% specify that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';

% end mdlInitializeSizes



%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================

function sys = mdlUpdate(t, u, ~, block)

% always return empty, there are no states
sys = [];

% Locate the figure window associated with this block.  If it's not a valid
% handle (it may have been closed by the user), then return.
FigHandle = Get_3GFigure(block);
if ~ishandle(FigHandle)
   return;
end

% get UserData of the figure
ud = get(FigHandle, 'UserData');

if ~isnumeric(ud.G1_Line)    % HG2
  % plot the input lines
  addpoints(ud.G1_Line, t, u(1));
  addpoints(ud.G2_Line, t, u(2));
  addpoints(ud.G3_Line, t, u(3));

else                         % HG1
  % store data points to UserData
  if isempty(ud.XData)
    x_data  = [t t];
    y1_data = [u(1) u(1)];
    y2_data = [u(2) u(2)];
    y3_data = [u(3) u(3)];
  else
    x_data  = [ud.XData(end) t];
    y1_data = [ud.Y1Data(end) u(1)];
    y2_data = [ud.Y2Data(end) u(2)];
    y3_data = [ud.Y3Data(end) u(3)];
  end

  % plot the input lines
  set(ud.G1_Line, ...
      'Xdata', x_data, ...
      'Ydata', y1_data);

  set(ud.G2_Line, ...
     'Xdata', x_data, ...
     'Ydata', y2_data);

  set(ud.G3_Line, ...
     'Xdata', x_data, ...
     'Ydata', y3_data);

  % update the stored data points
  ud.XData(end+1)  = t;
  ud.Y1Data(end+1) = u(1);
  ud.Y2Data(end+1) = u(2);
  ud.Y3Data(end+1) = u(3);
  set(FigHandle, 'UserData', ud);

  % flush event queue
  drawnow;

end

% end mdlUpdate



%=============================================================================
% LocalBlockStartFcn
% Function that is called when the simulation starts.
% Initialize the figure.
%=============================================================================

function LocalBlockStartFcn(block, worldfile)

% get the figure associated with this block, create a figure if it doesn't
% exist
FigHandle = Get_3GFigure(block);
if ~ishandle(FigHandle)
  FigHandle = Create_3GFigure(block, worldfile);
end

% get UserData of the figure
ud = get(FigHandle, 'UserData');

% erase previously drawn lines (if any)
if ~isnumeric(ud.G1_Line)     % HG2
  clearpoints(ud.G1_Line);
  clearpoints(ud.G2_Line);
  clearpoints(ud.G3_Line);
else                          % HG1
  % allow to erase previously drawn lines (if any)
  set(ud.G1_Line, 'Erasemode', 'normal');
  set(ud.G2_Line, 'Erasemode', 'normal');
  set(ud.G3_Line, 'Erasemode', 'normal');

  % clear lines
  set(ud.G1_Line, 'XData', [], 'YData', []);
  set(ud.G2_Line, 'XData', [], 'YData', []);
  set(ud.G3_Line, 'XData', [], 'YData', []);

  % start at [0,0]; line will be appended in each simulation step
  set(ud.G1_Line, 'XData', 0, 'YData', 0, 'Erasemode', 'none');
  set(ud.G2_Line, 'XData', 0, 'YData', 0, 'Erasemode', 'none');
  set(ud.G3_Line, 'XData', 0, 'YData', 0, 'Erasemode', 'none');

  % erase data points stored in UserData
  ud.XData  = [];
  ud.Y1Data = [];
  ud.Y2Data = [];
  ud.Y3Data = [];
end

% set the graph ranges
set(ud.G1_Axes, 'YLim', evalin('base', get_param(block, 'y1range')));
set(ud.G2_Axes, 'YLim', evalin('base', get_param(block, 'y2range')));
set(ud.G3_Axes, 'YLim', evalin('base', get_param(block, 'y3range')));

set(FigHandle, 'UserData', ud);

% end LocalBlockStartFcn



%=============================================================================
% LocalBlockStopFcn
% At the end of the simulation, set the graph's data to contain
% the complete set of points that were acquired during the simulation.
% Recall that during the simulation, the lines are only small segments from
% the last time step to the current one.
%=============================================================================

function LocalBlockStopFcn(block)

FigHandle = Get_3GFigure(block);
if ishandle(FigHandle)

  % Get UserData of the figure.
  ud = get(FigHandle, 'UserData');

  % necessary for HG1 only
  if isnumeric(ud.G1_Line)
    set(ud.G1_Line, ...
        'Xdata', ud.XData, ...
        'Ydata', ud.Y1Data);

    set(ud.G2_Line, ...
        'Xdata', ud.XData, ...
        'Ydata', ud.Y2Data);

    set(ud.G3_Line, ...
        'Xdata', ud.XData, ...
        'Ydata', ud.Y3Data);
  end
end

% end LocalBlockStopFcn



%=============================================================================
% LocalBlockNameChangeFcn
% Function that handles name changes of the block.
%=============================================================================

function LocalBlockNameChangeFcn(block)

% get the figure associated with this block, if it's valid, change
% the name of the figure
FigHandle = Get_3GFigure(block);
if ishandle(FigHandle)
  set(FigHandle, 'Name', BlockFigureTitle(block));
end

% end LocalBlockNameChangeFcn



%=============================================================================
% LocalBlockLoadCopyFcn
% This is the block LoadFcn and CopyFcn. Initialize the block's
% UserData such that a figure is not associated with the block.
%=============================================================================

function LocalBlockLoadCopyFcn(block)

Set_3GFigure(block, -1);

% end LocalBlockLoadCopyFcn



%=============================================================================
% LocalBlockDeleteFcn
% This is the block DeleteFcn. Delete the block's figure window,
% if present, upon deletion of the block.
%=============================================================================

function LocalBlockDeleteFcn(block)

% Get the figure handle associated with the block, if it exists, delete
% the figure.
FigHandle = Get_3GFigure(block);
if ishandle(FigHandle)
  delete(FigHandle);
  Set_3GFigure(block, -1);
end

% end LocalBlockDeleteFcn



%=============================================================================
% LocalFigureDeleteFcn
% This is the figure DeleteFcn. The figure window is
% being deleted, update the block UserData to reflect the change.
%=============================================================================

function LocalFigureDeleteFcn()

% Get the block associated with this figure and set its figure to -1
ud = get(gcbf, 'UserData');
if ~isempty(ud)
  Set_3GFigure(ud.Block, -1);
end

% end LocalFigureDeleteFcn



%=============================================================================
% Get_3GFigure
% Retrieves the figure window associated with this S-function block
% from the block's parent subsystem's UserData.
%=============================================================================

function FigHandle = Get_3GFigure(block)

if strcmp(get_param(block, 'BlockType'), 'S-Function')
  block = get_param(block, 'Parent');
end

FigHandle = get_param(block, 'UserData');
if isempty(FigHandle)
  FigHandle = -1;
end

% end Get_3GFigure



%=============================================================================
% Set_3GFigure
% Stores the figure window associated with this S-function block
% in the block's parent subsystem's UserData.
%=============================================================================

function Set_3GFigure(block, FigHandle)

if strcmp(get_param(bdroot, 'BlockDiagramType'), 'model')
  if strcmp(get_param(block, 'BlockType'), 'S-Function')
    block = get_param(block, 'Parent');
  end

  set_param(block, 'UserData', FigHandle);
end

% end Set_3GFigure



%=============================================================================
% Create_3GFigure
% Creates the figure window associated with this S-function block.
%=============================================================================

function FigHandle = Create_3GFigure(block, worldfile)

% the figure doesn't exist, create one
FigHandle = figure('Units',          'pixels', ...
                   'Position',       [100 100 800 600], ...
                   'Color',          [0.314 0.314 0.314], ...
                   'Name',           BlockFigureTitle(block), ...
                   'Tag',            'octavia_graphs_fig', ...
                   'NumberTitle',    'off', ...
                   'IntegerHandle',  'off', ...
                   'Toolbar',        'none', ...
                   'DeleteFcn',      'octavia_graphs([], [], [], ''DeleteFigure'', [], [])');

% store the block handle in the figure UserData
ud.Block = block;

% the x-axis (time) range corresponds to the model Stop time
stoptime = str2double(get_param(bdroot, 'StopTime'));

% create the first graph in the figure
ud.G1_Axes = axes('Position', [0.05 0.1 0.28 0.25], ...
                  'XGrid',    'on', ...
                  'YGrid',    'on', ...
                  'Color',    'k', ...
                  'XColor',   'w', ...
                  'YColor',   'w', ...
                  'XLim',     [0 stoptime]);
set(ud.G1_Axes, 'Title', title('Speed [m/s]', 'Color', 'w'));
ud.XData = [];
ud.Y1Data = [];

% create the second graph in the figure
ud.G2_Axes = axes('Position', [0.37 0.1 0.28 0.25], ...
                  'XGrid',    'on', ...
                  'YGrid',    'on', ...
                  'Color',    'k', ...
                  'XColor',   'w', ...
                  'YColor',   'w', ...
                  'XLim',     [0 stoptime]);
set(ud.G2_Axes, 'Title', title('Longitudal acceleration [m/s^2]', 'Color', 'w'));
ud.XData = [];
ud.Y2Data = [];

% create the third graph in the figure
ud.G3_Axes = axes('Position', [0.69 0.1 0.28 0.25], ...
                  'XGrid',    'on', ...
                  'YGrid',    'on', ...
                  'Color',    'k', ...
                  'XColor',   'w', ...
                  'YColor',   'w', ...
                  'XLim',     [0 stoptime]);
set(ud.G3_Axes, 'Title', title('Lateral acceleration [m/s^2]', 'Color', 'w'));
ud.XData = [];
ud.Y3Data = [];

% draw the lines
try
  % try HG2 first
  ud.G1_Line = animatedline('Parent', ud.G1_Axes, ...
                            'Color', 'y', ...
                            'MaximumNumPoints', 5000);
  ud.G2_Line = animatedline('Parent', ud.G2_Axes, ...
                            'Color', 'y', ...
                            'MaximumNumPoints', 5000);
  ud.G3_Line = animatedline('Parent', ud.G3_Axes, ...
                            'Color', 'y', ...
                            'MaximumNumPoints', 5000);
catch
  % fallback to HG1 if not available
  ud.G1_Line = line(0, 0, 'Parent', ud.G1_Axes, 'EraseMode', 'None', 'Color', 'y', 'LineStyle', '-');
  ud.G2_Line = line(0, 0, 'Parent', ud.G2_Axes, 'EraseMode', 'None', 'Color', 'y', 'LineStyle', '-');
  ud.G3_Line = line(0, 0, 'Parent', ud.G3_Axes, 'EraseMode', 'None', 'Color', 'y', 'LineStyle', '-');
end

% open vrworld if not open already
mfilepath = fullfile(fileparts(get_param(bdroot(block), 'Filename')), worldfile);
if (exist(mfilepath, 'file') == 2)
  vr_world = vrworld(mfilepath);
else
  vr_world = vrworld(worldfile);
end
if ~isopen(vr_world)
  open(vr_world);
end
ud.vr_world = vr_world;

% create two canvases in the figure
vr.canvas(vr_world, 'Parent', FigHandle, ...
          'Units', 'normalized', ...
          'Position', [0.03 0.45 0.45 0.53]);
c2 = vr.canvas(vr_world, 'Parent', FigHandle, ...
               'Units', 'normalized', ...
               'Position', [0.52 0.45 0.45 0.53]);
set(c2, 'Viewpoint', 'View_Driver_Car1');

% Associate the figure with the block, and set the figure's UserData.
Set_3GFigure(block, FigHandle);
set(FigHandle, 'UserData', ud, 'HandleVisibility', 'callback');

% end Create_3GFigure



%=============================================================================
% BlockFigureTitle
% String for figure window title
%=============================================================================

function title = BlockFigureTitle(block)
  iotype = get_param(block, 'iotype');
  if strcmp(iotype, 'viewer')
    title = viewertitle(block, false);
  else
    title = get_param(block, 'Name');
  end

% end BlockFigureTitle



%=============================================================================
% SetBlockCallbacks
% This sets the callbacks of the block if it is not a reference.
%=============================================================================

function SetBlockCallbacks(block, worldfile)

% the actual source of the block is the parent subsystem
parent = get_param(block, 'Parent');

% set the callbacks for the block so that it has the proper functionality
callbacks = {
'CopyFcn',       'octavia_graphs([], [], [], ''CopyBlock'', [], [])'; ...
'DeleteFcn',     'octavia_graphs([], [], [], ''DeleteBlock'', [], [])'; ...
'LoadFcn',       'octavia_graphs([], [], [], ''LoadBlock'', [], [])'; ...
'StartFcn',      sprintf('octavia_graphs([], [], [], ''Start'', [], ''%s'')', worldfile); ...
'StopFcn'        'octavia_graphs([], [], [], ''Stop'', [], [])'; ...
'NameChangeFcn', 'octavia_graphs([], [], [], ''NameChange'', [], [])'; ...
};

for i=1:length(callbacks)
  if ~strcmp(get_param(parent, callbacks{i,1}), callbacks{i,2})
    set_param(parent, callbacks{i,:})
  end
end

% end SetBlockCallbacks
