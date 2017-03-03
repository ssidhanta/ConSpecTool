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
					printf("check 121212is js pair scviol  in st 2 =%d %d\n",  flagsercheck, i);
					
					i++;
				:: (flagsercheck == false && j == sersize-1) ->
					scviol = true; break;
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
					/*flagsercheck = false;
					flagch!flagsercheck;*/
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
	st[0].optype = w;
	st[0].var = x;
	st[0].val = 1;
	st[1].optype = r;
	st[1].var = x;
	st[1].val = 1;
	st[2].optype = w;
	st[2].var = x;
	st[2].val = 2;
	st[3].optype = r;
	st[3].var = x;
	st[3].val = 2;
	
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
	
	ser[1].st[0].optype = w;
	ser[1].st[0].var = x;
	ser[1].st[0].val = 2;
	ser[1].st[1].optype = r;
	ser[1].st[1].var = x;
	ser[1].st[1].val = 2;
	ser[1].st[2].optype = w;
	ser[1].st[2].var = x;
	ser[1].st[2].val = 1;
	ser[1].st[3].optype = r;
	ser[1].st[3].var = x;
	ser[1].st[3].val = 1;
		
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
	
	check = false;  scviol = false; 
	/*run checkltl(size, i)*/
	run checkser(size, 2)
	
}	