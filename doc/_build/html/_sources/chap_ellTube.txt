Ellipsoid tubes and touching curves
===================================

Touching curves
---------------

One of the basic insruments in the *Ellipsoidal Toolbox* are classes, which allow to work with touching curves. These are the curves along which the internal and external ellipsoidal approximations are touching. In *Ellipsoidal Toolbox* there are two basic classes (*EllTubeTouchCurveBasic* and *EllTubeTouchCurveProjBasic*) which allow us to keep touching curves and their projections. These classes do not add any functionality, that we can use, while working with the toolbox, (They do not have public methods.) but they are further used in other classes, which inherit these ones.

*EllTubeTouchCurveBasic* class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This class allows us to keep touch point curve objects. This kind of objects have a lot of different fields, which store the information about the touching curve.
The first field of our object is:

-  *dim*: In this field the dimension of the space in which the touching 
   curves are defined is stored.

Then there are several fields that are connecteld with time:

-  *timeVec*: Time vector in which the the touching curves are defined;

-  *sTime*: Specific point of time which is best suited to describe good direction;

-  *indSTime*: The index of sTime point within timeVec is srored in this field.

It should be said that the *good direction* is the direction along which the internal and external approximations of ellipsoid tubes are touching. Next several fields specify the type of approximation which was used? while creating these touching curves:

-  *approxSchemaName*: The name of the approximation schema;

-  *approxSchemaDescr*: The description of the approximation schema;

-  *approxType*: The type of approximation (External, Internal, NotDefined) is stored in this        field.

Then there are two fields which keep the absolute tolerance and relative tolerance used to create this object (*absTolerance* and *relTolerance*, respectively). And finally come the fields which allow us to keep the touching curves and good directions:

-  *ltGoodDirMat* field stores the matrix of good direction vectors at any point of time from        timeVec;

-  *lsGoodDirVec* field stores the good direction vector at sTime point of time;

-  *ltGoodDirNormVec* field stores the norm of good direction vectors at any point of time from      timeVec;

-  *lsGoodDirNorm* field stores the norm of good direction vector at sTime point of time;

-  *xTouchCurveMat* field stores the touch point curve for good direction matrix;

-  *xTouchOpCurveMat* field stores the touch point curve oposite to the xTouchCurveMat touch         point curve;

-  *xsTouchVec* field stores the touch point at sTime point of time;

-  *xsTouchOpVec* field stores a point opposite to the xsTouchVec touch point;

-  *isLsTouch* field stores a logical variable which indicates whether a touch takes place along     good direction at sTime point of time;

-  *isLtTouchVec* field stores a logical vector which indicates whether a touch takes place          along good direction at any point of time from timeVec.

*EllTubeTouchCurveProjBasic* class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This class allows us to keep the projections of touch point curves. This kind of objects have a lot of different fields, which store the information about the projection of touching curve. First of all it inherits all the fields from *EllTubeTouchCurveBasic* class, and, secondly, it adds some of its own fields. The inherited fields store the information about the projection instead of the information about the original curve, but their meaning is all the same.
The first group of new fields is connected to the type of projection and the space on which the curve is projected:

-  *projSMat* field stores the projection matrix at sTime point of time;

-  *projArray* field stores an array of projection matrices at any point of time from timVec;

-  *projType* field stores the type of projection (Static or DynamicAlongGoodCurve).

And then come the new fields which store some information about the original curve:

-  *ltGoodDirNormOrigVec* field stores the norm of the original good direction vectors at any        point of time from timeVec;
-  *lsGoodDirNormOrig* field stores the norm of the original good direction vector at sTime        point of time;

-  *ltGoodDirOrigMat* field stores the matrix of the original good direction vectors at any        point of time from timeVec;

-  *lsGoodDirOrigVec* field stores the original good direction vector at sTime point of time;

-  *ltGoodDirNormOrigProjVec* field stores the norm of the projection of the original good        direction curve;

-   *ltGoodDirOrigProjMat* field stores the projectition of the original good direction curve.

Ellipsoidal tubes
-----------------

Other basic insrument in the *Ellipsoidal Toolbox* are classes, which allow to work with ellipsoidal tubes. In *Ellipsoidal Toolbox* there are four classes (*EllTubeBasic*, *EllTube*, *EllTubeProjBasic* and *EllTubeProj*) which give us the needed functionality to work with ellipsoid tube objects.

*EllTubeBasic* class
~~~~~~~~~~~~~~~~~~~~

This class inherits its fields from *EllTubeTouchCurveBasic* class and adds some new fields which are:

-  *QArray* field which stores an array of nTimePoints ellipsoid matrices. Each element from this
   array specifies an ellipsoid matrix at nTimePoint point of time. Here nTimePoints is number of    elements in *timeVec* (It is one of the fields inherited from *EllTubeTouchCurveBasic*       class.);

-  *aMat* field which stores an array of nTimePoints ellipsoid centers. Each center is specified     for nTimePoint point of time;

-  scaleFactor field which stores the scale for the created ellipsoid tube;

-  MArray field which stores an array of nTimePoints regularization matrices. Each element from      this array specifies a regularization matrix at nTimePoint point of time.

This class gives us some methods which can be used to work with ellipsoidal tubes. For example, if we have already created ellipsoid tube object using one timeVec vector of time, then we can interpolate this tube, using new time vector. Take notice that we have to make sure that the first and the last elements in old and new vectors of time are the same.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_interp.m
   :language: matlab
   :linenos:

Other method that we can use is *THINOUTTUPLES* method. It allows us to thin out the already created ellipsoid tube, by saving only the ellipsoids at specified points of time.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_thinOutTuples.m
   :language: matlab
   :linenos:

Then we can also cut the created ellipsoid tube, leaving only part of it at specified vector of time or point of time. Below are the exmples:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_cut1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_cut2.m
   :language: matlab
   :linenos:

*EllTube* class
~~~~~~~~~~~~~~~

This class inherits its fields from *EllTubeBasic* class. It does not have any new fields, but adds some functionality. First of all it gives us the instruments to create ellipsoid tube objects. Here are these methods:

-  *fromQArrays* - creates nEllTubes ellipsoid tube objects using an array of ellipsoid matrices     and an array of ellipsoid centers specified at any point of time from timeVec;

-  *fromQMArrays* - acts the same way as *fromQArrays* method, except for this one requires to    specify an array of regularization marices specified at any point of time from timeVec;

-  *fromQMScaledArrays* - acts the same way as *fromQMArrays* method, except for this one       requires to also specify a vector of scale factors specified for every created ellipsoid tube;

-  *fromEllArray* - creates ellipsoid tube object using an array of ellipsoids;

-  *fromEllMArray* - creates ellipsoid tube object using an array of ellipsoids and an array of    regularisation matrices.

Basically we can divide these methods into two groups, based od what objects they are using to create ellipsoid tube: an array of ellipsoid matrices and an array of ellipsoid centers or an array of ellipsoids. Below are some examples of the usage of these functions.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQArrays1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQArrays2.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQMArrays1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQMScaledArrays1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromEllArray.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromEllMArray.m
   :language: matlab
   :linenos:

As we can see in these examples, we can specify how many ellipsoid tubes we want to create, which type of arrpoximation to use. also we can create ellipsoid tube objects, which will contain several ellipsoid tubes with different types of approximation.
We can also use *project* and *projectToOrths* methods to project our ellipsoid tubes on the specified spaces. The first metod projects the ellipsoid tube on specified space creating the specified type of projection.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_project.m
   :language: matlab
   :linenos:

The second method projects the ellipsoid tube onto subspace defined by vectors of standart basis with indices specified in indVec.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectToOrths1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectToOrths2.m
   :language: matlab
   :linenos:

*EllTubeProjBasic* class
~~~~~~~~~~~~~~~~~~~~~~~~

This class inherits its fields from *EllTubeBasic* and *EllTubeTouchCurveProjBasic* classes. It does not have any new fields, but holds not the original values of the fields, which were the values of the original ellipsoid tube, it holds the values of the projection. We can use *plot*, *plotInt* or *plotExt* methods to plot the projections.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_plot.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_plotInt.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_plotExt.m
   :language: matlab
   :linenos:

All the three methods have several properties connected to the properties of the image, for example: transparency, color, line width and so on.

*EllTubeProj* class
~~~~~~~~~~~~~~~~~~~

This class doesn't add any functionality to the *EllTubeProjBasic* class.

Unions of ellipsoidal tubes
---------------------------

The last classes which will be discussed in this chapter are classes, operating with unions of ellipsoid tubes. These are *EllUnionTubeBasic*, *EllUnionTube* and *EllUnionTubeStaticProj* classes.

*EllUnionTubeBasic* class
~~~~~~~~~~~~~~~~~~~~~~~~~

This class allows us to keep and work with unions of ellipsoid tubes. The fields of this class are:

-  *ellUnionTimeDirection* which stores the direction in time along which union is performed;

-  *timeTouchEndVec* which stores the points of time when touch is occured in good direction;

-  *timeTouchOpEndVec* which stores the points of time when touch is occured in direction    opposite to good direction;

-  *isLsTouchOp* which stores a logical variable which indicates whether a touch takes place    along the direction opposite to the good direction at sTime point of time;

-  *isLtTouchOpVec* which stores a logical variable which indicates whether a touch takes place    along the direction opposite to the good direction at any point of time from timeVec.

This class does not have any public methods.

*EllUnionTube* class
~~~~~~~~~~~~~~~~~~~~

This class inherits its fields from *EllUnionTubeBasic* and *EllTubeBasic* classes. Unlike *EllUnionTubeBasic* class, this class has one public method - *fromEllTubes* method, which allows us to create an ellUnionTube object using ellipsoid tubes.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromEllTubes.m
   :language: matlab
   :linenos:

*EllUnionTubeStaticProj* class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The last class connected to ellUnionTube objects is *EllUnionTubeStaticProj* class. It inherits the fields and methods of *EllUnionTubeBasic* and *EllTubeProjBasic* classes and allows us to work with the static projections of ellUnionTubes.

*TypifiedByFieldCodeRel* class
----------------------------

This is the last class that should be mentioned in this chapter. It is inherited by *EllTube*, *EllTubeProj*, *EllUnionTube* and *EllUnionTubeStaticProj* classes and adds some methods to them. For example we can use *getData* method.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getData.m
   :language: matlab
   :linenos:

Or we can compare objects from above mentioned classes using method *isEqual*.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_isEqual1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_isEqual2.m
   :language: matlab
   :linenos:
