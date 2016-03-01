<h1><font color='red'>
<h1>Project has been moved</h1>

For several reasons we decided to move ellipsoids to Github. For latest information please follow <a href='http://systemanalysisdpt-cmc-msu.github.io/ellipsoids/'>this link</a>.</font></h1>



---


---






# Ellipsoidal Toolbox for MATLAB #
**Ellipsoidal Toolbox (ET)**  is a standalone set of easy-to-use configurable MATLAB routines to perform operations with ellipsoids and hyperplanes of arbitrary dimensions. It computes the external and internal ellipsoidal approximations of geometric (Minkowski) sums and differences of ellipsoids, intersections of ellipsoids and intersections of ellipsoids with halfspaces and polytopes; distances between ellipsoids, between ellipsoids and hyperplanes, between ellipsoids and polytopes; and projections onto given subspaces.

Ellipsoidal methods are used to compute forward and backward reach sets of continuous- and discrete-time piecewise affine systems. Forward and backward reach sets can be also computed for piecewise linear systems with disturbances. It can be verified if computed reach sets intersect with given ellipsoids, hyperplanes, or polytopes.

The toolbox provides efficient plotting routines for ellipsoids, hyperplanes and reach sets.

Required software:

  * **Version 2.0 beta1**
    * MATLAB 2012a
    * CVX 2.0 build 1010 or higher
    * MPT 3.0.12

  * **Version 1.1.3 (or lower)**
    * MATLAB 6.5 (or higher)
    * YALMIP (ver. 20120926)


**ET** version 1.1.3 is also distributed as part of [Multi-Parametric Toolbox (MPT)](http://control.ee.ethz.ch/~mpt).



---


## Contact / Support ##
  * Found **ET** useful for something?
  * Found a bug and wish to report it?
  * Have questions, suggestions or feature requests?
  * Wish to contribute to the **ET** development?
Please, contact [Peter Gagarinov](https://github.com/pgagarinov), [Alex Kurzhanskiy](http://lihodeev.com) or [report an issue](https://github.com/SystemAnalysisDpt-CMC-MSU/ellipsoids/issues).

In case you use **ET** in your research, we would greatly appreciate if you added the corresponding reference to your publications:
```
@techreport{Kurzhanskiy:EECS-2006-46,
    Author = {Kurzhanskiy, A. A. and Varaiya, P.},
    Title = {Ellipsoidal Toolbox},
    Institution = {EECS Department, University of California, Berkeley},
    Year = {2006},
    Month = {May},
    URL = {http://code.google.com/p/ellipsoids},
    Number = {UCB/EECS-2006-46}
}
```


---


## Download and Installation ##

### ET 2.0 ###
Please refer to http://code.google.com/p/ellipsoids/wiki/Toolbox_installation_instructions for ET 2.0 installation instructions

### ET 1.1.3 ###

Please read http://code.google.com/p/ellipsoids/wiki/Legacy_Toolbox_1_1_3_installation_instructions


## Animations ##
| [Refinement of Ellipsoidal Approximation](http://lihodeev.com/et/refine.zip) | It starts approximating the reach set with one external (blue) and one internal (green) ellipsoids, then the number of approximating ellipsoids is doubled – now there are two external and two internal, then it is doubled again – now there are four of each, finally, there are 32 external and 32 internal ellipsoids. |
|:-----------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Switching System](http://lihodeev.com/et/switch.zip)                        | The dynamics of the system changes every 5 seconds. For the first system, the external approximation is blue and internal – yellow; for the second, the external approximation is red and internal – green; for the third, the external approximation is magenta and internal – cyan. The set of initial conditions for the second system is the reach set of the first one, and the set of initial conditions for the third system – the reach set of the second one. |
| [Switching System in 3D](http://lihodeev.com/et/switch3.zip)                 | Tthis example is similar to the previous one, only this time it is 3-dimensional system with one switch.                                                                                                                                                                                                                    |
| [Reaching Boundary Point](http://lihodeev.com/et/boundary_point.zip)         | This example illustrates how moving along the _good curve_ using known control, we reach the boundary point of the reach set at given time.                                                                                                                                                                                 |
| [Reaching Internal Point](http://lihodeev.com/et/internal_point.zip)         | By squeezing the set of controls and computing 'good curves' for the squeezed set, we can steer the system to any internal point of the reach set at given time.                                                                                                                                                            |
| [Choosing Control Based on Reach Set Information](http://lihodeev.com/et/reach_info.zip) | The control can be chosen based on the reach set computed for the next time interval. Here, the black dot chooses where to go, knowing its reach set 5 seconds ahead. The reach set is displayed in red for external, and blue – for internal approximation.                                                                |
| [Reach Set Info in 3D](http://lihodeev.com/et/reach_info3.zip)               | This example is similar to the previous one, only in 3D.                                                                                                                                                                                                                                                                    |


---


## Third Party Software Packages in ET ##

### ET 2.0 ###
Starting with version 2.0 ET relies on

  * [CVX](http://cvxr.com/) as a more reliable toolbox for solving SDP problems of high dimensionality.  [CVX](http://cvxr.com/) - Matlab-based convex modeling framework
CVX distribution includes two freeware solvers: SeDuMi (used by default in ET) and SDPT3.
  * [MPT3](http://control.ee.ethz.ch/~mpt/3/) as a toolbox that defines polytope class used in Ellipsoids toolbox.



### ET 1.1.3 ###
Legacy versions of ET toolbox (1.1.3 and earlier) use YALMIP+SeDuMi toolbox combination for solving SDP problems.
> [YALMIP](http://control.ee.ethz.ch/~joloef/yalmip.php) - high-level MATLAB toolbox for rapid development of optimization code.

> [SeDuMi](http://sedumi.mcmaster.ca) - MATLAB toolbox for solving optimization problems over symmetric cones.

  * [MPT2](http://control.ee.ethz.ch/~mpt/2/) as a toolbox that defines polytope class used in Ellipsoids toolbox.

These packages are included in the **ET** distribution. So, you don’t need to download them separately.


---


## Related Software ##
> [Ellipsoidal Calculus based on Propagation and Fusion](http://www-iri.upc.es/people/ros/ellipsoids.html). Propagation is an operation of obtaining an ellipsoid that satisfies an affine relation with given ellipsoid. Fusion is operation of finding an ellipsoid that tightly bounds from outside the intersection of two given ellipsoids.

> [Geometric Bounding Toolbox (GBT)](http://sysbrain.com/gbt) - commercial MATLAB toolbox that deals with multidimensional convex and nonconvex polytopes and has a limited number of functions operating with ellipsoids.

> [Hybrid System Tools](http://wiki.grasp.upenn.edu/~graspdoc/wiki/hst/) - list of free modeling and verification tools for hybrid systems.
