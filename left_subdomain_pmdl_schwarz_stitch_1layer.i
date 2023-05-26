
[Mesh]
  [interior]
    type = FileMeshGenerator
    file = interior1.inp
  []

  [pmdl]
    type = FileMeshGenerator
    file = pmdl1.inp
  []
  
  [smg]
    type = StitchedMeshGenerator
    inputs = 'interior pmdl'
    clear_stitched_boundary_ids = false
    stitch_boundaries_pairs = 'right_int left_pmdl'                        
    #parallel_type = 'replicated'
    show_info = true
  []
  [add_sidesets]
    type = SideSetsFromNodeSetsGenerator
    input = smg
    show_info = true
  []
  construct_side_list_from_node_list=true
[]


[Variables]
  [u]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [xflux]
    order = CONSTANT
    family = MONOMIAL
  []
  [yflux]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [diffusion]
    type = MatDiffusion
    variable = u
    diffusivity = 1
  []
    [reaction]
    type =  Reaction
    variable = u
    rate = 0.25
  []
[]

[AuxKernels]
  [xfluxKernel]
    type = DiffusionFluxAux
    diffusivity = -1
    variable = xflux
    diffusion_variable = u
    component = x
  []
  [yfluxKernel]
    type = DiffusionFluxAux
    diffusivity = -1
    variable = yflux
    diffusion_variable = u
    component = y
  []

[]

[BCs]
  [leftBC] 
    type = DirichletBC
    variable = u
    boundary = 'left_int'
    value = 0
  []

  [rightBC] 
    type = NeumannBC
    variable = u
    boundary = 'bottom_pmdl'
    value = 0
  []

   [rightBC2] 
    type = NeumannBC
    variable = u
    boundary = 'right_pmdl'
    value = 1
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



