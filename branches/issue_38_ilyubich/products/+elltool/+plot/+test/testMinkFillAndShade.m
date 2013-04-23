function self = testMinkFillAndShade(self,fmink,firstEllMat,secEllMat)
fmink(firstEllMat,secEllMat,'fill',false,'shade',1);
fmink(firstEllMat,secEllMat,'fill',true,'shade',0.7);
self.runAndCheckError...
    ('fmink([firstEllMat,secEllMat],''shade'',NaN)', ...
    'wrongShade');
self.runAndCheckError...
    ('fmink([firstEllMat,secEllMat],''shade'',[0 1])', ...
    'wrongParamsNumber');
end