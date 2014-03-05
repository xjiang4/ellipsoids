Ellipsoid tubes, unions and projections
=======================================

There are two types of ellipsoid tube objects that we can work with using *Ellipsoidal Toolbox*:

-  ellipsoidal tubes that are described in *gras.ellapx.smartdb.rels.EllTube* class;

-  unions of ellipsoidal tubes by the instant of time described in    *gras.ellapx.smartdb.rels.EllUnionTube* class (see :ref:`formula <union-label>`).

The projections of ellipsoid tubes can be either static or dynamic. The are described in gras.ellapx.smartdb.rels.EllTubeProj class. As for the unions of ellipsoid tubes, they can only be projected on static subspaces. These projections are described in gras.ellapx.smartdb.rels.EllUnionTubeStaticProj class. For more information about these types of projections and their differences and for examples see this :ref:`link <section-label>`.

Ellipsoid tubes
---------------
There is a whole variety of operations upon ellipsoid tubes in *Ellipsoidal Toolbox*. We can, of course, create them. When the ellipsoid tube object is created, we can cut them, concatenate, interpolate, plot and project them and so on.

The instruments to create ellipsoid tube objects are several functions:

- *fromQArrays* method creates nEllTubes ellipsoid tube objects using an array of ellipsoid matrices and an array of ellipsoid centers specified at any point of time from timeVec;

- *fromQMArrays* method acts the same way as *fromQArrays* method, except for this one requires to specify an array of regularization marices specified at any point of time from timeVec;

- *fromQMScaledArrays* method acts the same way as *fromQMArrays* method, except for this one requires to also specify a vector of scale factors specified for every created ellipsoid tube;

- *fromEllArray* method creates ellipsoid tube object using an array of ellipsoids;

- *fromEllMArray* method creates ellipsoid tube object using an array of ellipsoids and an array of regularisation matrices.

Basically we can divide these methods into two groups, based od what objects they are using to create ellipsoid tube: an array of ellipsoid matrices with an array of ellipsoid centers (by using these methods we can create an ellipsoid tube object containing several ellipsoid tubes) or an array of ellipsoids (by using these methods we can create an ellipsoid tube object containing one ellipsoid tube). To illustrate the usage of these methods we have to describe several functions, that will be used in the process. Below are their descriptions.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//getData.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//getSameApprox.m
   :language: matlab
   :linenos:

Using the three above mentioned functions we can describe an examples of *fromQArrays*, *fromQMArrays* and *fromQMScaledArrays* methods' usage.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQArrays1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQArrays2.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQMArrays1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQMArrays2.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromQMScaledArrays.m
   :language: matlab
   :linenos:

To use *fromEllArray* and *fromEllMArray* methods we nave to describe one more auxiliary function (as these methods create an ellipsoid tube object containing only one ellipsoid tube and we can not use *getData* function, because it returns data for crating random number of ellipsoid tubes).

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//getDataForOneTube.m
   :language: matlab
   :linenos:

Now we can write examples of these methods' usage.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromEllArray.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromEllMArray.m
   :language: matlab
   :linenos:

As we can see in all these examples, we can specify how many ellipsoid tubes we want to create, which type of arrpoximation to use. Also we can create ellipsoid tube objects, which will contain several ellipsoid tubes with different types of approximation.

After creation of ellipsoid tube objects we can do several operations with them. Below is the *getEllTube* function that create an ellipsoid tube object containing one or several ellipsoid tubes with specified type of approximation, on specified time vector with specified time points. This function will be used further down to illustrate other methods that we can use while working with ellipsoid tube objects.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//getEllTube.m
   :language: matlab
   :linenos:

As we have created an ellipsoid tube object, we can get all the types of differet data about it. There is a set of methods that can give information about the data stored in the object and give access to it.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getDataTube.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getEllArrayTube.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getInfoTube.m
   :language: matlab
   :linenos:

Also we can copy the object, clear all the data, save it in a file:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_CopySaveTubes.m
   :language: matlab
   :linenos:

As we have created the object, we can work with it. Below is the example of concatenating ellipsoid tube objects. We can concatenate objects containing one or several ellipsoid tubes with the same type of approximation.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_cat.m
   :language: matlab
   :linenos:

As we can concatenate ellipsoid tubes, it is logical to be possible to cut ellipsoid tubes, leaving only part of it at specified vector of time or point of time. Below are the exmples:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_cut1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_cut2.m
   :language: matlab
   :linenos:

After cutting, we can interpolate the resulting tube, using new time vector. Take notice that we have to make sure that the first and the last elements in old and new vectors of time are the same.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_interp.m
   :language: matlab
   :linenos:

After that we can thin out the new ellipsoid tube, removing ellipsoids at sertain points of time.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_thinOutTuples.m
   :language: matlab
   :linenos:

Then we can also calculate new scale factor for specified fields:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_scale.m
   :language: matlab
   :linenos:

Also we can compare objects using method *isEqual*.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_isEqual1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_isEqual2.m
   :language: matlab
   :linenos:

At last there are several methods for projecting ellipsoid tubes on the specified spaces. The first method projects the ellipsoid tube on specified space creating the specified type of projection.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectTube.m
   :language: matlab
   :linenos:

The second method projects the ellipsoid tube onto subspace defined by vectors of standart basis with indices specified in indVec.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectToOrths1.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectToOrths2.m
   :language: matlab
   :linenos:

Also there is a method for calculating only static projections.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectStaticTube.m
   :language: matlab
   :linenos:

For creating the projection matrix a special function is used in all of these examples.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//fGetProjMat.m
   :language: matlab
   :linenos:

Unions of ellipsoid tubes
-------------------------

As with ellipsoid tube objects there are several methods that we can use while working with ellipsoid tube unions. First of all we can create ellipsoid tube unions using *fromEllTubes* method:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_fromEllTubes.m
   :language: matlab
   :linenos:

From here on we will use the *getUnion* function so we can get ellipsoid tube union and work with it further on. As we have created an ellipsoid tube object, we can get all the types of differet data about it. There is a set of methods that can give information about the data stored in the object and give access to it.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getDataUnion.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getEllArrayUnion.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getInfoUnion.m
   :language: matlab
   :linenos:
 

Also we can copy the object, clear all the data, save it in a file.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_CopySaveUnion.m
   :language: matlab
   :linenos:

Also we can compare ellipsoid tube union objects using *isEqual* method.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_isEqualUnion.m
   :language: matlab
   :linenos:

At last, as it has already been said ellipsoid tube union objects can be projected only on static subspaces. It can be done in two ways.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_project.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_projectStatic.m
   :language: matlab
   :linenos:

As for ellipsoid tube projections a special function is used to create the projection matrix for ellipsoid tube union objects:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//fGetProjMat.m
   :language: matlab
   :linenos:

Projections of ellipsoid tubes and unions
-----------------------------------------

As it has already been said we can create either static or dynamic projections for ellipsoid tubes and only static projections for unions of ellipsoid tubes. There are several methods in *Ellipsoidal Toolbox* for that. Most of them has already been described:

-  *project*, *projectStatic* and *projectToOrths* for ellipsoid tubes;

-  *project* and *projectStatic* for unions of ellipsoid tubes.

It should be mentioned that from here on all the examples are written for ellipsoid tube projections, but their usage is the same for ellipsoid tube union projections. We wiil use *getProj* function to create ellipsoid tube projection that we will work with.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getProj.m
   :language: matlab
   :linenos:

As with ellipsoid tubes and unions of ellipsoid tubes we can get all the types of differet data about projections. There is a set of methods that can give information about the data stored in the object and give access to it.


.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getDataProj.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getEllArrayProj.m
   :language: matlab
   :linenos:

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_getInfoProj.m
   :language: matlab
   :linenos:

Also we can copy the object, clear all the data, save it in a file.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_CopySaveProj.m
   :language: matlab
   :linenos:

Also we can compare ellipsoid tube union objects using *isEqual* method.

.. literalinclude:: ../products/+gras/+ellapx/+smartdb/+test/+examples//example_isEqualProj.m
   :language: matlab
   :linenos:

And finally we can plot out results using one of three methods: *plot*, *plotExt* (for external approximation) or *plotInt* (for internal approximation).

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

To read more about the differences of these projections :ref:`goto <goto-label>`. Also there you can find some illustrations for both ellTube projections and ellUnionTube projections.

