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

import elltool.conf.Properties;


  
  
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
  if Properties.getIsVerbose()
    fprintf('Plotting reach set external approximation...\n');
  end
  plObj=smartdb.disp.RelationDataPlotter(...
                'nMaxAxesRows',1 ,'nMaxAxesCols', 1,...
                'figureGroupKeySuffFunc',@(x)sprintf('_gr%d',x));
  if d == 3
    EE  = move2origin(E(:, end));
    EE  = EE';
    M   = rs.nPlot3dPoints()/2;
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
    
    SData.verticesX = X(1,:);
    SData.verticesY = X(2,:);
    SData.verticesZ = X(3,:);
    faceVertexCData = clr(ones(1,n),:).';
    SData.faceVertexCDataX = faceVertexCData(1,:);
    SData.faceVertexCDataY = faceVertexCData(2,:);
    SData.faceVertexCDataZ = faceVertexCData(3,:);
    SData.axesName = 'ax';
    SData.figureName = 'fig';
    SData.shad = Options.shade;
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
                @axesSetPropFunc,{'axesName','tit'},...
                {@plotCreatePatchFunc},...
                {'verticesX','verticesY','verticesZ',...
                'faceVertexCDataX','faceVertexCDataY','faceVertexCDataZ','shad'});
      relationDataPlot = rel;  
      return                       
  end
  

     
  if size(rs.time_values, 2) == 1
    E   = move2origin(E');
    M   = size(E, 2);
    N   = ellOptions.plot2d_grid;
    phi = linspace(0, 2*pi, N);
    L   = [cos(phi); sin(phi)];
    X   = [];
    for i = 1:N
      l      = L(:, i);
      [v, x] = rho(E, l);
      idx    = find(isinternal((1+ellOptions.abs_tol)*E, x, 'i') > 0);
      if ~isempty(idx)
        x = x(:, idx(1, 1)) + rs.center_values;
	X = [X x];
      end
    end
    hold on;
    SData.col = Options.color; 
    if ~isempty(X)
      X = [X X(:, 1)];
      if Options.fill ~= 0
          SData.Xf = X(1,:);
          SData.Yf = X(2,:);  
          SData.fl = 1;
      else
           SData.Xf =0;
          SData.Yf = 0;  
          SData.fl = 0;
      end
      SData.Xel = X(1,:);
      SData.Yel = X(2,:);
      SData.wid = Options.width;
      SData.Xc = rs.center_values(1,:);
      SData.Yc = rs.center_values(2,:);
      SData.axesName = 'ax';
      SData.figureName = 'fig';
      if isdiscrete(rs.system)
        SData.tit = sprintf('%s at time step K = %d', back, rs.time_values);
      else
        SData.tit = sprintf('%s at time T = %d', back, rs.time_values);
      end
    rel=smartdb.relations.DynamicRelation(SData);
    
       plObj.plotGeneric(rel,@figureGetGroupNameFunc,...
                {'figureName'},@figureSetPropFunc,...
                {},  @axesGetNameSurfFunc,...
                {'axesName'},...
                @axesSetPropFunc2,{'axesName','tit'},...
                {@plotCreateFillFunc,@plotCreateElPlot1Func,@plotCreateElPlot2Func},...
                {'Xf','Yf','col','fl','Xel','Yel','wid','Xc','Yc'});
      relationDataPlot = rel; 
    else
      warning('2D grid too sparse! Please, increase ''ellOptions.plot2d_grid'' parameter...');
    end
    return;
  end
    [m, n] = size(E);
  s      = (1/2) * rs.nPlot2dPoints();
  phi    = linspace(0, 2*pi, s);
  L      = [cos(phi); sin(phi)];

  if isdiscrete(rs.system)
      SData.X = [];
      SData.Y = [];
      SData.Z = [];
      SData.Xc = [];
      SData.Yc = [];
      SData.Zc = [];
      SData.col = Options.color;
      SData.wid = Options.width;
      SData.axesName = 'ax';
      SData.figureName = 'fig';
      if rs.time_values(1) > rs.time_values(end)
        SData.tit = 'Discrete-time backward reach tube';
      else
        SData.tit = 'Discrete-time reach tube';
      end
    for ii = 1:n
      EE = move2origin(E(:, ii));
      EE = EE';
      X  = [];
      cnt = 0;
      for i = 1:s
        l = L(:, i);
        [v, x] = rho(EE, l);
        idx    =  find(isinternal((1+rs.absTol())*EE, x, 'i') > 0);
        if ~isempty(idx)
          x = x(:, idx(1, 1)) + rs.center_values(:, ii);
          X = [X x];
        end
      end
      tt = rs.time_values(ii);
      if ~isempty(X)
        X  = [X X(:, 1)];
        tt = rs.time_values(:, ii) * ones(1, size(X, 2));
        X  = [tt; X];
        if Options.fill ~= 0
           SData.fl = 1;
        else
           SData.fl = 0;
        end
        SData.X = [SData.X, {X(1,:)}];
        SData.Y = [SData.Y, {X(2,:)}];
        SData.Z = [SData.Z, {X(3,:)}];
      else
        warning('2D grid too sparse! Please, increase ''ellOptions.plot2d_grid'' parameter...');
      end
      SData.Xc = [SData.Xc, {tt(1,1)}];
      SData.Yc = [SData.Yc, {rs.center_values(1, ii)}];
      SData.Zc = [SData.Zc, {rs.center_values(2, ii)}];
    end
        rel=smartdb.relations.DynamicRelation(SData);
    
       plObj.plotGeneric(rel,@figureGetGroupNameFunc,...
                {'figureName'},@figureSetPropFunc,...
                {},  @axesGetNameSurfFunc,...
                {'axesName'},...
                @axesSetPropFunc3,{'axesName','tit'},...
                {@plotCreateFill3Func,@plotCreateElPlot3Func,@plotCreateElPlot4Func},...
                {'X','Y','Z','col','fl','wid','Xc','Yc','Zc'});
      relationDataPlot = rel; 
  else
      F = ell_triag_facets(s, size(rs.time_values, 2));
    V = [];
    for ii = 1:n
      EE = move2origin(inv(E(:, ii)));
      EE = EE';
      X  = [];
      for i = 1:s
        l    = L(:, i);
        mval = ellOptions.abs_tol;
        for j = 1:m
          if 1
            Q  = parameters(EE(1, j));
            v  = l' * Q * l;
            if v > mval
              mval = v;
            end
          end
        end
        x = (l/sqrt(mval)) + rs.center_values(:, ii);
        X = [X x];
      end
      tt = rs.time_values(ii) * ones(1, s);
      X  = [tt; X];
      V  = [V X];
    end
    vs = size(V, 2);
    SData.col = Options.color;
    SData.shad = Options.shade;
    SData.axesName = 'ax';
    SData.figureName = 'fig';
    SData.verticesX = V(1,:);
    SData.verticesY = V(2,:);
    SData.verticesZ = V(3,:);
    SData.facesX = F(:,1)';
    SData.facesY = F(:,2)';
    SData.facesZ = F(:,3)';
    faceVertexCData = clr(ones(1, vs), :);
    SData.faceVertexCDataX = faceVertexCData(:,1)';
    SData.faceVertexCDataY = faceVertexCData(:,2)';
    SData.faceVertexCDataZ = faceVertexCData(:,3)';
    if rs.time_values(1) > rs.time_values(end)
      SData.tit = 'Backward reach tube';
    else
      SData.tit = 'Reach tube';
    end
      rel=smartdb.relations.DynamicRelation(SData);
    
       plObj.plotGeneric(rel,@figureGetGroupNameFunc,...
                {'figureName'},@figureSetPropFunc,...
                {},  @axesGetNameSurfFunc,...
                {'axesName'},...
                @axesSetPropFunc4,{'axesName','tit'},...
                {@plotCreatePatch2Func},...
                {'verticesX','verticesY','verticesZ','facesX','facesY','facesZ',...
                'faceVertexCDataX','faceVertexCDataY','faceVertexCDataZ','shad'});
      relationDataPlot = rel;  
  end        
end   
function hVec=plotCreatePatchFunc(hAxes,verticesX,verticesY,verticesZ,faceVertexCDataX,faceVertexCDataY,faceVertexCDataZ,faceAlpha)
        vertices = [verticesX;verticesY;verticesZ];
        faces = convhulln( vertices.');
        faceVertexCData = [faceVertexCDataX;faceVertexCDataY;faceVertexCDataZ]';
         h0 = patch('Vertices',vertices', 'Faces', faces, ...
          'FaceVertexCData', faceVertexCData, 'FaceColor','flat', ...
          'FaceAlpha', faceAlpha);
         shading interp;
         lighting phong;
         material('metal');
         view(3);
         hVec  = h0;
end
function hVec=plotCreatePatch2Func(hAxes,verticesX,verticesY,verticesZ,facesX,facesY,facesZ,faceVertexCDataX,faceVertexCDataY,faceVertexCDataZ,faceAlpha)
        vertices = [verticesX;verticesY;verticesZ];
        faces = [facesX;facesY;facesZ];
        faceVertexCData = [faceVertexCDataX;faceVertexCDataY;faceVertexCDataZ]'
        h0 = patch('Vertices',vertices', 'Faces', faces', ...
          'FaceVertexCData', faceVertexCData, 'FaceColor','flat', ...
          'FaceAlpha', faceAlpha);
         shading interp;
         lighting phong;
         material('metal');
         view(3);
         hVec  = h0;
end
function hVec=plotCreateFillFunc(hAxes,X,Y,col,fl,varargin)
         if fl
             h =   fill(X,Y,col);
            hVec  = h;
         else
             hVec = [];
         end
end
function hVec=plotCreateFill3Func(hAxes,X,Y,Z,col,fl,varargin)
        hVec =[];
        for iEl = 1:size(X,2)      
         if fl
             h =   fill3(X(iEl),Y(iEl),Z(iEl),col);
            hVec  = [hVec,h];
         else
             hVec = [];
         end
        end
end
function hVec=plotCreateElPlot1Func(hAxes,~,~,col,~,X,Y,wid,varargin)
          h =   ell_plot([X;Y]);
          set(h,'Color',col,'LineWidth',wid);
         hVec  = h;
end
function hVec=plotCreateElPlot2Func(hAxes,~,~,col,~,~,~,~,Xc,Yc)
          h =   ell_plot([Xc;Yc],'.');
          set(h,'Color',col);
         hVec  = h;
end
function hVec=plotCreateElPlot3Func(hAxes,X,Y,Z,col,~,wid,varargin)
    hVec =[]; 
    for iEl = 1:size(X,2) 
          Y{iEl}
            h =   ell_plot([X{iEl};Y{iEl};Z{iEl}]);
          set(h,'Color',col,'LineWidth',wid);
         hVec  = [hVec, h];
    end
end
function hVec=plotCreateElPlot4Func(hAxes,~,~,~,col,~,~,Xc,Yc,Zc)
         hVec =[];
         for iEl = 1:size(Xc,2) 
            h =   ell_plot([Xc{iEl};Yc{iEl};Zc{iEl}],'.');
            set(h,'Color',col);
            hVec  = [hVec,h];
         end
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
                 xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
               title(tit);
                hVec=[];
end
function hVec=axesSetPropFunc2(hAxes,basicAxesName,axesName,tit)
                 xlabel('x_1'); ylabel('x_2');
               title(tit);
                hVec=[];
end     
function hVec=axesSetPropFunc3(hAxes,basicAxesName,axesName,tit)
                view(3);
                 xlabel('k'); ylabel('x_1'); zlabel('x_2');
               title(tit);
                hVec=[];
end     
function hVec=axesSetPropFunc4(hAxes,basicAxesName,axesName,tit)
                view(3);
                 xlabel('t'); ylabel('x_1'); zlabel('x_2');
               title(tit);
                hVec=[];
end     