#!/bin/tcsh


# - basis functions should be consistent across classes
#   i.e. should not mix GAM/BLOCK
# - SPMG1 is okay, but no multi-component functions (AM/DM/IM are okay)

# generate PPI regressors: no 3dD commands

# inputs
#   - stim timing files/labels/durations
#   - PPI label (e.g. Lamy.test1)
#   - seed time series (afni_proc.py can generate example)
#   - NT per run, TR, TRnup
set seedlabel = $1

set stim_labs = ( FearPleaVis FearPleaInv FearUnpleaVis FearUnpleaInv \
    HappPleaVis HappPleaInv HappUnpleaVis HappUnpleaInv)
set stim_files = ( ../stimuli/FearPleaVis.txt ../stimuli/FearPleaInv.txt \
    ../stimuli/FearUnpleaVis.txt ../stimuli/FearUnpleaInv.txt \
    ../stimuli/HappPleaVis.txt ../stimuli/HappPleaInv.txt \
    ../stimuli/HappUnpleaVis.txt ../stimuli/HappUnpleaInv.txt)
set stim_dur  = ( 10 10 10 10 10 10 10 10 )       # durations, in seconds

set seed = ppi.seed.$seedlabel.1D
set plabel = $seedlabel

set basis = BLOCK               # matches basis type in main analysis

set NT = ( 196 196 196 196 196)        # num time points per run
set TR = 2.0
set TRnup = 10                  # oversample rate

# compute some items
# rcr - validate TRup (TR must be an integral multiple of TRup)
set TRup = 0.2          # basically TR/TRnup
set demean_psych = 0    # usually 0 (for comparison, should not matter)

set nstim = $#stim_files
set run_lens = ( 392 392 392 392 392 )  # run lengths, in seconds

set workdir = ./
set timingdir = timing.files

# =================================================================
# create output directories and copy inputs there
mkdir $workdir/$timingdir

cp -pv $stim_files $workdir/$timingdir
cp -pv $seed $workdir
set seed = $seed:t

set bind = 0
cd $workdir

# =================================================================
# generate ideal IRF
#
# This generates the impulse response function for the deconvolution
# and recovolution steps.  It is the expected response to a ~zero
# duration event.

if ( $basis == GAM ) then

   # number of time points = duration / upsampled TR
   set dur = 12         # use a 12 second curve for GAM
   set nt_irf = `ccalc -i "$dur/$TRup"`

   set hrf_file = x.GAM.1D
   3dDeconvolve -nodata $nt_irf 0.1 -polort -1  \
                -num_stimts 1                   \
                -stim_times 1 1D:0 GAM          \
                -x1D $hrf_file -x1D_stop

else if ( $basis == BLOCK ) then

   # number of time points = duration / upsampled TR
   set dur = 15         # use a 15 second curve for BLOCK
   set nt_irf = `ccalc -i "$dur/$TRup"`

   set hrf_file = x.BLOCK.1D
   3dDeconvolve -nodata $nt_irf 0.1 -polort -1    \
                -num_stimts 1                     \
                -stim_times 1 1D:0 "BLOCK(0.1,1)" \
                -x1D $hrf_file -x1D_stop

else
   echo "** invalid basis $basis, should be BLOCK or GAM (or SPMG1)"
   exit 1
endif


# =================================================================
# p1 create timing partition files

@ bind ++
set prefix = p$bind.$plabel
set timing_prefix = $prefix

foreach sind ( `count -digits 1 1 $nstim` )
   set sind2 = `ccalc -form '%02d' $sind`
   set tfile = $timingdir/$stim_files[$sind]:t
   set label = $stim_labs[$sind]

   if ( ! -f $tfile ) then
      echo "** missing timing file $tfile"
      exit 1
   endif

   timing_tool.py -timing $tfile                \
         -tr $TRup -stim_dur $stim_dur[$sind]   \
         -run_len $run_lens                     \
         -min_frac 0.3                          \
         -timing_to_1D $timing_prefix.$sind2.$label \
         -per_run_file -show_timing 

   # optionally replace psychological variables with de-meaned versions
   if ( $demean_psych ) then
      set mean = `cat $timing_prefix.$sind2.* | 3dTstat -prefix - 1D:stdin\'`
      echo "-- mean of psych '$label' files = $mean"
      foreach file ( $timing_prefix.$sind2.$label* )
         1deval -a $file -expr "a-$mean" > rm.1D
         mv rm.1D $file
      end
   endif
end


# =================================================================
# p2 upsample seed

@ bind ++
set prefix = p$bind.$plabel

# break into n runs

@ rend   = - 1
foreach rind ( `count -digits 1 1 $#NT` )
   @ rstart = $rend + 1  # start after prior endpoint
   @ rend += $NT[$rind]
   1dcat $seed"{$rstart..$rend}" | 1dUpsample $TRnup stdin: \
         > $prefix.seed.$TRnup.r$rind.1D
end

set seed_up = $prefix.seed.$TRnup.rall.1D
cat $prefix.seed.$TRnup.r[0-9]*.1D > $seed_up

# =================================================================
# p3 deconvolve

set pprev = $prefix
@ bind ++
set prefix = p$bind.$plabel
set neuro_prefix = $prefix

foreach rind ( `count -digits 1 1 $#NT` )
   3dTfitter -RHS $pprev.seed.$TRnup.r$rind.1D                  \
             -FALTUNG $hrf_file temp.1D 012 -2  \
             -l2lasso -6
   1dtranspose temp.1D > $prefix.neuro.r$rind.1D
end


# ===========================================================================
# p4 partition neuro seeds

set pprev = $prefix
@ bind ++
set prefix = p$bind.$plabel

foreach sind ( `count -digits 1 1 $nstim` )
   set sind2 = `ccalc -form '%02d' $sind`
   set slab = $sind2.$stim_labs[$sind]

   foreach rind ( `count -digits 1 1 $#NT` )
      set neuro_seed = $neuro_prefix.neuro.r$rind.1D
      set rind2 = `ccalc -form '%02d' $rind`
      @ nt = $NT[$rind] * $TRnup

      # note partition files: 1 input, 2 outputs
      set stim_part = $timing_prefix.${slab}_r$rind2.1D
      set neuro_part = $prefix.a.$slab.r$rind.neuro_part.1D
      set recon_part = $prefix.b.$slab.r$rind.reBOLD.1D

      1deval -a $neuro_seed -b $stim_part -expr 'a*b' > $neuro_part

      waver -FILE $TRup $hrf_file -input $neuro_part -numout $nt > $recon_part
   end

   # and generate upsampled seeds that span runs
   cat $prefix.b.$slab.r*.reBOLD.1D > $prefix.d.$slab.rall.reBOLD.1D
end

# and generate corresponding (reBOLD) seed time series
foreach rind ( `count -digits 1 1 $#NT` )
   set neuro_seed = $neuro_prefix.neuro.r$rind.1D
   waver -FILE $TRup $hrf_file -input $neuro_seed -numout $nt \
         > $prefix.c.seed.r$rind.reBOLD.1D
end

# to compare with $seed_up
3dMean -sum -prefix - $prefix.d.[0-9]*.1D > $prefix.d.task.rall.reBOLD.1D
cat $prefix.c.seed.r*.reBOLD.1D > $prefix.d.seed.rall.reBOLD.1D
echo == can compare upsampled seeds: \
	$seed_up $prefix.d.{seed,task}.rall.reBOLD.1D
set seed_rebold_up = $prefix.d.seed.rall.reBOLD.1D


# ===========================================================================
# p5 downsample

set pprev = $prefix
@ bind ++
set prefix = p$bind.$plabel

foreach rind ( `count -digits 1 1 $#NT` )
   set neuro_seed = $neuro_prefix.neuro.r$rind.1D
   @ nt = $NT[$rind] * $TRnup

   foreach sind ( `count -digits 1 1 $nstim` )
      set sind2 = `ccalc -form '%02d' $sind`
      set recon_part = $pprev.b.$sind2.$stim_labs[$sind].r$rind.reBOLD.1D
      set recon_down = $prefix.$sind2.$stim_labs[$sind].r$rind.PPIdown.1D

      1dcat $recon_part'{0..$('$TRnup')}' > $recon_down
   end

end
# and downsample filtered seed time series
1dcat $seed_rebold_up'{0..$('$TRnup')}' > $seed:r.reBOLD.1D


# ===========================================================================
# p6 catentate across runs: final PPI regressors

set pprev = $prefix
@ bind ++
set prefix = p$bind.$plabel

foreach sind ( `count -digits 1 1 $nstim` )
   set sind2 = `ccalc -form '%02d' $sind`
   set slab = $sind2.$stim_labs[$sind]

   cat $pprev.$slab.r*.PPIdown.1D > $prefix.$slab.rall.PPI.1D
end
