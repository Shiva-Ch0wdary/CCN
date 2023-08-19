BEGIN{
	st =0
	ft =0
	flag = 0
 	fsize = 0
	throughput = 0
	latency = 0
}
{
if($1 == "r" && $4 == 8){
	fsize += $6
	if(flag ==0)
{
st = $2
flag = 1
}
ft = $2
}
}


END{
	latency =  ft - st
	throughput = (fsize*8)/latency
	printf("\n latency : %f",latency);
	printf("\n Throughput: %f\n", throughput);
	printf("------------------------------------------\n")
}
