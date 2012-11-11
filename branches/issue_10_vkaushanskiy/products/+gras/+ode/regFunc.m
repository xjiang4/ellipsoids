function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
    EPS = 0.01;
    hStep = tTime(2) - tTime(1);
    isReg = false;
    yout = yTime(end);
    if (yout < EPS)
        isReg = true;
        yout = EPS;
    end;
    tempRegY = 12*(EPS - yTime(end-1))./hStep + 16*(fOdeDeriv(tTime(end-2), yTime(end-2)) + regTime(2)) - 5*(fOdeDeriv(tTime(1), yTime(1)) + regTime(1));
    regY = tempRegY./23 - fOdeDeriv(tTime(end-1), yTime(end-1));
end