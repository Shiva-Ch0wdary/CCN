BEGIN{
	rec =0
	drop =0
	total = 0
}
{
if($1 == "r" && $4 == 8){
	rec++
}
if($1=="d" && $4==1)
{
drop++
}
}
END{
	total=rec+drop
	ratio = (rec/total)*100
	printf("\n Total Packet Sent : %d",total);
	printf("\n Total Packet Recieved  : %d",rec);
	printf("\n Packet Delivery Ratio: %f \n", ratio);
	printf("------------------------------------------\n")
}
