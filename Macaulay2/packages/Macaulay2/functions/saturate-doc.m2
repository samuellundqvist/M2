--- status: TODO
--- author(s): MES, some from before
--- notes: 

document {
     Key => [saturate,Strategy],
     "There are four strategy values:",
     SUBSECTION "Iterate",
         TT "saturate(I,J,Strategy => Iterate)", " -- indicates that successive ideal
	 or module quotients should be used.",
	 PARA{},
	 "This value is the default.",
     SUBSECTION "Linear",
         TT "saturate(I,J,Strategy => Linear)", 
	 TT "Strategy => Linear", " -- indicates that the reverse lex order should
	 be used to compute the saturation.",
	 PARA{},
	 "This presumes that ", TT "J", " is a single, linear polynomial, and that ", TT "I", " 
	 is homogeneous.",
	 PARA{},
	 "This is also an option value for ", TO "pushForward1", ".",
     SUBSECTION "Bayer",
     	 TT "saturate(I,f,Strategy => Bayer)", " -- indicates that the method of Bayer's 
	 thesis should be used.",
	 PARA{},
	 "The method is to compute ", TT "(I:f)", " for ", TT "I", " and ", TT "f", " homogeneous,
	 add a new variable ", TT "z", ", compute a Groebner basis of ", TT "(I,f-z)", " in reverse 
	 lex order, divide by ", TT "z", ", and finally replace ", TT "z", " by ", TT "f", ".",
     SUBSECTION "Eliminate",
	 TT "saturate(I,f,Strategy => Eliminate)", " -- indicates that the
	 saturation ", TT "(I:f)", " should be computed by eliminating
	 f", TT "z", " from ", TT "(I,f*z-1)", ", where ", TT "z", " is a new variable."
     }

document {
     Key => [saturate,DegreeLimit],
     TT "DegreeLimit => n", " -- keyword for an optional argument used with
     ", TO "saturate", " which specifies that the computation should halt after dealing 
     with degree n."
     }

undocumented {
     (saturate, Vector)
     }


document { 
     Key => {saturate,
	  (saturate, Ideal),
	  (saturate, MonomialIdeal, MonomialIdeal),
	  (saturate, Module),
	  (saturate, Ideal, Ideal),
	  (saturate, Ideal, RingElement),
	  (saturate, Module, Ideal),
	  (saturate, Module, RingElement),
	  (saturate, MonomialIdeal, RingElement)
	  },
     Headline => "saturation of ideal or submodule",
     Usage => "saturate(I,J)\nsaturate I",
     Inputs => {
	  "I" => {ofClass {Ideal, Module, MonomialIdeal}},
	  "J" => {ofClass {Ideal, RingElement}, ".  If not present, then ", TT "J", " is the ideal generated by the variables of the ring"}
	  },
     Outputs => {
	  {
	       ofClass {Ideal, Module, MonomialIdeal}, ", the saturation of ", TT "I", " with respect to ", TT "J"}
	  },
     PARA{},
     "If I is either an ideal or a submodule of a module M,
     the saturation (I : J^*) is defined to be the set of elements
     f in the ring (first case) or in M (second case) such that
     J^N * f is contained in I, for some N large enough.",
     PARA{},
     "For example, one way to homogenize an ideal is to
     homogenize the generators and then saturate with respect to
     the homogenizing variable.",
     EXAMPLE {
	  "R = ZZ/32003[a..d];",
	  "I = ideal(a^3-b, a^4-c)",
	  "Ih = homogenize(I,d)",
	  "saturate(Ih,d)",
	  },
     "We can use this command to remove graded submodules of 
     finite length.",
     EXAMPLE {
	  "m = ideal vars R",
	  "M = R^1 / (a * m^2)",
	  "M / saturate 0_M",
	  },
     PARA{},
     "If I and J are both monomial ideals, then a faster algorithm is used.  If I or J is not a monomial ideal, 
     generally Groebner bases will be used to the compute the saturation.  These will be computed as needed.",
     PARA{},
     "The computation is currently not stored anywhere: this means
     that the computation cannot be continued after an interrupt.
     This will be changed in a later version.",
     SeeAlso => {quotient, "PrimaryDecomposition"}
     }
document { 
     Key => [saturate, MinimalGenerators],
     Headline => "whether to compute minimal generators",
     Usage => "saturate(...,MinimalGenerators=>b)",
     Inputs => {
	  "b" => Boolean => "default is true"
	  },
     Consequences => {
	  "If b is false, then the minimalization of the saturation will not be done"
	  },     
     "Sometimes the extra time to find the minimal generators is too large.  This allows one
     to bypass this part of the computation.",
     EXAMPLE lines ///
	  R = ZZ/101[x_0..x_4]
     	  I = truncate(8, monomialCurveIdeal(R,{1,4,5,9}));
	  time gens gb I;
	  time J1 = saturate(I);
	  time J = saturate(I, MinimalGenerators=>false);
	  numgens J
	  numgens J1
	  ///,
     Caveat => {"Most of the time, you don't want to do this!"},
     SeeAlso => {monomialCurveIdeal, truncate}
     }

 -- doc4.m2:614:     Key => saturate,
 -- doc4.m2:649:     Key => [saturate,Strategy],
 -- doc4.m2:679:     Key => [saturate,DegreeLimit],
 -- doc9.m2:1219:     Key => [saturate,MinimalGenerators],
