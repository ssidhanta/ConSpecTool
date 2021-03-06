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
bool check = false; /*, flagsercheck = false,*/ 
bool pcviol = false; 
/*int wic , wjc , wis , wjs , k , kk ;
ltl c { wic -> <> wjc };
ltl s { wis -> <> wjs };
ltl ryw { wic -> <> wjc -> wis -> <> wjs };*/
ltl pc {  [] ( !pcviol)  };
bool flagst, flagser;

proctype checkser(int size, sersize){
	chan flagch = [1] of { bool };
	bool flagsercheck = false, flagsercheck1 = false;
	int wis = 9999, wjs = 9999, ris = 9999, rjs = 9999, k = 0, kk = 9999;
	int counter = 0;
	
	int i = 0, j = 0, l = -9999,ll = -9999, m = -9999, n = -9999, nw = 0, nr = 0;
	do
		:: (counter < size && st[counter].optype == w) -> 
					nw++; counter ++
		:: (counter < size && st[counter].optype != w)
					nr++; counter ++
		:: counter >= size ->
			break;
				
	od
	do
		:: j < sersize ->
			if
				:: (i < size && k != 9999 && wis == 9999 && ser[j].st[i].optype == w && m<nw) -> 	
					i = k; wis = ser[j].st[i].val; check = false; 
					/*printf("flagsercheck1 true res =%d %d\n", l, i);*/ 
					k = i; m = i; i++;  
				:: (i < size && kk != 9999 && ris == 9999 && ser[j].st[i].optype == r && n<nr) -> 	
					i = kk; ris = ser[j].st[i].val; check = false; 
					/*printf("flagsercheck1 true res =%d %d\n", l, i);*/ 
					kk = i; n = i; i++; 
				:: (i < size && k != 9999 && wis != 9999 && ser[j].st[i].optype == w && l<i) -> 					
					l = i;
					/*i = k;*/ 
					wjs = ser[j].st[i].val; 
					/*printf("check rr pair in st =%d %d\n",  wic, wjc); */
					check = true; 
					atomic {
					run checkcond(size, wis, wjs, flagch);
					}
					flagch?flagsercheck;
					wis = 9999;
					wjs = 9999;
					i++ ;
				:: (i < size && kk != 9999 && ris != 9999 && ser[j].st[i].optype == r && ll<i) -> 					
					ll = i;
					/*i = k;*/ 
					rjs = ser[j].st[i].val; 
					/*printf("check rr pair in st =%d %d\n",  wic, wjc); */
					check = true; 
					atomic {
					run checkcond1(size, ris, rjs, flagch);
					}
					flagch?flagsercheck1;
					ris = 9999;
					rjs = 9999;
					i++ ;	  
				:: (i < size && k != 9999 && wis != 9999 && ser[j].st[i].optype == w && l>=i) -> 	                    					
					wjs = ser[j].st[i].val; 
					check = true;
		                        /*printf("check rr pair 1 in st =%d %d\n",  wic, wjc);*/ 
                                        
					atomic {
					run checkcond(size, wis, wjs, flagch);
					}
					flagch?flagsercheck;
					/*printf("flagsercheck7 true res =%d %d\n", nw, m);*/ 
					l = i;  wis = 9999;
					wjs = 9999;
					if
					:: (m<nw) -> 
						/*printf("flagsercheck9 true res =%d %d\n", wic, wjc);*/i = m;  
					else ->
						i++
					fi 
				:: (i < size && kk != 9999 && ris != 9999 && ser[j].st[i].optype == r && ll>=i) -> 	                    					
					rjs = ser[j].st[i].val; 
					check = true;
		                        /*printf("check rr pair 1 in st =%d %d\n",  wic, wjc);*/ 
                                        
					atomic {
					run checkcond1(size, ris, rjs, flagch);
					}
					flagch?flagsercheck1;
					/*printf("flagsercheck7 true res =%d %d\n", nw, m);*/ 
					ll = i;  ris = 9999;
					rjs = 9999;
					if
					:: (n<nr) -> 
						/*printf("flagsercheck9 true res =%d %d\n", wic, wjc);*/i = m;  
					else ->
						i++
					fi 
				:: (i < size && k != 9999 && ser[j].st[i].optype != w) ->
					i++
				:: (i < size && kk != 9999 && ser[j].st[i].optype != r) ->
					i++
				:: (i < size && k == 9999 && ser[j].st[i].optype == w && wis == 9999 && m<nw) -> 
				{
					wis = ser[j].st[i].val; 
					k = i; m = i;
					/*printf("flagsercheck3 true res =%d %d\n", m, nw);*/					i++
				}
				:: (i < size && kk == 9999 && ser[j].st[i].optype == r && ris == 9999 && n<nr) -> 
				{
					ris = ser[j].st[i].val; 
					kk = i; n = i;
					/*printf("flagsercheck3 true res =%d %d\n", m, nw);*/					i++
				}
				/*:: (ser[j].st[i].optype == r && wis != 9999) -> 
				{	 printf("flagsercheck4 true res =%d %d\n", wic, wjc); i++
				}*/
				:: (i < size && k == 9999 &&  ser[j].st[i].optype == w && wis == 9999  && m>=nw) -> 
				{	 i++
				}
				:: (i < size && kk == 9999 &&  ser[j].st[i].optype == r && ris == 9999  && n>=nr) -> 
				{	 i++
				}
				:: (i < size && ser[j].st[i].optype == w && wjs == 9999 && l>=i) -> 
				{	 i++
				}
				:: (i < size && ser[j].st[i].optype == r && rjs == 9999 && ll>=i) -> 
				{	 i++
				}
				:: (i < size && ser[j].st[i].optype == w && wis == 9999 && wjs == 9999 && l<i) -> 
				{	 i++
				}
				:: (i < size && ser[j].st[i].optype == r && ris == 9999 && rjs == 9999 && ll<i) -> 
				{	 i++
				}
				:: (i < size && ser[j].st[i].optype == w && wis != 9999 && wjs == 9999 && l<i) -> 
				{
					wjs = ser[j].st[i].val; 
					/*printf("check wr pair in st =%d %d\n", wic, wjc);
					printf("flagsercheck10 true res =%d %d\n", m, nw);*/
					l = i;
					
					
					check = true;
					atomic {
					run checkcond(size, wis, wjs, flagch);
					}
					flagch?flagsercheck;
					wis = 9999;
					wjs = 9999;					check = false;  
					if
					:: (m==nw) -> 
						wis  = 9999; wjs  = 9999; break;
					:: (m<nw) -> 
						/*printf("flagsercheck6 true res =%d %d\n", wic, wjc);*/i = m;  
					else ->
						i++
					fi 

				}
				:: (i < size && ser[j].st[i].optype == r && ris != 9999 && rjs == 9999 && ll<i) -> 
				{
					rjs = ser[j].st[i].val; 
					/*printf("check wr pair in st =%d %d\n", wic, wjc);
					printf("flagsercheck10 true res =%d %d\n", m, nw);*/
					ll = i;
					
					
					check = true;
					atomic {
					run checkcond1(size, ris, rjs, flagch);
					}
					flagch?flagsercheck1;
					ris = 9999;
					rjs = 9999;					check = false;  
					if
					:: (n==nr) -> 
						ris  = 9999; rjs  = 9999; break;
					:: (n<nr) -> 
						/*printf("flagsercheck6 true res =%d %d\n", wic, wjc);*/i = n;  
					else ->
						i++
					fi 

				}
				:: (i < size && ser[j].st[i].optype == w && wjs != 9999) -> 
				/*{	 i = k; printf("flagsercheck6 true res =%d %d\n", wic, wjc); wic = 9999; wjc = 9999; i++
				}*/
				:: (i < size && ser[j].st[i].optype == r && rjs != 9999) -> 
				/*{	 i = k; printf("flagsercheck6 true res =%d %d\n", wic, wjc); wic = 9999; wjc = 9999; i++
				}*/
				:: (i < size && k == 9999 && ser[j].st[i].optype != w) ->
					i++
				:: (i < size && kk == 9999 && ser[j].st[i].optype != r) ->
					i++
				:: i >= size ->
				{
					i = 0; j++;
					if
					:: (flagsercheck == true || flagsercheck1 == true) -> 
						break; j = sersize;
					:: (flagsercheck == false || flagsercheck1 == false) -> 
						i = 0; j++; break
					fi
				}	
				else -> 
				fi	
		:: j >= sersize ->
			if
			:: (flagsercheck == false || flagsercheck1 == false) -> 
				pcviol = true; break;
			else -> 
				break;
			fi
			
	od
	/*:: counter >	}*/
}


proctype checkcond(int size, wisparam, wjsparam; chan flagch){
	bool checkserflag = false, checkserflag1 = false;
	int wic  = 9999, wjc  = 9999, wis = 9999, wjs = 9999, k = 9999, kk = 9999;
	bool writeFlag, readFlag = false;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;	
	do 
		:: i < size ->
			if	
			:: (i < size && wic == 9999 &&  st[i].optype != w) -> 
				i++
			:: (i < size && wic == 9999 && st[i].optype ==  w && st[i].val == wisparam) -> 
			{
				wic = st[i].val; 
				i++
			}
			:: (i < size && wic == 9999 && st[i].optype ==  w && st[i].val != wisparam) -> 
				i++
			:: (i < size && wic != 9999 &&  st[i].optype != w) ->
				i++
			:: (i < size && wic != 9999 &&  st[i].optype == w && st[i].val != wjsparam) ->
				i++
			
			/*::: (ii < size && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != wicparam) -> 
			{
				ii++
			}*/
			:: (i < size && wic != 9999 &&  st[i].optype == w && st[i].val == wjsparam) -> 
			{	
				wjc = ser[j].st[i].val;
				printf("check ww pair in st =%d %d\n", wic, wjc);
				checkserflag = true; 
				flagch! checkserflag;
				break;
				
				
			}
			:: (i < size && wic != 9999 &&  st[i].optype == w && st[i].val != wjsparam) ->
				i++
			:: (i < size && wic != 9999 &&  st[i].optype != w) ->
				i++
			:: (i < size && st[i].optype ==w && st[i].val != wjsparam) -> 
			{
				 i++
			}			
			else -> 	
			fi	
		
		:: i >= size ->
			 flagch! checkserflag;/*flagsercheck = false;*/ break; 
	od

}

proctype checkcond1(int size, risparam, rjsparam; chan flagch){
	bool checkserflag = false;
	int ric  = 9999, rjc  = 9999, ris = 9999, rjs = 9999, k = 9999, kk = 9999;
	bool writeFlag, readFlag = false;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;	
	do 
		:: i < size ->
			if	
			:: (i < size && ric == 9999 &&  st[i].optype != r) -> 
				i++
			:: (i < size && ric == 9999 && st[i].optype ==  r && st[i].val == risparam) -> 
			{
				ric = st[i].val; 
				i++
			}
			:: (i < size && ric == 9999 && st[i].optype ==  r && st[i].val != risparam) -> 
				i++
			:: (i < size && ric != 9999 &&  st[i].optype != r) ->
				i++
			:: (i < size && ric != 9999 &&  st[i].optype == r && st[i].val != rjsparam) ->
				i++
			
			/*::: (ii < size && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != wicparam) -> 
			{
				ii++
			}*/
			:: (i < size && ric != 9999 &&  st[i].optype == r && st[i].val == rjsparam) -> 
			{	
				rjc = ser[j].st[i].val;
				printf("check ww pair in st =%d %d\n", ric, rjc);
				checkserflag = true; 
				flagch! checkserflag;
				break;
				
				
			}
			:: (i < size && ric != 9999 &&  st[i].optype == r && st[i].val != rjsparam) ->
				i++
			:: (i < size && ric != 9999 &&  st[i].optype != r) ->
				i++
			:: (i < size && st[i].optype ==r && st[i].val != rjsparam) -> 
			{
				 i++
			}			
			else -> 	
			fi	
		
		:: i >= size ->
			 flagch! checkserflag;/*flagsercheck = false;*/ break; 
	od

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
	
	check = false;  pcviol = false; 
	/*run checkltl(size, i)*/
	run checkser(size, 2)
	
}	