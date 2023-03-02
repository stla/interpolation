#ifndef _HEADER_
#include "interpolation_types.h"
#endif

// [[Rcpp::export]]
Rcpp::NumericVector test(Rcpp::NumericVector x,
                         Rcpp::NumericVector y,
                         Rcpp::NumericVector z,
                         Rcpp::NumericVector xnew,
                         Rcpp::NumericVector ynew) {
  Delaunay2 T;
  typedef CGAL::Data_access<Coord_map> Value_access;
  Coord_map value_function;

  int npoints = x.size();
  for(int i = 0; i < npoints; i++) {
    Point2 p(x(i), y(i));
    T.insert(p);
    value_function.insert(std::make_pair(p, z(i)));
  }

  // coordinate computation
  int nnewpoints = xnew.size();
  Rcpp::NumericVector znew(nnewpoints);
  for(int i = 0; i < nnewpoints; i++) {
    Rcpp::Rcout << i;
    Point2 p(xnew(i), ynew(i));
    std::vector<std::pair<Point2, Coord_type>> coords;
    CGAL::Triple nnc =
        CGAL::natural_neighbor_coordinates_2(T, p, std::back_inserter(coords));
    if(!nnc.third) {
      znew(i) = Rcpp::NumericVector::get_na();
    } else {
      Coord_type norm = nnc.second;
      znew(i) = CGAL::linear_interpolation(coords.begin(), coords.end(), norm,
                                           Value_access(value_function));
    }
  }

  return znew;
}

// [[Rcpp::export]]
Rcpp::XPtr<std::pair<Delaunay2, Coord_map>> delaunayXYZ(Rcpp::NumericVector x,
                                                        Rcpp::NumericVector y,
                                                        Rcpp::NumericVector z) {
  Delaunay2 T;
  Coord_map value_function;
  int npoints = x.size();
  for(int i = 0; i < npoints; i++) {
    Point2 p(x(i), y(i));
    T.insert(p);
    value_function.insert(std::make_pair(p, z(i)));
  }

  std::pair<Delaunay2, Coord_map> out = std::make_pair(T, value_function);
  return Rcpp::XPtr<std::pair<Delaunay2, Coord_map>>(
      new std::pair<Delaunay2, Coord_map>(out), false);
}

// [[Rcpp::export]]
Rcpp::NumericVector test2(Rcpp::XPtr<std::pair<Delaunay2, Coord_map>> xptr,
                          Rcpp::NumericVector xnew,
                          Rcpp::NumericVector ynew) {
  typedef CGAL::Data_access<Coord_map> Value_access;
  std::pair<Delaunay2, Coord_map> stuff = *(xptr.get());
  Delaunay2 T = stuff.first;
  Coord_map value_function = stuff.second;

  // coordinate computation
  int nnewpoints = xnew.size();
  Rcpp::NumericVector znew(nnewpoints);
  for(int i = 0; i < nnewpoints; i++) {
    Rcpp::Rcout << i << " - ";
    Point2 p(xnew(i), ynew(i));
    std::vector<std::pair<Point2, Coord_type>> coords;
    CGAL::Triple nnc =
        CGAL::natural_neighbor_coordinates_2(T, p, std::back_inserter(coords));
    if(!nnc.third) {
      znew(i) = Rcpp::NumericVector::get_na();
    } else {
      Coord_type norm = nnc.second;
      znew(i) = CGAL::linear_interpolation(coords.begin(), coords.end(), norm,
                                           Value_access(value_function));
    }
  }

  return znew;
}