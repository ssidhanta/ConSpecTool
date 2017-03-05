/* Subhajit Sidhanta for verifying a given session trace against a ConSpec formula
 * determines if a given session trace satisfies a given consistency model corresponding +
 * to the specified ConSpec formula.
 */
int c;
mtype = { valid, invalid, blank, r, w, x, y };
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
bool check = false, flagsercheck = false, mrviol = false; 
/*int ric , rjc , ris , rjs , k , kk ;
ltl c { ric -> <> rjc };
ltl s { ris -> <> rjs };
ltl mr { ric -> <> rjc -> ris -> <> rjs };*/
ltl mr {  [] ( !mrviol)  };
bool flagst, flagser;

proctype checkltl(int size, sersize){
	int i = 0, ric , rjc , ris , rjs , k , kk;
	do
	:: (i  < size && st[i].optype == r && ric == 9999) -> 	
		ric = st[i].val;  i++; 
	:: (i  < size && st[i].optype == r && ric != 9999) ->
		i++
	:: (i  < size && st[i].optype == r && rjc == 9999 &&  ric != 9999) -> 	
		rjc = st[i].val; printf("checkltl 11 res =%d %d\n", ric, rjc); i++; run validateser(size, sersize, ric, rjc); ric = 9999; rjc = 9999
	:: (i  < size && st[i].optype == r && rjc == 9999 &&  ric == 9999) ->
		i++
	:: (i  < size && st[i].optype == r && rjc != 9999) -> 
		i++
	:: i >= size ->
			break;
	od

}

proctype validateser(int size, sersize, ricparam, rjcparam){
	int ii = 0, j = 0, ric , rjc , ris , rjs , k , kk;
	do
		:: j < sersize ->
			if
			:: ii >= size ->
				{ii = 0; j++}
			:: (ii < size && ris == 9999 && ser[j].st[ii].optype ==  r && ser[j].st[ii].val == ricparam) -> 
			{
				ris = ser[j].st[ii].val; 
				ii++;
				
			}
			:: (ii < size && ris == 9999 && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != ricparam) -> 
			{
				ii++
			}
			:: (ii < size && ris != 9999 && ser[j].st[ii].optype ==  r) -> 
			{
				ii++
			}
			:: (ii < size && rjs == 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val == rjcparam) -> 
				rjs = ser[j].st[ii].val; ii++; 
				flagsercheck = true; printf("checkltl res =%d %d\n", ris, rjs);  rjs = 9999; ris = 9999; flagsercheck = false
			:: (ii < size && rjs != 9999 &&  ser[j].st[ii].optype == r) -> 
			{	 
				ii++
			}
			:: (ii < size && rjs == 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val != rjcparam) -> 
			{	 
				ii++
			}			
			else -> 	
			fi	
		:: j >= sersize ->
			break
	od
	/*:: counter >	}*/
}



proctype checkcond(int size, sersize){
	int ric  = 9999, rjc  = 9999, ris = 9999, rjs = 9999, k = 9999, kk = 9999;
	bool writeFlag, readFlag = false;
	int counter = 0;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;
	do
		:: (counter < size && st[counter].optype == r) -> 
					nw++; counter ++
		:: (counter < size && st[counter].optype != r)
					counter ++
		:: counter >= size ->
			break;
				
	od
	
	do 
		:: i < size ->
				
				if
				:: (k != 9999 && ric == 9999 && st[i].optype == r && m<nw) -> 	
					i = k; ric = st[i].val; check = false; 
					/*printf("flagsercheck1 true res =%d %d\n", l, i);*/ 
					k = i; m = i; i++;  
				:: (k != 9999 && ric != 9999 && st[i].optype == r && l<i) -> 					
					l = i;
					/*i = k;*/ 
					rjc = st[i].val; 
					/*printf("check rr pair in st =%d %d\n",  ric, rjc); */
					check = true; 
					rjs = 9999;
					ris = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, ric, rjc);
					}
					ric = 9999;
					rjc = 9999;
					i++ ;
					  
				:: (k != 9999 && ric != 9999 && st[i].optype == r && l>=i) -> 	                    					
					rjc = st[i].val; 
					check = true;
		                        /*printf("check rr pair 1 in st =%d %d\n",  ric, rjc);*/ 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         					rjs = 9999;
					ris = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, ric, rjc);
					}
					/*printf("flagsercheck7 true res =%d %d\n", nw, m);*/ 
					l = i;  ric = 9999;
					rjc = 9999;
					if
					:: (m<nw) -> 
						/*printf("flagsercheck9 true res =%d %d\n", ric, rjc);*/i = m;  
					else ->
						i++
					fi 
				:: (k != 9999 && st[i].optype != r) ->
					i++
				:: (k == 9999 && st[i].optype == r && ric == 9999 && m<nw) -> 
				{
					ric = st[i].val; 
					check = false;
					k = i; m = i;
					/*printf("flagsercheck3 true res =%d %d\n", m, nw);*/					i++
				}
				/*:: (st[i].optype == r && ric != 9999) -> 
				{	 printf("flagsercheck4 true res =%d %d\n", ric, rjc); i++
				}*/
				:: (k == 9999 &&  st[i].optype == r && ric == 9999  && m>=nw) -> 
				{	 i++
				}
				:: (st[i].optype == r && rjc == 9999 && l>=i) -> 
				{	 i++
				}
				:: (st[i].optype == r && ric == 9999 && rjc == 9999 && l<i) -> 
				{	 i++
				}
				:: (st[i].optype == r && ric != 9999 && rjc == 9999 && l<i) -> 
				{
					rjc = st[i].val; 
					/*printf("check wr pair in st =%d %d\n", ric, rjc);
					printf("flagsercheck10 true res =%d %d\n", m, nw);*/
					l = i;
					
					
					check = true;
					rjs = 9999;
					ris = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, ric, rjc);
					}
					ric = 9999;
					rjc = 9999;					check = false;  
					if
					:: (m==nw) -> 
						ric  = 9999; rjc  = 9999; break;
					:: (m<nw) -> 
						/*printf("flagsercheck6 true res =%d %d\n", ric, rjc);*/i = m;  
					else ->
						i++
					fi 

				}
				:: (st[i].optype == r && rjc != 9999) -> 
				/*{	 i = k; printf("flagsercheck6 true res =%d %d\n", ric, rjc); ric = 9999; rjc = 9999; i++
				}*/
				:: (k == 9999 && st[i].optype != r) ->
					i++
				else -> 
				fi	
		
		:: i >= size ->
				ric  = 9999; rjc  = 9999; break; 
	od

}

proctype checkser(int size, sersize, ricparam, rjcparam){
	int ris = 9999, rjs = 9999, k = 0, kk = 9999;
	int counter = 0;
	int ii = 0, j = 0;
	do
		:: j < sersize ->
			if
			/*:: (kk != 9999) -> 	
					j = kk	
			:: (check == false) ->
					j++*/	
			:: ii >= size ->
			{
				if
				:: (mrviol == true) -> 
					break;
				else ->
					ii = 0; 
					j++;
				fi
			}
			:: (ii < size && ris == 9999 &&  ser[j].st[ii].optype != r) -> 
				ii++
			:: (ii < size && ris == 9999 && ser[j].st[ii].optype ==  r && ser[j].st[ii].val == ricparam) -> 
			{
				ris = ser[j].st[ii].val; 
				ii++
			}
			:: (ii < size && ris == 9999 && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != ricparam) -> 
				ii++
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype != r) ->
				ii++
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val != rjcparam) ->
				ii++
			
			/*::: (ii < size && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != ricparam) -> 
			{
				ii++
			}*/
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val == rjcparam) -> 
			{	rjs = ser[j].st[ii].val; 
				/*if
				:: (ii >= size && flagsercheck ==  true && j != kk) -> 
					flagsercheck = true;
					ii=size;j = sersize;
					printf("flagsercheck 1 true res =%d %d\n", ris, rjs); 
				:: (ii < size) -> 
				{
					flagsercheck = true;
					ii=size; j = sersize;
					printf("flagsercheck 2 true res =%d %d\n", kk, j); 
				}
				else ->
				{
					flagsercheck = true; j = sersize;
					printf("flagsercheck 3 true res =%d %d\n", kk, j); 
				}
				fi
				
				ric = 9999;
				rjc = 9999;
				printf("flagsercheck 0 true res =%d %d\n", j, kk); 
				if
				:: (j == kk || j < sersize-1) -> 
					flagsercheck = true;
				:: (j != kk && j >= sersize-1) -> 
					mrviol = true;
					flagsercheck = false;
				else ->
				{
					flagsercheck = false; 
					mrviol = true;
				}
				fi
				kk = j;
				
				printf("flagsercheck 1 true res =%d %d\n", ris, mrviol); 

				ris = 9999; rjs = 9999;*/
				flagsercheck = true; 
				if
				:: (j == kk) -> 
				:: (j < sersize-1) -> 
				else ->
					mrviol = true;
					break;
				fi
				
				
			}
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val != rjcparam) ->
				ii++
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype != r) ->
				ii++
			:: (ii < size && ser[j].st[ii].optype ==r && ser[j].st[ii].val != rjcparam) -> 
			{
				 ii++
			}
			:: (mrviol == true) ->
				break			
			else -> 	
			fi	
		:: j >= sersize ->
			mrviol = false;/*ris = 9999; rjs = 9999;*/break
	od
	/*:: counter >	}*/
}

init {

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
		  :: c == ',' ->
                          
		  :: c == '1' && c != 'w' && c != 'r' && c != 'x' ->
                          ser[i].st[j].val = 1;
		  :: c == '2' && c != 'w' && c != 'r' && c != 'x' ->
                          ser[i].st[j].val = 2;
		  :: else ->
                  
                  fi; 
         od;*/
	check = false; flagsercheck = false; mrviol = false; 
	/*run checkltl(size, i)*/
	run checkcond(size, 2)
	
}	