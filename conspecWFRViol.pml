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
		Op st[7];
		mtype status;
}
Op st[7];
Ser ser[2];
chan STDIN;
bool check = false, flagsercheck = false, wfrviol = false; 
/*int wic , rjc , wis , rjs , k , kk ;
ltl c { wic -> <> rjc };
ltl s { wis -> <> rjs };
ltl wfr { wic -> <> rjc -> wis -> <> rjs };*/
ltl wfr {  [] ( !wfrviol)  };
bool flagst, flagser;

proctype checkltl(int size, sersize){
	int i = 0, wic , rjc , wis , rjs , k , kk;
	do
	:: (i  < size && st[i].optype == w && wic == 9999) -> 	
		wic = st[i].val;  i++; 
	:: (i  < size && st[i].optype == w && wic != 9999) ->
		i++
	:: (i  < size && st[i].optype == r && rjc == 9999 &&  wic != 9999) -> 	
		rjc = st[i].val; printf("checkltl 11 res =%d %d\n", wic, rjc); i++; run validateser(size, sersize, wic, rjc); wic = 9999; rjc = 9999
	:: (i  < size && st[i].optype == r && rjc == 9999 &&  wic == 9999) ->
		i++
	:: (i  < size && st[i].optype == r && rjc != 9999) -> 
		i++
	:: i >= size ->
			break;
	od

}

proctype validateser(int size, sersize, wicparam, rjcparam){
	int ii = 0, j = 0, wic , rjc , wis , rjs , k , kk;
	do
		:: j < sersize ->
			if
			:: ii >= size ->
				{ii = 0; j++}
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  w && ser[j].st[ii].val == wicparam) -> 
			{
				wis = ser[j].st[ii].val; 
				ii++;
				
			}
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  w && ser[j].st[ii].val != wicparam) -> 
			{
				ii++
			}
			:: (ii < size && wis != 9999 && ser[j].st[ii].optype ==  w) -> 
			{
				ii++
			}
			:: (ii < size && rjs == 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val == rjcparam) -> 
				rjs = ser[j].st[ii].val; ii++; 
				flagsercheck = true; printf("checkltl res =%d %d\n", wis, rjs);  rjs = 9999; wis = 9999; flagsercheck = false
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
	int ric  = 9999, wjc  = 9999, ris = 9999, wjs = 9999, k = 9999, kk = 9999;
	bool writeFlag, readFlag = false;
	int counter = 0;
	int i = 0, j = 0, l = -9999, m = -9999, nw = 0;
	do
		:: (counter < size && st[counter].optype == r) -> 
					nw++; counter ++
		:: (counter < size && st[counter].optype == w)
					counter ++
		:: counter >= size ->
			break;
				
	od
	
	do 
		:: i < size ->
				
				if
				:: (k != 9999 && ric == 9999 && st[k].optype == r && m<nw && i < nw) -> 	
					i = k; ric = st[i].val; check = false; /*printf("flagsercheck1 true res =%d %d\n", l, i);*/ i++; m = i;  k = 9999; 
				:: (k != 9999 && ric != 9999 && st[k].optype == w && l<i) -> 					l = i;
					/*i = k;*/ 
					wjc = st[i].val; 
					printf("check wr pair in st =%d %d\n",  ric, wjc); 
					check = true; 
					wjs = 9999;
					ris = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, ric, wjc);
					}
					i++ ;
					  
				:: (k != 9999 && ric != 9999 && st[i].optype == w && l>=i) -> 	
					wjc = st[i].val; 
					check = true;
					wjs = 9999;
					ris = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, ric, wjc);
					}
					/*printf("flagsercheck7 true res =%d %d\n", nw, m);*/ printf("check wr pair in st res =%d %d\n", ric, wjc);  l = i;  ric = 9999;
					wjc = 9999;
					if
					:: (m<nw) -> 
						/*printf("flagsercheck9 true res =%d %d\n", wic, rjc);*/i = m-1;  
					else ->
						i++
					fi 
				:: (k == 9999 && st[i].optype == r && ric == 9999 && m<nw && i < nw) -> 
				{
					ric = st[i].val; 
					check = false;
					k = i; m = i;
					/*printf("flagsercheck3 true res =%d %d\n", m, nw);*/					i++
				}
				:: (st[i].optype == r && ric != 9999) -> 
				{	 /*printf("flagsercheck4 true res =%d %d\n", wic, rjc);*/ i++
				}
				:: (st[i].optype == r && ric == 9999  && m>=nw) -> 
				{	 i++
				}
				:: (st[i].optype == w && wjc == 9999 && l>=i) -> 
				{	 i++
				}
				:: (st[i].optype == r && ric == 9999 && wjc == 9999 && l<i) -> 
				{	 i++
				}
				:: (st[i].optype == w && ric != 9999 && wjc == 9999 && l<i) -> 
				{	
					wjc = st[i].val; 
					printf("check wr pair in st =%d %d\n", ric, wjc);/*printf("flagsercheck10 true res =%d %d\n", m, nw);*/
					l = i;
					
					
					check = true;
					wjs = 9999;
					ris = 9999;
					flagsercheck = false; 
					atomic {
					run checkser(size, sersize, ric, wjc);
					}
					ric = 9999;
					wjc = 9999;					check = false;  
					if
					:: (m==nw) -> 
						ric  = 9999; wjc  = 9999; break;
					:: (m<nw) -> 
						/*printf("flagsercheck6 true res =%d %d\n", wic, rjc);*/i = m-1;  
					else ->
						i++
					fi 

				}
				:: (st[i].optype == w && wjc != 9999) -> 
				/*{	 i = k; printf("flagsercheck6 true res =%d %d\n", wic, rjc); wic = 9999; rjc = 9999; i++
				}*/
				else -> 
				fi	
		
		:: i >= size ->
				ric  = 9999; wjc  = 9999; break; 
	od

}

proctype checkser(int size, sersize, ricparam, wjcparam){
	int ris = 9999, wjs = 9999, k = 0, kk = 9999;
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
				:: (wfrviol == true) -> 
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
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype != w) ->
				ii++
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype == w && ser[j].st[ii].val != wjcparam) ->
				ii++
			
			/*::: (ii < size && ser[j].st[ii].optype ==  r && ser[j].st[ii].val != ricparam) -> 
			{
				ii++
			}*/
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype == w && ser[j].st[ii].val == wjcparam) -> 
			{	wjs = ser[j].st[ii].val; 
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
				wjc = 9999;
				printf("flagsercheck 0 true res =%d %d\n", j, kk); 
				if
				:: (j == kk || j < sersize-1) -> 
					flagsercheck = true;
				:: (j != kk && j >= sersize-1) -> 
					wfrviol = true;
					flagsercheck = false;
				else ->
				{
					flagsercheck = false; 
					wfrviol = true;
				}
				fi
				kk = j;
				
				printf("flagsercheck 1 true res =%d %d\n", ris, wfrviol); 

				ris = 9999; rjs = 9999;*/
				flagsercheck = true; 
				if
				:: (j == kk) -> 
				:: (j < sersize-1) -> 
				else ->
					wfrviol = true;
					break;
				fi
				
				
			}
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype == w && ser[j].st[ii].val != wjcparam) ->
				ii++
			:: (ii < size && ris != 9999 &&  ser[j].st[ii].optype != w) ->
				ii++
			:: (ii < size && ser[j].st[ii].optype ==w && ser[j].st[ii].val != wjcparam) -> 
			{
				 ii++
			}
			:: (wfrviol == true) ->
				break			
			else -> 	
			fi	
		:: j >= sersize ->
			wfrviol = false;/*ris = 9999; rjs = 9999;*/break
	od
	/*:: counter >	}*/
}

init {	
	int size = 7;
	st[0].optype = w;
	st[0].var = x;
	st[0].val = 1;
	st[1].optype = r;
	st[1].var = x;
	st[1].val = 2;
	st[2].optype = r;
	st[2].var = x;
	st[2].val = 1;
	st[3].optype = w;
	st[3].var = x;
	st[3].val = 2;
	st[4].optype = r;
	st[4].var = x;
	st[4].val = 1;
	st[5].optype = r;
	st[5].var = x;
	st[5].val = 2;
	st[6].optype = r;
	st[6].var = x;
	st[6].val = 1;
	
	ser[0].st[0].optype = w;
	ser[0].st[0].var = x;
	ser[0].st[0].val = 2;
	ser[0].st[1].optype = r;
	ser[0].st[1].var = x;
	ser[0].st[1].val = 2;
	ser[0].st[2].optype = r;
	ser[0].st[2].var = x;
	ser[0].st[2].val = 2;
	ser[0].st[3].optype = w;
	ser[0].st[3].var = x;
	ser[0].st[3].val = 1;
	ser[0].st[4].optype = r;
	ser[0].st[4].var = x;
	ser[0].st[4].val = 1;
	ser[0].st[5].optype = r;
	ser[0].st[5].var = x;
	ser[0].st[5].val = 1;
	ser[0].st[6].optype = r;
	ser[0].st[6].var = x;
	ser[0].st[6].val = 1;
	
	ser[1].st[0].optype = w;
	ser[1].st[0].var = x;
	ser[1].st[0].val = 1;
	ser[1].st[1].optype = r;
	ser[1].st[1].var = x;
	ser[1].st[1].val = 1;
	ser[1].st[2].optype = r;
	ser[1].st[2].var = x;
	ser[1].st[2].val = 1;
	ser[1].st[3].optype = r;
	ser[1].st[3].var = x;
	ser[1].st[3].val = 1;
	ser[1].st[4].optype = w;
	ser[1].st[4].var = x;
	ser[1].st[4].val = 2;
	ser[1].st[5].optype = r;
	ser[1].st[5].var = x;
	ser[1].st[5].val = 2;
	ser[1].st[6].optype = r;
	ser[1].st[6].var = x;
	ser[1].st[6].val = 2;
		
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
	check = false; flagsercheck = false; wfrviol = false; 
	/*run checkltl(size, i)*/
	run checkcond(size, 2)
	
}	