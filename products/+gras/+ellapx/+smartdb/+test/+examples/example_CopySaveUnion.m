EllUnion = gras.ellapx.smartdb.test.examples.getUnion();
%
% get a copy of the object
%
EllCopy = EllUnion.getCopy();
%
% delete all the data from the object
%
EllUnion.clearData();
EllUnion = gras.ellapx.smartdb.test.examples.getUnion();
%
% create a copy of a specified object via calling a copy constructor for 
% the object class
%
Clone = EllUnion.clone();
%
% remove all duplicate tuples from the relation
%
noDuplicate = Clone.removeDuplicateTuples();
%
% write a content of relation into Excel spreadsheet file
%
EllUnion.writeToCSV('path');
%
% write a content of relation into Excel spreadsheet file
%
fileName = EllUnion.writeToXLS('path');
%
% display a content of the given relation as a data grid UI component
%
EllUnion.dispOnUI();
%
% put some textual information about object in screen
%
EllUnion.display();
