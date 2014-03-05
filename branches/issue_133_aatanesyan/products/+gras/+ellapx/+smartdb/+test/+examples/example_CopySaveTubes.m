nTubes=5;
nPoints = 100;
timeBeg=0;
timeEnd=1;
type = 2;
EllTube=...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,timeBeg,timeEnd,type,nPoints);
%
% get a copy of the object
%
EllCopy = EllTube.getCopy();
%
% delete all the data from the object
%
EllTube.clearData();
EllTube =...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,timeBeg,timeEnd,type,nPoints);
%
% create a copy of a specified object via calling a copy constructor for 
% the object class
%
Clone = EllTube.clone();
%
% remove all duplicate tuples from the relation
%
noDuplicate = Clone.removeDuplicateTuples();
%
% write a content of relation into Excel spreadsheet file
%
EllTube.writeToCSV('path');
%
% write a content of relation into Excel spreadsheet file
%
fileName = EllTube.writeToXLS('path');
%
% display a content of the given relation as a data grid UI component
%
EllTube.dispOnUI();
%
% put some textual information about object in screen
%
EllTube.display();










