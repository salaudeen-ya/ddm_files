//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "LineLoad.h"
#include "Function.h"

registerMooseObject("MooseApp", LineLoad);

InputParameters
LineLoad::validParams()
{
  InputParameters params = IntegratedBC::validParams();
  params.addRequiredParam<FunctionName>("function", "The function.");
  params.addClassDescription("Imposes the traction as a line load.");
  return params;
}

LineLoad::LineLoad(const InputParameters & parameters)
  : IntegratedBC(parameters), _func(getFunction("function"))
{
}

Real
LineLoad::computeQpResidual()
{
  return -_test[_i][_qp] * _func.value(_t, _q_point[_qp]) * 0.5;
}
