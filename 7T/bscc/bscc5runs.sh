#!/bin/bash
#SBATCH -p amd_256
#SBATCH -N 1
#SBATCH -n 1
source /public3/soft/modules/module.sh
module load singularity/singularity-2.6.0-yangzq-public3
srun -c 64 singularity exec ~/AFNI/AFNI_CentOS7.img tcsh -xef proc.gufei.run1.pade 2>&1 | tee output.proc.gufei.run1.pade &
srun -c 64 singularity exec ~/AFNI/AFNI_CentOS7.img tcsh -xef proc.gufei.run2.pade 2>&1 | tee output.proc.gufei.run2.pade &
srun -c 64 singularity exec ~/AFNI/AFNI_CentOS7.img tcsh -xef proc.gufei.run3.pade 2>&1 | tee output.proc.gufei.run3.pade &
srun -c 64 singularity exec ~/AFNI/AFNI_CentOS7.img tcsh -xef proc.gufei.run4.pade 2>&1 | tee output.proc.gufei.run4.pade &
srun -c 64 singularity exec ~/AFNI/AFNI_CentOS7.img tcsh -xef proc.gufei.run5.pade 2>&1 | tee output.proc.gufei.run5.pade &
wait

