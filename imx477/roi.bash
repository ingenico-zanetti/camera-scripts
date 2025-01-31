#!/bin/bash
# imx477: 1.55µm pixels, 4056x3040 native resolution 
# 3840x2160 ROI with offsets to balance optical misalignement
# # centered
# roi=" --roi 0.0266,0.1447,0.9468,0.7106 "
# # corrected
roi=" --roi 0.0450,0.1447,0.9468,0.7106 "
# roi=" --roi 0.0450,0.2125,0.9468,0.7106 "
echo "Using roi from roi.bash: $roi"


