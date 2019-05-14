# AutoPIHM

# Step 1
Load the fundamental rawdata.
## Task:
- Load the rawdata
- Reproject the DEM data from Geographic Coordinate System (GCS) to Projected Coordinate System (PCS), same with Watershed Boundary(WBD)
## Requisite
1. The DEM data must be merged before this step. The country-wide DEM should be merged.
1. The watershed boundary and river network (RIV) data must be ready before this Step 1.

# Step 2

Process the rawdata and crop data with the watershed boundary.

## Task
* Select the subset of watershed boundary based on user-defined.
* Generate the buffer of WBD and WBD in GCS.
* Crop the DEM
* Crop RIV
* Soil Data
    - Crop soil data
    - Reproject data
    - Extract soil parameters
* Land use
    - Crop landuse data
    - Reproject data
    - Extract land use parameters
* Forcing data
    - Generate the fishnet of FLDAS
    - Read FLDAS data and save as RDS file.
    - Conver the RDS file into .csv files.

## Requisite
- User must define which subcatchment you like to run the model.

# Step 3 PIHMgis
Generate the input files for PIHM

## Task
* Simplify WBD and RIV
* Generate PIHM domain (irregular triangular network - TIN)
* Mapping relation of TIN and soil/geology/landuse/forcing data
* Write out the input files for PIHM

# Step 4 PIHM
Run the pihm++ with the input files.

# Step 5 Visualization
## Tasks
* Load the input and output files of PIHM
* Plot the time-series data
* Plot and export the spatial data (maps)