curPath=fileparts(mfilename('fullpath'));
mex('ammeral.cpp','triangle.cpp','main.cpp','-output',...
    [curPath,filesep,'../srebuild3d']);