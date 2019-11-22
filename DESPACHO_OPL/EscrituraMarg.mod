/*=========================================================================================================================================================================================================================================================
														 __________________________________________________________________________________
									                                        |                                                                                  |
														|    ARCHIVO DE MODELO AUXILIAR PARA LA ESCRITURA DEL RECURSO MARGINAL EN LA BD    |
														|                                                                                  |
									                                         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯													      
===========================================================================================================================================================================================================================================================*/
int Pini=...;												/*Periodo inicial de referencia para el modelo*/
int Pfin=...;
string CodCaso=...;											/*Código del caso en DRP*/
string Version=...;	
string Esquema=...;	
string Fecha=...;	
float Rec_Marginal[Pini..Pfin]=...;									/*Vector que contiene el recurso marginal para cada periodo de análisis*/	
						

/*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ESCRITURA DE INFORMACIÓN DEL MARGINAL¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*/
string  SQL_BorrarMar;
execute BorrarMar{	
	SQL_BorrarMar="DELETE FROM "+ Esquema +".DRPT_COSTOMARGINALRECURSO_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;	
} 	

tuple Info_Mar_T{string CODCASO; string VERSION; string FECHA; int PERIODO; float VALOR;}
{Info_Mar_T} Info_Mar =
{<CodCaso,Version,Fecha,t,Rec_Marginal[t]>| t in Pini..Pfin};
/*|______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|*/
