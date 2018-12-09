/* структруа файла для сканера 
 *  версия сканнера 0.6 бетта
 *<?xml version="1.0" encoding="UTF-8"?>
 *<schemes>
 *	<scheme id="1" name="Схема 1">
 *		<complex id="15k632m" ip="127.0.0.1" name="СКП рп Стрелец-М " pause_evdisp="5" pause_iicdisp="5" axz_enabled="false" axz_node="2" axz_level="2" axz_upstream="15k632m">
 *			<arm id="1" descript="АРМ 1">
 *				<imitator id="15k632m_03_03_rt"  description="ГТ-4 РТ"/>
 *					<dummy id="dummy_15k415m_02" pause_logic="1" pause_imitator="1" />
 *					<bod type="eni">
 *						<tab_name>ЭНИ</tab_name>
 *					</bod>
 *			</arm>
 *		</complex>
 *	</scheme>
 *</schemes>
 */

/* заметка: надо так <TAG ATTR*>TEXT</TAG> or <TAG [ATTR]* />*/


%{
#include <stdint.h>
#include "z_tab.h" // связь с синтаксическим анализатором

extern 
int lineno;
//extern char line[];

%}

%Start COMMENT SCHEME COMPLEX ARM IMITATOR DUMMY BOD TABNAME


%option noyywrap


%%


\<\?xml[ \t]+version[ \t]*\=[ \t]*\"1\.0\"[ \t]+encoding[ \t]*=[ \t]*\"UTF\-8\"\?\> {						
						printf(" DECL [%s]\n", yytext);
						return DECL;
					}

\<\!\-\-([ \t]*\<[^>])*? {
					printf(" BEGIN [%s]\n", yytext);
					BEGIN COMMENT;
				}
<COMMENT>\n {
					lineno++;
				}
<COMMENT>[^-\n]* {
					printf(" SKIP [%s]\n", yytext);
				}
				
<COMMENT>\-{2,2}\> {
					printf(" END [%s]\n", yytext);
					BEGIN 0;
				}
<COMMENT>\- {
					printf(" SKIP [%s]\n", yytext);
				}
				
\<\/schemes[^<]+?\> {
					printf(" END [%s]\n", yytext);
					return ROOT_END;
				}					

\<schemes[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
				}
					
\<schemes[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return ROOT_BEG;
				}


\<\/scheme\> {
					printf(" END [%s]\n", yytext);
					return SCHEME_END;
				}					

\<scheme[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
				}
					
\<scheme[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return SCHEME_BEG;
				}				

\<\/complex\> {
					printf(" END [%s]\n", yytext);
					return COMPLEX_END;
				}					

\<complex[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
				}
					
\<complex[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return COMPLEX_BEG;
				}

\<\/arm\> {
					printf(" END [%s]\n", yytext);
					return ARM_END;
				}					

\<arm[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
				}
					
\<arm[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return ARM_BEG;
				}				

\<\/imitator\> {
					printf(" END [%s]\n", yytext);
					return IMITATOR_END;
				}					

\<imitator[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
					return IMITATOR_SHORT;
				}
					
\<imitator[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return IMITATOR_BEG;
				}

\<\/dummy\> {
					printf(" END [%s]\n", yytext);
					return DUMMY_END;
				}					

\<dummy[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
					return DUMMY_SHORT;
				}
					
\<dummy[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return DUMMY_BEG;
				}
				
\<\/bod\> {
					printf(" END [%s]\n", yytext);
					return BOD_END;
				}					

\<bod[^<]+?\/\> {
					printf(" SHORT [%s]\n", yytext);
				}
					
\<bod[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return BOD_BEG;
				}

\<\/tab_name\> {
					printf(" END [%s]\n", yytext);
					return TABN_END;
				}					

\<tab_name[^<]*?\/\> {
					printf(" SHORT [%s]\n", yytext);
				}
					
\<tab_name[^<]+?\> {
					printf(" BEGIN [%s]\n", yytext);
					return TABN_BEG;
				}				
													
[ \t]+		;
\n				{
					lineno++;
				}
									
																								
%%
/*
int main(int argc, char **argv)
{
	int status = EXIT_FAILURE;
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (NULL != yyin) {
			zubr_lex();
			printf("lines: %d\n", lineno);
			status = EXIT_SUCCESS;
		} else {
			printf("Can't open %s file!\n", argv[1]);
		}
		fclose(yyin);
	} else {
		printf("Usage: cmd file\n");
	}
	
	return status;
}*/