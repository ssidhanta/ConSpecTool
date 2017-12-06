/* Subhajit Sidhanta for verifying a given session trace against a ConSpec formula
 * determines if a given session trace satisfies a given consistency model corresponding +
 * to the specified ConSpec formula.
 */
int c;
//mtype = { valid, invalid, blank, r, w, x, y, mmm, nnnn };
mtype = { valid, invalid, blank, r, w, x, y, w_street_1,Kne6UexhDVK6,w_street_2,Fp7mtvJfxMNg,w_city,odOnfkHkuFM5FRBCAqA,w_st_ate,yk,w_zip,vQ0cQwO5s,w_name,iIfX,d_ytd,d_w_id,d_street_1,G2j8q6yixA9l2Sg6Cg,d_street_2,VezdD1jub1RkWBViM,d_city,sAVoD0SqHM,d_st_ate,yp,d_zip,jNxfsoInn,d_name,YxRnsUhmF,c_id,c_first,sSNor25U99fZNbBL,c_middle,E,c_last,ATIONPRICALLY,c_street_1,GHVhP4EaSal,c_street_2,B6Me0h9x5k0QEfqZzw,c_city,dutvz5k2rltiwKFvu,c_st_ate,Li,c_zip,L9MHJ8hvn,c_phone,c_credit,BC,c_credit_lim,c_discount,c_balance,c_since,c_data,GQiALrVZJqgV4r4nq85CogoNygY56ZYoY89IrCTt1oj8HQXhrh1s0y4fuKm1igSVWRODFpRJXjhdqulokocSLyjdTp2nymXoOiLIbUagkQQsKTlj0bOXdScVF96gzOcqOdK4nS1traflGoUZXOsSxXTGMfqCdqoxJCeBSXYfW1oP3D7ZVRUudg6EWk0oS1U08F54HEEjDm1IbHVmQ8uTGnAe7CuJHVZMKcYuDdv2vZR7Gz9DcfXcJH3lF6dTNcKwUzJK2nl3bkQefj1aBUPL0KPT4qU3nWh58QGzE7PRghKF };
typedef Op {
		mtype optype;
		mtype var;
		int val;
}

typedef Ser {
		Op st[5];
		mtype status;
}
Op st[5];
Ser ser[2];
chan STDIN;
bool check = false; /*, flagsercheck = false,*/ 
bool scviol = false; 
/*int wic , wjc , wis , wjs , k , kk ;
ltl c { wic -> <> wjc };
ltl s { wis -> <> wjs };
ltl ryw { wic -> <> wjc -> wis -> <> wjs };*/
ltl sc {  [] ( !scviol)  };
bool flagst, flagser;

proctype checkser(int size, sersize){
	chan flagch = [1] of { bool };
	bool flagsercheck = false;
	int is = 9999, js = 9999, k = 9999, kk = 9999;
	int counter = 0;
	mtype it = r, jt = r;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;
	do
		:: j < sersize ->
			if
				:: (i < size   && k != 9999 && k<size-1 && is != 9999) -> 					
					js = ser[j].st[i].val; 
					jt = ser[j].st[i].optype; 
					 
					atomic {
					run checkcond(size, is, it, js, jt, flagch);
					}
					flagch?flagsercheck;
					
					i++;
				:: flagsercheck == false && j == sersize-1 ->
					scviol = true; printf("check is js pair scviol  in st 2 =%d %d\n",  flagsercheck, scviol); break;
				:: (js != 9999 && flagsercheck == false) ->
					j++; i=0;
				:: (i < size-1 && k == 9999 && is == 9999) -> 	
				        is = ser[j].st[i].val;
					it = ser[j].st[i].optype;
					k = i;
					i++;  
				:: (i < size-1 && k != 9999 && is == 9999) -> 
					i++;
				:: (i>=size && k != 9999 && k<size-1) -> 	
					i=k+1;
					k = 9999; is=9999	  
				:: (i >= size-1 && k == 9999 && is==9999 && j < sersize) ->
					 
					atomic {
					i=0; j++;
					flagsercheck = false;
					flagch!flagsercheck;
					k = 9999; is=9999; js = 9999;
					printf("check is js 5555 pair flagsercheck  in st 1 =%d %d %d %d %d\n",  i, j, k, is, js);
					}
					
				else -> 
					
			fi	
		:: j >= sersize ->
			if
			:: (flagsercheck == false) -> 
				scviol = true; break;
			else -> 
				break;
			fi
			
	od
	/*:: counter >	}*/
}


proctype checkcond(int size, isparam, itparam, jsparam, jtparam; chan flagch){
	bool checkserflag = false;
	int ic  = 9999, jc  = 9999, is = 9999, js = 9999, k = 9999, kk = 9999;
	bool writeFlag, readFlag = false;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;	
	do 
		:: i < size ->
			if	
			:: (i < size && ic == 9999 && st[i].val == isparam && st[i].optype == itparam) -> 
			{
				ic = st[i].val; 
				i++
			}
			:: (i < size && ic == 9999 && st[i].val != isparam) -> 
				i++
			:: (i < size && ic == 9999 && st[i].optype != itparam) -> 
				i++
			:: (i < size && ic != 9999 &&  st[i].val != jsparam) ->
				i++
			:: (i < size && ic != 9999 &&  st[i].optype != jtparam) ->
				i++

			:: (i < size && ic != 9999 &&  st[i].val == jsparam && st[i].optype == jtparam) -> 
			{	
				jc = st[i].val;
				printf("check op-op pair in st =%d %d\n", ic, jc);
				checkserflag = true; 
				flagch! checkserflag;
				break;
				
				
			}
								
			else -> 	
			fi	
		
		:: i >= size ->
			 /*checkserflag = false; 
			 flagch! checkserflag;*/
			 break; 
	od

}


init {
	int size = 4;		
	/*bool inword = false;
	int i = 0, j = 0;
       do
       :: STDIN?c ->
                  if
                 :: c == '!' ->
                          break
                   
		 :: c == '[' ->
                          
		  :: c == ']' ->
                          j = 0
			  i++;
		  :: c == '|' ->
                          j++
		  :: c == 'w' ->
			  ser[i].st[j].optype = w;
		   :: c == 'r' ->
			  ser[i].st[j].optype = r;
		  :: c == 'x' ->
			  ser[i].st[j].var = x;
		  :: c == 'y' ->
			  ser[i].st[j].var = y;
:: c == 'w_street_1' ->
ser[i].st[j].optype = w_street_1;
:: c == 'w_street_2' ->
ser[i].st[j].optype = w_street_2;
:: c == 'w_city' ->
ser[i].st[j].optype = w_city;
:: c == 'w_st_ate' ->
ser[i].st[j].optype = w_st_ate;
:: c == 'w_zip' ->
ser[i].st[j].optype = w_zip;
:: c == 'w_name' ->
ser[i].st[j].optype = w_name;
:: c == 'd_ytd' ->
ser[i].st[j].optype = d_ytd;
:: c == 'd_w_id' ->
ser[i].st[j].optype = d_w_id;
:: c == 'd_street_1' ->
ser[i].st[j].optype = d_street_1;
:: c == 'd_street_2' ->
ser[i].st[j].optype = d_street_2;
:: c == 'd_city' ->
ser[i].st[j].optype = d_city;
:: c == 'd_st_ate' ->
ser[i].st[j].optype = d_st_ate;
:: c == 'd_zip' ->
ser[i].st[j].optype = d_zip;
:: c == 'd_name' ->
ser[i].st[j].optype = d_name;
:: c == 'c_id' ->
ser[i].st[j].optype = c_id;
:: c == 'c_first' ->
ser[i].st[j].optype = c_first;
:: c == 'c_middle' ->
ser[i].st[j].optype = c_middle;
:: c == 'c_last' ->
ser[i].st[j].optype = c_last;
:: c == 'c_street_1' ->
ser[i].st[j].optype = c_street_1;
:: c == 'c_street_2' ->
ser[i].st[j].optype = c_street_2;
:: c == 'c_city' ->
ser[i].st[j].optype = c_city;
:: c == 'c_st_ate' ->
ser[i].st[j].optype = c_st_ate;
:: c == 'c_zip' ->
ser[i].st[j].optype = c_zip;
:: c == 'c_phone' ->
ser[i].st[j].optype = c_phone;
:: c == 'c_credit' ->
ser[i].st[j].optype = c_credit;
:: c == 'c_credit_lim' ->
ser[i].st[j].optype = c_credit_lim;
:: c == 'c_discount' ->
ser[i].st[j].optype = c_discount;
:: c == 'c_balance' ->
ser[i].st[j].optype = c_balance;
:: c == 'c_since' ->
ser[i].st[j].optype = c_since;
:: c == 'c_data' ->
ser[i].st[j].optype = c_data;
:: c == '2404.0' ->
ser[i].st[j].optype = 2404.0;
:: c == 'GQiALrVZJqgV4r4nq85CogoNygY56ZYoY89IrCTt1oj8HQXhrh1s0y4fuKm1igSVWRODFpRJXjhdqulokocSLyjdTp2nymXoOiLIbUagkQQsKTlj0bOXdScVF96gzOcqOdK4nS1traflGoUZXOsSxXTGMfqCdqoxJCeBSXYfW1oP3D7ZVRUudg6EWk0oS1U08F54HEEjDm1IbHVmQ8uTGnAe7CuJHVZMKcYuDdv2vZR7Gz9DcfXcJH3lF6dTNcKwUzJK2nl3bkQefj1aBUPL0KPT4qU3nWh58QGzE7PRghKF' ->
ser[i].st[j].optype = GQiALrVZJqgV4r4nq85CogoNygY56ZYoY89IrCTt1oj8HQXhrh1s0y4fuKm1igSVWRODFpRJXjhdqulokocSLyjdTp2nymXoOiLIbUagkQQsKTlj0bOXdScVF96gzOcqOdK4nS1traflGoUZXOsSxXTGMfqCdqoxJCeBSXYfW1oP3D7ZVRUudg6EWk0oS1U08F54HEEjDm1IbHVmQ8uTGnAe7CuJHVZMKcYuDdv2vZR7Gz9DcfXcJH3lF6dTNcKwUzJK2nl3bkQefj1aBUPL0KPT4qU3nWh58QGzE7PRghKF;
:: c == 'h_c_d_id' ->
ser[i].st[j].optype = h_c_d_id;
:: c == 'h_c_w_id' ->
ser[i].st[j].optype = h_c_w_id;
:: c == 'h_c_id' ->
ser[i].st[j].optype = h_c_id;
:: c == 'h_d_id' ->
ser[i].st[j].optype = h_d_id;
:: c == 'h_w_id' ->
ser[i].st[j].optype = h_w_id;
:: c == 'h_date' ->
ser[i].st[j].optype = h_date;
:: c == 'h_amount' ->
ser[i].st[j].optype = h_amount;
:: c == 'h_data' ->
ser[i].st[j].optype = h_data;
		  :: c == ',' ->
                          
		  :: c == '1' && c != 'w' && c != 'r' && c != 'x' ->
                          ser[i].st[j].val = 1;
		  :: c == '2' && c != 'w' && c != 'r' && c != 'x' ->
                          ser[i].st[j].val = 2;
		  :: else ->
                  
                  fi; 
         od;*/
	
	check = false;  scviol = false; 
	/*run checkltl(size, i)*/
	run checkser(size, 2)
	
}	
