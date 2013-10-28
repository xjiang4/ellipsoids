function fromQArraysExample1
    n = 1;
    T = 1;
    q11 = @(t)[ cos(2*pi*t/n) sin(2*pi*t/n) ; -sin(2*pi*t/n)  cos(2*pi*t/n) ];
    ltGDir = [];
    QArrList = cell(n+1,1);
    sTime =1;
    timeVec = 1:T;
    for i= 0:n
        ltGDir = [ltGDir ([1 0]*q11(i))'];
        QArrListTemp = repmat(q11(i)'*diag([1 4])*q11(i),[1,1,T]);
        QArrList{i+1} = QArrListTemp;
    end
    ltGDir = repmat(ltGDir,[1 1 T]);
    aMat = repmat([1 0]',[1,T]);
    approxType = gras.ellapx.enums.EApproxType(1);
    calcPrecision = 10^(-3);
    rel = gras.ellapx.smartdb.rels.EllTube.fromQArrays(QArrList',aMat,...
        timeVec,ltGDir,sTime',approxType,char.empty(1,0),...
        char.empty(1,0),calcPrecision);
end;