function outObj=loadobj(inpObj)
if isstruct(inpObj)
    warning([upper(mfilename),':wrongInput'],...
        ['Loaded relation has a legacy format making it impossible to ',...
        'recover an exact relation type, ',...
        'loading as smartdb.relations.UntypifiedStaticRelation']);    
    outObj=smartdb.relations.UntypifiedStaticRelation(...
        'fieldNameList',transpose(fieldnames(inpObj.SData)));
    outObj.copyFrom(inpObj);
else
    outObj=loadobj@smartdb.relations.ARelation(inpObj);
end