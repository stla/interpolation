#ifndef _HEADER_
#define _HEADER_
#endif

#include <Rcpp.h>

#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Delaunay_triangulation_2.h>
#include <CGAL/Interpolation_traits_2.h>
#include <CGAL/natural_neighbor_coordinates_2.h>
#include <CGAL/interpolation_functions.h>
typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
typedef CGAL::Delaunay_triangulation_2<K>                   Delaunay2;
typedef CGAL::Interpolation_traits_2<K>                     Traits;
typedef K::FT                                               Coord_type;
typedef K::Point_2                                          Point2;
typedef std::map<Point2, Coord_type, K::Less_xy_2>          Coord_map;
