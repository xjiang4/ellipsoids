EllProj = gras.ellapx.smartdb.test.examples.getProj();
%
% get a copy of the object
%
EllCopy = EllProj.getCopy();
%
% delete all the data from the object
%
EllProj.clearData();
EllProj = gras.ellapx.smartdb.test.examples.getProj();
%
% create a copy of a specified object via calling a copy constructor for 
% the object class
%
Clone = EllProj.clone();
%
% remove all duplicate tuples from the relation
%
noDuplicate = Clone.removeDuplicateTuples();
%
% write a content of relation into Excel spreadsheet file
%
EllProj.writeToCSV('path');
%
% write a content of relation into Excel spreadsheet file
%
fileName = EllProj.writeToXLS('path');
%
% display a content of the given relation as a data grid UI component
%
EllProj.dispOnUI();
%
% put some textual information about object in screen
%
EllProj.display();
