[Mesh]
  [pmdl]
    type = FileMeshGenerator
    file = pmdl2.inp
    block_id = 1
  []

  [interior]
    type = FileMeshGenerator
    file = interior2.inp
    block_id = 2
  []

  [smg]
    type = StitchedMeshGenerator
    inputs = 'pmdl interior'
    clear_stitched_boundary_ids = false
    stitch_boundaries_pairs = 'right_pmdl left_int'
                              
    #parallel_type = 'replicated'
  []

  construct_side_list_from_node_list=true
  
[]
[Variables]
  [v]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [xflux_v]
    order = CONSTANT
    family = MONOMIAL
  []
  [yflux_v]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [diffusion]
    type = MatDiffusion
    variable = v
    diffusivity = 1
  []
  [reaction]
    type =  Reaction
    variable = v
    rate = 0.25
  []
[]

[AuxKernels]
  [xfluxKernel]
    type = DiffusionFluxAux
    diffusivity = -1
    variable = xflux_v
    diffusion_variable = v
    component = x
  []
  [yfluxKernel]
    type = DiffusionFluxAux
    diffusivity = -1
    variable = yflux_v
    diffusion_variable = v
    component = y
  []
[]

[BCs]
   [topBC] 
    type = NeumannBC
    variable = v
    boundary = 'top_pmdl'
    value = 1
  []

  [toppmdl] 
    type = DirichletBC
    variable = v
    boundary = 'right_int'
    value = 0
  []


[]


[Executioner]
  type = Steady
  solve_type = 'NEWTON'

  fixed_point_max_its = 1000
  nl_abs_tol = 1e-10
  fixed_point_rel_tol = 1e-16
  fixed_point_abs_tol = 1e-10

  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  
[]

[Outputs]
  exodus = true
  #csv = true
  console = true
[]
