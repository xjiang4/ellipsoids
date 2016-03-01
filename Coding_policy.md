# Introduction #

Coding policy consists of
  1. Naming/style convention
  1. Enforces test-driven development
  1. Some other generic requirements that in long-term make a life of every developer easier.

# Generic requirements #

Use English as the only language of communication. Source code comments, documentation etc. should be in English. Russian or other languages cannot be used here.

# Naming and style convention #

**Every developer should follow the following:
[Matlab naming and style convention](http://ellipsoids.googlecode.com/svn/wiki/attachments/matlabstylereq/matlabstylereq.pdf)**

For a quick reference, here is a short list of correct variable names


| Variable name | Interpretation | Bad names |
|:--------------|:---------------|:----------|
| isMyMat       |  logical matrix | myMat, ismyMat |
| isMyVec       | logical vector | ismyvec,myvec |
| isOk          | logical scalar | isok, ok  |
| myMat         |  numeric matrix | mymat,MyMat |
| myCMat        |  cell matrix   | myMat,Mat,mat, CMat|
| myArray,myFirstArray |  >=3 dimensional array | myMat,myVec, myCArray |
| myVec,my1Vec,myFirstVec | numeric vector | myvec, Myvec,myVec1 |
| myCVec, myList,myFirstList | cell vector    | myList1, myListFirst |
| SMyData       | scalar structure| sMyData   |
| SMyDataMat    | structure matrix| SMyData   |
| SMyDataArray  | 3>= dimensional structure array| SMyDataMat |
| myEll         | scalar ellipsoid object| MyEll     |
| myEllMat      | ellipsoid object matrix| myEll     |
| myEllArray    | ellipsoid object array| MyEllArray |
| fCalcSomething  | scalar function handle| calcSomething |
| nElems, mElems  | number of elements (numeric scalar)| nelems, NElems |
| iElem,jElem,kElem  | current element counter in a loop| ielem, i,j,k |
| ABS\_TOL, MAX\_TOLERANCE  | abstolute precison, maximum tolernace defined as constants| absTol,maxTolerance |


# Help headers #
Use the format from the following example to the letter (mind the blank spaces, the case, the structure) when writing the help headers for the functions/class methods

**Help header width should be under 76 symbols so that the automatic help
collector can fit it properly into the toolbox manual.**

```
% PARSEPAREXT behaves in the same way as modgen.common.parseparams but
% returns property values in a more convenient form
%
% Input:
%   regular:
%       arg: cell[1,] list of input parameters to parse
%       propNameValMat: cell[1-3,nExpProps] of char[1,]/cell[2,]
%           - list of properties to recognize
%           - and optionally the list of default values for properties
%           - and optionally the list of check strings for properties
%               (see modgen.common.type.simple.checkgen for check string
%                   syntax)
%
%         Note: property names are case-insensitive!
%
%   optional:
%       nRegExpected: double[1,1]/[1,2] - an expected number of regular
%          arguments/range of regular argument numbers. If the actual
%          number doesn't mach the expected number an exception is thrown.
%
%       nPropExpected: double[1,1] - an expected number of properties
%
%   properties:
%       regCheckList: cell[1,nRegMax] of char[1,] - list of regular
%           parameter check strings
%
%       regDefList: cell[1,nRegMax] of any[] - list of regular parameter
%          values
%       
%       propRetMode: char[1,] - property return mode, the following modes
%           are supported
%               'list' - an aggregated list of specified properties 
%                   is  returned instead of returning each property as 
%                   a separate  output
%               'separate' - each property is returned separately followed
%                   isSpec indicator, this is a default method
%
%       isObligatoryPropVec: logical[1,nExpProp] - indicates whether a
%           corresponding property from propNameValMat is obligatory. This
%           property can only be used when propNameValMat is not empty
%
% Output:
%   reg: cell[1,nRegs] - list of regular parameters
%
%   isRegSpecVec: logical[1,nRegs] - indicates whether a regular argument
%       specified
%   
%   ---------------"list" mode -----------------         
%   prop: cell[1,nFilledProps] 
%   isPropSpecVec: logical[1,nExpProps]
%
%   ---------------"separate" mode
%   prop1Val: any[] - value of the first property specified by propNameValMat
%       ...
%   propNVal: any[] - value of the last property specified by propNameValMat
%
%   isProp1Spec: logical[1,1] - indicates whether the first property is
%       specified
%       ...
%   isPropNSpec: logical[1,1] - indicates whether the last property is
%       specified
%
% Example:
%   [reg,isSpecVec,...
%       propVal1,propVal2,propVal3...
%       isPropVal1,isPropVal2,isPropVal3]=...
%       modgen.common.parseparext({1,2,'prop1',3,'prop2',4},...
%       {'prop1','prop2','prop3';...
%       [],[],5;...
%       'isscalar(x)','isscalar(x)','isnumeric(x)'},...
%       [0 3],...
%       'regDefList',{1,2,3},...
%       'regCheckList',{'isnumeric(x)','isscalar(x)','isnumeric(x)'},...
%       'isObligatoryPropVec',[true true false])
%
% reg =   {1,2,3}
% isSpecVec = [true,true,false]
% propVal1 = 3
% propVal2 = 4
% propVal3 = 5
% isPropVal1 =true
% isPropVal2 =true
% isPropVal3 =false
%
%
% $Author: Peter Gagarinov  <pgagarinov@gmail.com> $	$Date: 2011-07-27 $ 
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2011 $
%
%
```

# Test-driven approach #
Always follow a test driven approach. To understand what the test-driven approach is please read about [Unit testing karma](http://ellipsoids.googlecode.com/svn/wiki/attachments/TheWayOfTestivus.pdf).

More specifically, you should comply with the following rules.

  1. Every new feature should be complemented with a test that makes sure that the feature is implemented correctly
  1. **Do not write non-determenistic tests** i.e. the tests that use randomly-generated data. This may result into unstable behavior when a test sporadically fails and we don't know why. However, it is a good idea to use random data for finding the tricky combinations of input arguments. I.e. you write random data-driven test, you run it in a loop to see if some realization of random vector causes a crash of a failure. Then you fix that combination and make a determenistic test out of it.
  1. Before committing any changes make sure that you do not break existing tests.
  1. Use MLUNITEXT as a unit-testing framework for your tests. See [MLUNITEXT framework description](MLUNITEXT_unit_testing_framework_description.md).
  1. If you put class MyClass into package 'mypackage.mychildpackage' then your tests should be in `mypackage.mychildpackage.test.mlunit' while 'run_tests' function should be in `mypackage.mychildpackage.test` i.e. its full name should be `mypackage.mychildpackage.test.run\_tests`.
  1. Write higher-level `run_tests` function (`mypackage.test.run_test` that calls `mypackage.mychildpackage.test.run_tests`)
# Program as Matlab were a statically-typified language. Fix and check input argument types #
  1. Do not write classes/functions that can accept arguments of completely different types. The following example shows the construction that **every developer should avoid!!**
```
  function result=myfunc(a)
  if iscell(a)
     result=a{1}+1;
  elseif isnumeric(a)
     result=a+1;
  end 
```
  1. Check input argument types using `modgen.common.checkvar` and `modgen.common.checkmultvar` functions:
```
%check whether a condition numel(x1)==numel(x2) holds for variables  aVar and bVar
%throw exception if it does not, in exception refer to the variables as 'Alpha' and 'bVar' 
modgen.common.checkmultvar('numel(x1)==numel(x2)',2,aVar,bVar,...
    'varNameList','Alpha'},'errorTag',...
    'wrongInput:wrongSizes','errorMessage','Sizes of inputs are not consistent')
%
%do the same but determine the variable names automatically and automatically generate error message
modgen.common.checkmultvar('numel(x1)==numel(x2)',2,aVar,bVar,...
    'errorTag','wrongInput:wrongSizes')
%
%automatic variable name recognition does not work properly if you use something like that
modgen.common.checkmultvar('numel(x1)==numel(x2)',...
    varargin{1},vaarargin{2})
%
%simpler variant just for 1 variable
modgen.common.checkvar(aVar,'isnumeric(x)&&isa(x,''int32'')||isscalar(x)',...
    'errorTag','wrongInput:wrongTypes','errorMessage','Input has an incorrect type')
```
  1. Parse input argument and check their types using `modgen.common.parseparext` function (see the following example). The main purpose of `parseparext` is to parse input arguments (properties and regular inputs) but it also can check for simple conditions that do not involve multiple variables. For checking the more complex conditiosn like `numel(x1)==numel(x2)` use `checkgenext` function mentioned above. For more infromation about `modgen.common.parseparext` read its help header within the function itself. For simple inputs a more light-weight function `modgen.common.parseparams` can be used (it is different from Matlab built-in `parseparams` function).
```
  [reg,isSpecVec,...
      propVal1,propVal2,propVal3...
      isPropVal1,isPropVal2,isPropVal3]=...
      modgen.common.parseparext({1,2,'prop1',3,'prop2',4},...
      {'prop1','prop2','prop3';...
      [],[],5;...
      'isscalar(x)','isscalar(x)','isnumeric(x)'},...
      [0 3],...
      'regDefList',{1,2,3},...
      'regCheckList',{'isnumeric(x)','isscalar(x)','isnumeric(x)'},...
      'isObligatoryPropVec',[true true false])
      %This will produce
      %reg =   {1,2,3}
      %isSpecVec = [true,true,false]
      %propVal1 = 3
      %propVal2 = 4
      %propVal3 = 5
      %isPropVal1 =true
      %isPropVal2 =true
      %isPropVal3 =false
```

# Use special functions to throw errors and warnings #
Use `modgen.common.throwerror` and `modgen.common.throwwarn` functions to throw warnings. Do not use `error` and `warning` functions directly. For more information read the help headers for these functions.

# Use exceptions only for exceptional situations #
The following example demonstrates an extremely improper use of exceptions that **every developer should avoid !!**
```
function isPositive=issizeequal(aVec,bVec)
aVec=[1,2,3];
bVec=[1,2];
try
    aVec==bVec;
catch meObj
    if strcmp(meObj.identifier,'MATLAB:dimagree')
        isPositive=false;
    else
        rethrow(meObj);
    end
end
```
# Use logging to make debugging easier #
Use logging to make debugging easier. For logging use `modgen.logging.log4j.Log4jConfigurator` class or inherited classes `elltool.logging.Log4jConfigurator` and `elltool.test.logging.Log4jConfigurator`. The following example demonstrates its use.
```
   import elltool.logging.Log4jConfigurator
   logger=Log4jConfigurator.getLogger();
   logger.info('doing something useful...');
   a=2*2;
   logger.info('doing something useful: done');
```

For more information see [Logging\_with\_log4j](Logging_with_log4j.md).

# Put your code into well-structured packages #
Do not put everything into a single package unless the classes/functions are tightly-related.