function [tsOut,tOut]=filterts(tsInp,tInp,varargin)
% FILTERTS filters time series according to selected methodId
% 
% Usage: [tsOut,tOut]=filterts(tsInp,iInp,proplist)
%  		 [tsOut,tOut]=filterts(tsInp,iInp,isSecondSkip,proplist)
% 
% Input:
% 	regular:
%   	tsInp: double[nObs,nSeries] - input observed data,
%       tInp: double[nObs,1] - observed time,
%	optional:
%		isSecondSkip: logical[1,1] - if true, the second 
%			argument is skipped
%			
%   properties:
%       methodId: string, specified the name of methodId,
%          'dummy' - simple methodId (tsOut=tsInp,tOut=tInp)
% 
% Output:
%     regular:
%         tsOut: double[n,nSeries] - filtered time series,
%         tOut: double[n,1] - corresponding time
% 
% Created by <Name> <FamilyName>, <University/Company>
