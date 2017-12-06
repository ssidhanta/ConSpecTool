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
		Op st[4];
		mtype status;
}
Op st[4];
Ser ser[2];
chan STDIN;
bool check = false, flagsercheck = false, rywviol = false;
ltl ryw {  [] ( !rywviol)  };
bool flagst, flagser;
mtype var = x;

proctype checkcond(int size, sersize){
	int wic  = 9999, rjc  = 9999, wis = 9999, rjs = 9999, k = 9999, kk = 9999;
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
				:: (k != 9999 && wic == 9999 && st[k].optype == w && m<nw && i < nw) -> 	
					i = k; wic = st[i].val; check = false; /*printf("flagsercheck1 true res =%d %d\n", l, i);*/ i++; m = i;  k = 9999; 
				:: (k != 9999 && wic != 9999 && st[k].optype == r && l<i) -> 					l = i;
					/*i = k;*/ 
					rjc = st[i].val; 
					printf("check wr pair in st =%d %d\n",  wic, rjc); 
					check = true; 
					rjs = 9999;
					wis = 9999;
					flagsercheck = false; 
					/*atomic {
					run checkser(size, sersize, wic, rjc);
					}*/
					if
					:: (st[i].var == var)
						flagsercheck = true;	
					fi
					i++ ;
					  
				:: (k != 9999 && wic != 9999 && st[i].optype == r && l>=i) -> 	
					rjc = st[i].val; 
					check = true;
					rjs = 9999;
					wis = 9999;
					flagsercheck = false; 
					if
					:: (st[i].var == var)
						flagsercheck = true;	
					fi
					
					/*atomic {
					run checkser(size, sersize, wic, rjc);
					}
					printf("flagsercheck7 true res =%d %d\n", nw, m);*/ printf("check wr pair in st res =%d %d\n", wic, rjc);  l = i;  wic = 9999;
					rjc = 9999;
					if
					:: (m<nw) -> 
						/*printf("flagsercheck9 true res =%d %d\n", wic, rjc);*/i = m-1;  
					else ->
						i++
					fi 
				:: (k == 9999 && st[i].optype == w && wic == 9999 && m<nw && i < nw) -> 
				{
					wic = st[i].val; 
					var = st[i].var;
					check = false;
					k = i; m = i;
					/*printf("flagsercheck3 true res =%d %d\n", m, nw);*/					i++
				}
				:: (st[i].optype == w && wic != 9999) -> 
				{	 /*printf("flagsercheck4 true res =%d %d\n", wic, rjc);*/ i++
				}
				:: (st[i].optype == w && wic == 9999  && m>=nw) -> 
				{	 i++
				}
				:: (st[i].optype == r && rjc == 9999 && l>=i) -> 
				{	 i++
				}
				:: (st[i].optype == r && wic == 9999 && rjc == 9999 && l<i) -> 
				{	 i++
				}
				:: (st[i].optype == r && wic != 9999 && rjc == 9999 && l<i) -> 
				{	
					rjc = st[i].val; 
					printf("check wr pair in st =%d %d\n", wic, rjc);/*printf("flagsercheck10 true res =%d %d\n", m, nw);*/
					l = i;
					
					
					check = true;
					rjs = 9999;
					wis = 9999;
					flagsercheck = false; 
					/*atomic {
					run checkser(size, sersize, wic, rjc);
					}*/
					if
					:: (st[i].var == var)
						flagsercheck = true;	
					fi
					wic = 9999;
					rjc = 9999;					check = false;  
					if
					:: (m==nw) -> 
						wic  = 9999; rjc  = 9999; break;
					:: (m<nw) -> 
						/*printf("flagsercheck6 true res =%d %d\n", wic, rjc);*/i = m-1;  
					else ->
						i++
					fi 

				}
				:: (st[i].optype == r && rjc != 9999) -> 
				/*{	 i = k; printf("flagsercheck6 true res =%d %d\n", wic, rjc); wic = 9999; rjc = 9999; i++
				}*/
				else -> 
				fi	
		
		:: i >= size ->
				wic  = 9999; rjc  = 9999; break; 
	od

}

proctype checkser(int size, sersize, wicparam, rjcparam){
	int wis = 9999, rjs = 9999, k = 0, kk = 9999;
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
				{ii = 0; j++}
			:: (ii < size && wis == 9999 && ser[j].st[ii].optype ==  w && ser[j].st[ii].val == wicparam) -> 
			{
				wis = ser[j].st[ii].val; 
				ii++
			}
			:: (ii < size && wis != 9999 && ser[j].st[ii].optype ==  w && ser[j].st[ii].val == wicparam) ->
				ii++
			:: (ii < size && ser[j].st[ii].optype ==  w && ser[j].st[ii].val != wicparam) -> 
			{
				ii++
			}
			:: (ii < size && wis == 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val == rjcparam) -> 
				ii++
			:: (ii < size && wis != 9999 &&  ser[j].st[ii].optype == r && ser[j].st[ii].val == rjcparam) -> 
			{	rjs = ser[j].st[ii].val; 
				/*if
				:: (ii >= size && flagsercheck ==  true && j != kk) -> 
					flagsercheck = true;
					ii=size;j = sersize;
					printf("flagsercheck 1 true res =%d %d\n", wis, rjs); 
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
				rjc = 9999;
				printf("flagsercheck 0 true res =%d %d\n", j, kk); */

				if
				:: (j == kk || j < sersize-1) -> 
					flagsercheck = true;
				:: (j != kk && j >= sersize-1) -> 
					rywviol = true;
					flagsercheck = false;
				else ->
				{
					flagsercheck = false; 
					rywviol = true;
				}
				fi
				kk = j;
				
				printf("flagsercheck 1 true res =%d %d\n", wis, rywviol); 

				/*wis = 9999; rjs = 9999;*/
				break;
				
			}
			:: (ii < size && ser[j].st[ii].optype ==r && ser[j].st[ii].val != rjcparam) -> 
			{
				 ii++
			}			
			else -> 	
			fi	
		:: j >= sersize ->
			rywviol = false;/*wis = 9999; rjs = 9999;*/break
	od
	/*:: counter >	}*/
}

init {
	int size = 4;
	/*bool inword = false;
	int i = 0, j = 0, size = 4;
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
	check = false; flagsercheck = false; rywviol = false; 
	/*run checkltl(size, i)*/
	run checkcond(size, 2)
	
}	