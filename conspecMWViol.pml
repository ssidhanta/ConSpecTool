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
		Op st[6];
		mtype status;
}
Op st[6];
Ser ser[2];
chan STDIN;
bool check = false, flagsercheck = false, mwviol = false; 
/*int wic , wjc , wis , wjs , k , kk ;
ltl c { wic -> <> wjc };
ltl s { wis -> <> wjs };
ltl mw { wic -> <> wjc -> wis -> <> wjs };*/
ltl mw {  [] ( !mwviol)  };
bool flagst, flagser;

proctype checkltl(int size, sersize){
	int i = 0, wic , wjc , wis , wjs , k , kk;
	do
	:: (i  < size && st[i].optype == r && wic == 9999) -> 	
		wic = st[i].val;  i++; 
	:: (i  < size && st[i].optype == r && wic != 9999) ->
		i++
	:: (i  < size && st[i].optype == r && wjc == 9999 &&  wic != 9999) -> 	
		wjc = st[i].val; printf("checkltl 11 res =%d %d\n", wic, wjc); i++; run validateser(size, sersize, wic, wjc); wic = 9999; wjc = 9999
	:: (i  < size && st[i].optype == r && wjc == 9999 &&  wic == 9999) ->
		i++
	:: (i  < size && st[i].optype == r && wjc != 9999) -> 
		i++
	:: i >= size ->
			break;
	od

}

proctype validateser(int size, sersize, wicparam, wjcparam){
	int ii = 0, j = 0, wic , wjc , wis , wjs , k , kk;
	do
		:: j < sersize ->
			if
			:: ii >= size ->
				{ii = 0; j++}
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  r && ser[j].st[ii].val == wicparam) -> 
			{
				wis = ser[j].st[ii].val; 
				ii++;
				
			}
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != wicparam) -> 
			{
				ii++
			}
			:: (ii < size && wis != 9999 && ser[j].st[ii].optype ==  r) -> 
			{
				ii++
			}
			:: (ii < size && wjs == 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val == wjcparam) -> 
				wjs = ser[j].st[ii].val; ii++; 
				flagsercheck = true; printf("checkltl res =%d %d\n", wis, wjs);  wjs = 9999; wis = 9999; flagsercheck = false
			:: (ii < size && wjs != 9999 &&  ser[j].st[ii].optype == r) -> 
			{	 
				ii++
			}
			:: (ii < size && wjs == 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val != wjcparam) -> 
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
	int wic  = 9999, wjc  = 9999, wis = 9999, wjs = 9999, k = 9999, kk = 9999;
	bool writeFlag, readFlag = false;
	int counter = 0;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;
	do
		:: (counter < size && st[counter].optype == w) -> 
					nw++; counter ++
		:: (counter < size && st[counter].optype != w)
					counter ++
		:: counter >= size ->
			break;
				
	od
	
	do 
		:: i < size ->
				
				if
				:: (k != 9999 && wic == 9999 && st[i].optype == w && m<nw) -> 	
					i = k; wic = st[i].val; check = false; 
					/*printf("flagsercheck1 true res =%d %d\n", l, i);*/ 
					k = i; m = i; i++;  
				:: (k != 9999 && wic != 9999 && st[i].optype == w && l<i) -> 					
					l = i;
					/*i = k;*/ 
					wjc = st[i].val; 
					/*printf("check rr pair in st =%d %d\n",  wic, wjc); */
					check = true; 
					wjs = 9999;
					wis = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, wic, wjc);
					}
					wic = 9999;
					wjc = 9999;
					i++ ;
					  
				:: (k != 9999 && wic != 9999 && st[i].optype == w && l>=i) -> 	                    					
					wjc = st[i].val; 
					check = true;
		                        /*printf("check rr pair 1 in st =%d %d\n",  wic, wjc);*/ 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         					wjs = 9999;
					wis = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, wic, wjc);
					}
					/*printf("flagsercheck7 true res =%d %d\n", nw, m);*/ 
					l = i;  wic = 9999;
					wjc = 9999;
					if
					:: (m<nw) -> 
						/*printf("flagsercheck9 true res =%d %d\n", wic, wjc);*/i = m;  
					else ->
						i++
					fi 
				:: (k != 9999 && st[i].optype != w) ->
					i++
				:: (k == 9999 && st[i].optype == w && wic == 9999 && m<nw) -> 
				{
					wic = st[i].val; 
					check = false;
					k = i; m = i;
					/*printf("flagsercheck3 true res =%d %d\n", m, nw);*/					i++
				}
				/*:: (st[i].optype == r && wic != 9999) -> 
				{	 printf("flagsercheck4 true res =%d %d\n", wic, wjc); i++
				}*/
				:: (k == 9999 &&  st[i].optype == w && wic == 9999  && m>=nw) -> 
				{	 i++
				}
				:: (st[i].optype == w && wjc == 9999 && l>=i) -> 
				{	 i++
				}
				:: (st[i].optype == w && wic == 9999 && wjc == 9999 && l<i) -> 
				{	 i++
				}
				:: (st[i].optype == w && wic != 9999 && wjc == 9999 && l<i) -> 
				{
					wjc = st[i].val; 
					/*printf("check wr pair in st =%d %d\n", wic, wjc);
					printf("flagsercheck10 true res =%d %d\n", m, nw);*/
					l = i;
					
					
					check = true;
					wjs = 9999;
					wis = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, wic, wjc);
					}
					wic = 9999;
					wjc = 9999;					check = false;  
					if
					:: (m==nw) -> 
						wic  = 9999; wjc  = 9999; break;
					:: (m<nw) -> 
						/*printf("flagsercheck6 true res =%d %d\n", wic, wjc);*/i = m;  
					else ->
						i++
					fi 

				}
				:: (st[i].optype == w && wjc != 9999) -> 
				/*{	 i = k; printf("flagsercheck6 true res =%d %d\n", wic, wjc); wic = 9999; wjc = 9999; i++
				}*/
				:: (k == 9999 && st[i].optype != w) ->
					i++
				else -> 
				fi	
		
		:: i >= size ->
				wic  = 9999; wjc  = 9999; break; 
	od

}

proctype checkser(int size, sersize, wicparam, wjcparam){
	int wis = 9999, wjs = 9999, k = 0, kk = 9999;
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
				:: (mwviol == true) -> 
					break;
				else ->
					ii = 0; 
					j++;
				fi
			}
			:: (ii < size && wis == 9999 &&  ser[j].st[ii].optype != w) -> 
				ii++
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  w && ser[j].st[ii].val == wicparam) -> 
			{
				wis = ser[j].st[ii].val; 
				ii++
			}
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  w && ser[j].st[ii].val != wicparam) -> 
				ii++
			:: (ii < size && wis != 9999 &&  ser[j].st[ii].optype != w) ->
				ii++
			:: (ii < size && wis != 9999 &&  ser[j].st[ii].optype == w && ser[j].st[ii].val != wjcparam) ->
				ii++
			
			/*::: (ii < size && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != wicparam) -> 
			{
				ii++
			}*/
			:: (ii < size && wis != 9999 &&  ser[j].st[ii].optype == w && ser[j].st[ii].val == wjcparam) -> 
			{	wjs = ser[j].st[ii].val; 
				/*if
				:: (ii >= size && flagsercheck ==  true && j != kk) -> 
					flagsercheck = true;
					ii=size;j = sersize;
					printf("flagsercheck 1 true res =%d %d\n", wis, wjs); 
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
				
				wic = 9999;
				wjc = 9999;
				printf("flagsercheck 0 true res =%d %d\n", j, kk); 
				if
				:: (j == kk || j < sersize-1) -> 
					flagsercheck = true;
				:: (j != kk && j >= sersize-1) -> 
					mwviol = true;
					flagsercheck = false;
				else ->
				{
					flagsercheck = false; 
					mwviol = true;
				}
				fi
				kk = j;
				
				printf("flagsercheck 1 true res =%d %d\n", wis, mwviol); 

				wis = 9999; wjs = 9999;*/
				flagsercheck = true; 
				if
				:: (j == kk) -> 
				:: (j < sersize-1) -> 
				else ->
					mwviol = true;
					break;
				fi
				
				
			}
			:: (ii < size && wis != 9999 &&  ser[j].st[ii].optype == w && ser[j].st[ii].val != wjcparam) ->
				ii++
			:: (ii < size && wis != 9999 &&  ser[j].st[ii].optype != w) ->
				ii++
			:: (ii < size && ser[j].st[ii].optype ==w && ser[j].st[ii].val != wjcparam) -> 
			{
				 ii++
			}
			:: (mwviol == true) ->
				break			
			else -> 	
			fi	
		:: j >= sersize ->
			mwviol = false;/*wis = 9999; wjs = 9999;*/break
	od
	/*:: counter >	}*/
}

init {	
	int size = 6;
	st[0].optype = w;
	st[0].var = x;
	st[0].val = 1;
	st[1].optype = r;
	st[1].var = x;
	st[1].val = 2;
	st[2].optype = w;
	st[2].var = x;
	st[2].val = 2;
	st[3].optype = r;
	st[3].var = x;
	st[3].val = 2;
	st[4].optype = r;
	st[4].var = x;
	st[4].val = 1;
	st[5].optype = r;
	st[5].var = x;
	st[5].val = 2;
	
	ser[0].st[0].optype = w;
	ser[0].st[0].var = x;
	ser[0].st[0].val = 1;
	ser[0].st[1].optype = r;
	ser[0].st[1].var = x;
	ser[0].st[1].val = 1;
	ser[0].st[2].optype = w;
	ser[0].st[2].var = x;
	ser[0].st[2].val = 2;
	ser[0].st[3].optype = r;
	ser[0].st[3].var = x;
	ser[0].st[3].val = 2;
	ser[0].st[4].optype = r;
	ser[0].st[4].var = x;
	ser[0].st[4].val = 2;
	ser[0].st[5].optype = r;
	ser[0].st[5].var = x;
	ser[0].st[5].val = 2;
	
	ser[1].st[0].optype = w;
	ser[1].st[0].var = x;
	ser[1].st[0].val = 2;
	ser[1].st[1].optype = r;
	ser[1].st[1].var = x;
	ser[1].st[1].val = 2;
	ser[1].st[2].optype = r;
	ser[1].st[2].var = x;
	ser[1].st[2].val = 2;
	ser[1].st[3].optype = r;
	ser[1].st[3].var = x;
	ser[1].st[3].val = 2;
	ser[1].st[4].optype = w;
	ser[1].st[4].var = x;
	ser[1].st[4].val = 1;
	ser[1].st[5].optype = r;
	ser[1].st[5].var = x;
	ser[1].st[5].val = 1;
		
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
	check = false; flagsercheck = false; mwviol = false; 
	/*run checkltl(size, i)*/
	run checkcond(size, 2)
	
}	