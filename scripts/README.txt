List of R Scripts and their functions

- "adjust_raster_extent_ascii.R" ...... Get all rasters of predictor variables to the same exact extent so as to prevent errors in running MaxEnt

- "convert_ascii_to_tif.R" ...... Convert rasters of predictor variables from ascii format to tif format for use in *enmEval*

- "convert_tif_to_ascii.R" ...... Convert rasters of predictor variables from tif format to ascii format for use in MaxEnt

- "thin_points.R" ...... spThin R package - thin species observations to no more than one sample per kilometer to avoid sampling bias issues. This is in place of creating a bias file.

- "raster_correlations_check.R" ...... Identify correlations among predictor variables to avoid bias when running MaxEnt

- "get_bioclim.R" ...... Download rasters of Bioclim variables for a specified extent (predictor variables)

- "get_isric.R" ...... Download rasters of ISRIC (International Soil Reference and Information Centre) data variables for a specified extent (predictor variables)

- "enmEval_no_bias.R" ...... Run enmEvaluate to evaluate which parameters should be used in running MaxEnt for your occurrence data and predictor variables. For use with thinned occurrence data, not with a bias file.