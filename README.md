This repository contains code MATLAB code implementing Nosofsky's (1984, 1986) Generalized Context Model (GCM). The code is written fairly generally, and should work provided any 'standard' classification problem.

The GCM can be simulated using **START.m**. This script will pass a model architecture to **GCM.m**, returns classification probabilities. 

This repository does *not* contain code for parameter optimization. I find that optimization techniques vary considerably depending on data being simulated, so custom code will need to be written to optimize the GCM's free parameters.

*Nolan Conaway*

*March 08, 2015*