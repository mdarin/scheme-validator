/*
 * версия анализатора 0.2 бетта
 * версия грамматики 1.0
 * 
 * %palai text between%
 * 
 * Document = Declaration Root.
 * Declaration = %<?xml version="1.0" encoding="UTF-8" ?>%.
 * Root = <schemes> Schemes '<' '/' schemes '>'.
 * Schemes = {Scheme}.
 * Scheme = <scheme> Complexes </scheme>.
 * Complexes = {Complex}.
 * Complex = <complex> Arms </complex>.
 * Arms = {Arm}.
 * Arm = <arm> Imitators </arm>.
 * Imitators = {Imitator}.
 * Imitator = <imitator/>  
 * 	          |<imitator> [Dummies] [Bods] </imitator>.
 * Dummies = {Dummy}.
 * Dummy = <dummy/>.
 * Bods = {Bod}.
 * Bod = <bod> Tabs </bod>.
 * Tabs = {Tab}.
 * Tab = <tab_name> </tab_name>
 *        | <tab_name> Plain text </tab_name>.
 * 
 */

%token DECL ROOT_BEG ROOT_END SCHEME_BEG SCHEME_END SCHEME_BEG SCHEME_END
			 COMPLEX_BEG COMPLEX_END ARM_BEG ARM_END IMITATOR_SHORT IMITATOR_BEG IMITATOR_END
			 DUMMY_SHORT DUMMY_BEG DUMMY_END BOD_BEG BOD_END TABN_BEG TABN_END
			 COMMENT

%{

#include <stdint.h>

extern FILE* zubr_in;
extern FILE* zubr_out;
int lineno = 1;
char line[255] = {};



// for zubr !!!
void zubr_error(char *errstr);

%}


%%
document : DECL root {  printf ("valid file sturcture!\n"); }
			  | root { printf("warning: \"Declaration missed.\"\nvalid file sturcture!\n"); }
			  | DECL error { zubr_errok; printf ("invalid file structure!\nerror on line [%d] near \'value from yytext :)\'\n", lineno); }
			  ;

root : ROOT_BEG ROOT_END
	   |  ROOT_BEG schemes ROOT_END 
	   ;

schemes : SCHEME_BEG SCHEME_END
			  |	 SCHEME_BEG complex SCHEME_END	
			  | schemes SCHEME_BEG SCHEME_END
			  | schemes SCHEME_BEG complex SCHEME_END
			  ;	
			  
complex : COMPLEX_BEG COMPLEX_END
			  | COMPLEX_BEG arms COMPLEX_END
			  | complex COMPLEX_BEG COMPLEX_END
			  | complex COMPLEX_BEG arms COMPLEX_END
			  ;

arms : ARM_BEG ARM_END
		 | ARM_BEG imitators ARM_END
		 | arms ARM_BEG ARM_END
		 | arms ARM_BEG imitators ARM_END
		 ;

imitators : IMITATOR_SHORT
			  | IMITATOR_BEG IMITATOR_END
			  | IMITATOR_BEG imitator IMITATOR_END
			  | imitators IMITATOR_SHORT
			  | imitators IMITATOR_BEG IMITATOR_END
			  | imitators IMITATOR_BEG imitator IMITATOR_END
			
			  ;

imitator : DUMMY_SHORT
			 | DUMMY_BEG DUMMY_END
			 | BOD_BEG BOD_END
			 | BOD_BEG tabs BOD_END
			 | imitator DUMMY_SHORT
			 | imitator DUMMY_BEG DUMMY_END
			 | imitator BOD_BEG BOD_END
			 | imitator BOD_BEG tabs BOD_END
			  
tabs : TABN_BEG TABN_END
		| tabs TABN_BEG TABN_END
		;
		
%%
void zubr_error(char *errstr)
{
	if (NULL != errstr) {
		printf("%s\n", errstr);
	}
	return;
}


int main(int argc, char **argv)
{
	int status = EXIT_FAILURE;
	if (argc >= 2) {
		zubr_in = fopen(argv[1], "r");
		if (NULL != zubr_in) {
			zubr_parse();
			printf("lines: %d\n", lineno);
			status = EXIT_SUCCESS;
		} else {
			printf("Can't open %s file!\n", argv[1]);
		}
		fclose(zubr_in);
	} else {
		printf("Usage: cmd file\n");
	}
	
	return status;
}