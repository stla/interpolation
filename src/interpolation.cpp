#ifndef _HEADER_
#include "interpolation_types.h"
#endif

// [[Rcpp::export]]
Rcpp::XPtr<std::pair<Delaunay2, Coord_field>> delaunayXYZ_linear(
    Rcpp::NumericMatrix XYZ) {
  Delaunay2 T;
  Coord_field value_function;
  int npoints = XYZ.ncol();
  for(int i = 0; i < npoints; i++) {
    Rcpp::NumericVector xyz = XYZ(Rcpp::_, i);
    Point2 p(xyz(0), xyz(1));
    T.insert(p);
    value_function.insert(std::make_pair(p, xyz(2)));
  }

  std::pair<Delaunay2, Coord_field> out = std::make_pair(T, value_function);
  return Rcpp::XPtr<std::pair<Delaunay2, Coord_field>>(
      new std::pair<Delaunay2, Coord_field>(out), false);
}

// [[Rcpp::export]]
Rcpp::NumericVector interpolate_linear(
    Rcpp::XPtr<std::pair<Delaunay2, Coord_field>> xptr,
    Rcpp::NumericMatrix XYnew) {
  typedef CGAL::Data_access<Coord_field> Value_access;
  std::pair<Delaunay2, Coord_field> stuff = *(xptr.get());
  Delaunay2 T = stuff.first;
  Coord_field value_function = stuff.second;

  // coordinate computation
  int nnewpoints = XYnew.ncol();
  Rcpp::NumericVector znew(nnewpoints);
  for(int i = 0; i < nnewpoints; i++) {
    Rcpp::Rcout << i << " - ";
    Rcpp::NumericVector xynew = XYnew(Rcpp::_, i);
    Point2 p(xynew(0), xynew(1));
    std::vector<std::pair<Point2, Coord>> coords;
    CGAL::Triple nnc =
        CGAL::natural_neighbor_coordinates_2(T, p, std::back_inserter(coords));
    if(!nnc.third) {
      znew(i) = Rcpp::NumericVector::get_na();
    } else {
      Coord norm = nnc.second;
      znew(i) = CGAL::linear_interpolation(coords.begin(), coords.end(), norm,
                                           Value_access(value_function));
    }
  }

  return znew;
}

// [[Rcpp::export]]
Rcpp::XPtr<std::pair<Delaunay2, std::pair<Coord_field, Vector_field>>>
delaunayXYZ_sibson(Rcpp::NumericMatrix XYZ) {
  Delaunay2 T;
  Coord_field value_function;
  int npoints = XYZ.ncol();
  for(int i = 0; i < npoints; i++) {
    Rcpp::NumericVector xyz = XYZ(Rcpp::_, i);
    Point2 p(xyz(0), xyz(1));
    T.insert(p);
    value_function.insert(std::make_pair(p, xyz(2)));
  }

  Vector_field gradient_function;
  sibson_gradient_fitting_nn_2(
      T, std::inserter(gradient_function, gradient_function.begin()),
      CGAL::Data_access<Coord_field>(value_function), gradTraits());

  std::pair<Coord_field, Vector_field> fields =
      std::make_pair(value_function, gradient_function);
  std::pair<Delaunay2, std::pair<Coord_field, Vector_field>> out =
      std::make_pair(T, fields);
  return Rcpp::XPtr<std::pair<Delaunay2, std::pair<Coord_field, Vector_field>>>(
      new std::pair<Delaunay2, std::pair<Coord_field, Vector_field>>(out),
      false);
}

// [[Rcpp::export]]
Rcpp::NumericVector interpolate_sibson(
    Rcpp::XPtr<std::pair<Delaunay2, std::pair<Coord_field, Vector_field>>> xptr,
    Rcpp::NumericMatrix XYnew) {
  typedef CGAL::Data_access<Coord_field> Value_access;
  std::pair<Delaunay2, std::pair<Coord_field, Vector_field>> stuff =
      *(xptr.get());
  Delaunay2 T = stuff.first;
  std::pair<Coord_field, Vector_field> fields = stuff.second;
  Coord_field value_function = fields.first;
  Vector_field gradient_function = fields.second;

  // coordinate computation
  int nnewpoints = XYnew.ncol();
  Rcpp::NumericVector znew(nnewpoints);
  for(int i = 0; i < nnewpoints; i++) {
    Rcpp::Rcout << i << " - ";
    Rcpp::NumericVector xynew = XYnew(Rcpp::_, i);
    Point2 p(xynew(0), xynew(1));
    std::vector<std::pair<Point2, Coord>> coords;
    CGAL::Triple nnc =
        CGAL::natural_neighbor_coordinates_2(T, p, std::back_inserter(coords));
    if(!nnc.third) {
      znew(i) = Rcpp::NumericVector::get_na();
    } else {
      Coord norm = nnc.second;
      std::pair<Coord, bool> res = CGAL::sibson_c1_interpolation_square(
          coords.begin(), coords.end(), norm, p,
          CGAL::Data_access<Coord_field>(value_function),
          CGAL::Data_access<Vector_field>(gradient_function), gradTraits());
      if(!res.second) {
        znew(i) = Rcpp::NumericVector::get_na();
      } else {
        znew(i) = res.first;
      }
    }
  }

  return znew;
}