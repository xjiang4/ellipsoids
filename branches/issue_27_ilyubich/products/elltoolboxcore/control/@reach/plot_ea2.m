function relationDataPlot = plot_ea2(rs, varargin)
%
% PLOT_EA - plots external approximations of 2D and 3D reach sets.
%
%
% Description:
% ------------
%
%         PLOT_EA(RS, OPTIONS)  Plots the external approximation of the reach set RS
%                               using options in the OPTIONS structure.
%    PLOT_EA(RS, 'r', OPTIONS)  Plots the external approximation of the reach set RS
%                               in red color using options in the OPTIONS structure.
%
%    OPTIONS structure is an optional parameter with fields:
%      OPTIONS.color       - sets color of the picture in the form [x y z].
%      OPTIONS.width       - sets line width for 2D plots.
%      OPTIONS.shade = 0-1 - sets transparency level (0 - transparent, 1 - opaque).
%      OPTIONS.fill        - if set to 1, reach set will be filled with color.
%
%
% Output:
% -------
%
%    hPlot -  column vector of handles to lineseries objects
%
%
% See also:
% ---------
%
%    REACH/REACH, PLOT_IA, CUT, PROJECTION.
%

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end
  
  
  if ~(isa(rs, 'reach'))
    error('PLOT_EA: first input argument must be reach set.');
  end
  rs = rs(1, 1);
  d  = dimension(rs);
  N  = size(rs.ea_values, 2);
  if (d < 2) || (d > 3)
    msg = sprintf('PLOT_EA: cannot plot reach set of dimension %d.', d);
    if d > 3
      msg = sprintf('%s\nUse projection.', msg);
    end
    error('PLOT_EA:wrongDimension',msg);
  end
if nargin > 1
    if isstruct(varargin{nargin - 1})
      Options = varargin{nargin - 1};
    else
      Options = [];
    end
  else
    Options = [];
end
  if ~(isfield(Options, 'color'))
    Options.color = [0 0 1];
  end

  if ~(isfield(Options, 'shade'))
    Options.shade = 0.3;
  else
    Options.shade = Options.shade(1, 1);
    if Options.shade > 1
      Options.shade = 1;
    end
    if Options.shade < 0
      Options.shade = 0;
    end
  end

  if ~isfield(Options, 'width')
    Options.width = 2;
  else
    Options.width = Options.width(1, 1);
    if Options.width < 1
      Options.width = 2;
    end
  end

  if ~isfield(Options, 'fill')
    Options.fill = 0;
  else
    Options.fill = Options.fill(1, 1);
    if Options.fill ~= 1
      Options.fill = 0;
    end
  end


  if (nargin > 1) && ischar(varargin{1})
    Options.color = my_color_table(varargin{1});
  end
  E   = get_ea(rs);
  clr = Options.color;
  if rs.t0 > rs.time_values(end)
    back = 'Backward reach set';
  else
    back = 'Reach set';
  end
  if ellOptions.verbose > 0
    fprintf('Plotting reach set external approximation...\n');
  end
  if d == 3
    EE  = move2origin(E(:, end));
    EE  = EE';
    M   = ellOptions.plot3d_grid/2;
    N   = M/2;
    psy = linspace(0, pi, N);
    phi = linspace(0, 2*pi, M);
    X   = [];
    L   = [];
    for i = 2:(N - 1)
      arr = cos(psy(i))*ones(1, M);
      L   = [L [cos(phi)*sin(psy(i)); sin(phi)*sin(psy(i)); arr]];
    end
    n = size(L, 2);
    m = size(EE, 2);
    for i = 1:n
      l    = L(:, i);
      mval = ellOptions.abs_tol;
      for j = 1:m
        if trace(EE(1, j)) > ellOptions.abs_tol
          Q = parameters(inv(EE(1, j)));
          v = l' * Q * l;
          if v > mval
            mval = v;
          end
        end
      end
      x = (l/sqrt(mval)) + rs.center_values(:, end);
      X = [X x];
    end
    plObj=smartdb.disp.RelationDataPlotter(...
                'nMaxAxesRows',1 ,'nMaxAxesCols', 1,...
                'figureGroupKeySuffFunc',@(x)sprintf('_gr%d',x));
    SData.verticesX = X(1,:);
    SData.verticesY = X(2,:);
    SData.verticesZ = X(3,:);
    faceVertexCData = clr(ones(1,n),:).';
    SData.faceVertexCDataX = faceVertexCData(1,:);
    SData.faceVertexCDataY = faceVertexCData(2,:);
    SData.faceVertexCDataZ = faceVertexCData(3,:);
    SData.axesName = 'ax';
    SData.figureName = 'fig';
%     SData.faceColor = {'flat';'flat';'flat'};
%     SData.faceAlpha = {Options.shade;Options.shade;Options.shade}
     if isdiscrete(rs.system);
      SData.tit = sprintf('%s at time step K = %d', back, rs.time_values(end));
    else
      SData.tit = sprintf('%s at time T = %d', back, rs.time_values(end));
     end
%     SData.title = {SData.title;SData.title;SData.title}

    rel=smartdb.relations.DynamicRelation(SData);
    
       plObj.plotGeneric(rel,@figureGetGroupNameFunc,...
                {'figureName'},@figureSetPropFunc,...
                {},  @axesGetNameSurfFunc,...
                {'axesName'},...
                @axesSetPropFunc,{'axesName'},...
                {@plotCreateSurfFunc},...
                {'SData.verticesX','SData.verticesY','SData.verticesZ',...
                'SData.faceVertexCDataX','SData.faceVertexCDataY','SData.faceVertexCDataZ'});
            
            
            
            
            
  end     
            
end   
function hVec=plotCreateSurfFunc(verticesX,verticesY,verticesZ,faceVertexCDataX,faceVertexCDataY,faceVertexCDataZ)%,faceColor,faceAlpha,...
       % varargin)
        vertices = [verticesX;verticesY;verticesZ];
        faces = convhulln( vertices.');
        faceVertexCData = [faceVertexCDataX;faceVertexCDataY;faceVertexCDataZ];
         h0 = patch('Vertices',vertices, 'Faces', faces, ...
          'FaceVertexCData', faceVertexCData, 'FaceColor',faceColor, ...
          'FaceAlpha', faceAlpha);
         shading interp;
         lighting phong;
         material('metal');
         view(3);
         hVec  = h0;
end
    function figureSetPropFunc(hFigure,figureName,indFigureGroup)
                set(hFigure,'Name',figureName);
end
    
function figureGroupName=figureGetGroupNameFunc(figureName)
                figureGroupName=[figureName];
end
function axesName=axesGetNameSurfFunc(axesName)
                axesName = axesName;
end
function hVec=axesSetPropFunc(hAxes,basicAxesName,axesName,tit)
                axis(hAxes,'auto');
                 set(hAxes,'XLabel','x_1');
                set(hAxes,'YLabel','x_2');
                set(hAxes,'ZLabel','x_3');
               set(hAxes,'Title',tit);
                hVec=[];
end
            