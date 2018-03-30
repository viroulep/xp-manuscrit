import subprocess

for titi in [2, 4, 8, 16, 32, 48, 64, 96, 128, 144, 176, 192]:
  print titi

  inter = "0"
  for i in xrange(0, int(titi)/8):
    if i != 0:
      inter += ","+str(i)

  places = ""
  if titi <= 96:
    places = "{0}:"+str(titi)+":2"
  else:
    places = "{0}:96:2,{1}:"+str(titi-96)+":2"
  places = "threads("+str(titi)+")"


  cmd = "OMP_NUM_THREADS="+str(titi)+" OMP_PLACES=\""+places+"\" OMP_DISPLAY_ENV=true KAAPI_RECORD_TRACE=1 KAAPI_RECORD_MASK=compute,omp KAAPI_PERF_EVENTS=task KAAPI_TASKPERF_EVENTS=work,time KAAPI_DISPLAY_PERF=final LD_PRELOAD=$HOME/local/lib/trace-libomp.so numactl -i "+inter+" ../dpotrf_taskdep -i 5 -n 8192 -b 224 > run_"+str(titi)
  print cmd
  subprocess.call(cmd, shell=True)
