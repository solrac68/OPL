/*============================================================================================================================================================================================================
                                                                               __________________________________________________
                                                                              |                                                  |
                                                                              | MODELO DE PROGRAMACI�N DE RECURSOS DE GENERACI�N |
                                                                              |                                                  |
                                                                               ��������������������������������������������������
=============================================================================================================================================================================================================*/



/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   LECTURA DE DATOS   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
//{string} CodCaso_S=...;													/*C�digo del caso de an�lsis en DRP*/
string CodCaso=...;														
string Esquema=...;														/*Esquema del caso de an�lisis en DRP*/
string Version=...;														/*Versi�n del caso de an�lisis en DRP*/ 
{int} Pini_S=...;														/*Periodo Inicial*/
int Pini=first(Pini_S);	
{float} CostoDespachoIni_S=...;						 					/*Costo del despacho para los periodos anteriores a Pini*/
float CostoDespachoIni=first(CostoDespachoIni_S);	
int Pfin=...;															/*Periodo Final*/
{string} Descripcion_S=...;												/*Descripci�n del caso de an�lisis tomada de DRP*/
string Descripcion=first(Descripcion_S);
{string} Fecha_S=...;													/*Fecha del caso de an�lisis tomada de DRP*/
string Fecha=first(Fecha_S);
{string} TipoMod_S=...;													/*Tipo de modelo que debe aplicar seg�n el c�digo del caso.  PID: Preideal, IDE: Ideal, DPC: Despacho, RDP: Redespacho*/
string TipoMod=first(TipoMod_S);


/*Para la lectura de datos se toma todo el rango de periodos 1-pfin, pero para la construcci�n de las restricciones y funci�n objetivo se toman el t>=Pini*/
range Periodos=1..Pfin;													/*Rango de Periodos [1...Pfin]*/

float Demanda[Periodos]=...;											/*Demanda total del sistema para cada periodo*/

/*|���������������������������������������������������������������������������������INFORMACI�N GENERAL DE LOS RECURSOS����������������������������������������������������������������������������������������|*/
{string} Recursos=...;                              					/*Recursos Activos en el Sistema*/ 
string Codigo_Rec[Recursos]=...;										/*Vector que entrega para cada recurso activo en el Sistema el c�digo PLT de DRP*/														
string Numero_Rec[Recursos]=...;										/*Vector que entrega para cada recursos activo en el Sistema el CODNUMERO de DRP*/
{string} Rec_Termicos=...;												/*Conjunto de recursos t�rmicos despachados centralmente*/
{string} Rec_Hidraulico=...;											/*Recursos Hidr�ulicos*/
{string} Rec_Solar=...;											/*Recursos Solares, despachados centralmente*/
{string} Rec_Eolico=...;											/*Recursos E�licos, despachados centralmente*/
{string} Rec_noCentral=...;												/*Recursos no Despachados Centralmente*/
{string} Rec_Internacional=...;											/*Recursos/Enlaces Internacionales*/    
{string} RH_ModRamp=...;		 										/*Recursos hidr�ulicos con modelo de rampas de subida y bajada*/       
float MinTecRecurso[Rec_Hidraulico union Rec_Solar union Rec_Eolico]=...;								/*Minimo T�cnico de los Recursos a excepci�n de los t�rmicos*/          
float MaximoRecurso[Recursos][Periodos]=...;							/*M�ximo valor ingresado por perfiles para cada recurso en cada periodo*/
float MaximoRecursoUnd[Recursos][Periodos]=...;							/*M�ximo valor del recurso calculado con el m�ximo por unidad ingresado por perfiles en las unidades*/

tuple MinimoRecursoObl_T{
 key string RECURSO;
 key int    PERIODO;
 float      MINIMO;}
{MinimoRecursoObl_T} MinimoRecursoObl=...;								/*M�nimo valor ingresado por perfiles para cada recurso en cada periodo, se toma s�lo si tiene el checkbox activo*/

tuple CandidataInflex_T{
 key string RECURSO;
 key int    PERIODO;
 float      CANINFLEX;}
{CandidataInflex_T} CandidataInflex=...; 								/*Generaci�n m�nima obligatoria ingresada por perfiles de recurso en la columna Candidato Inflexible. SOLO APLICA PARA EL IDEAL*/

tuple TechoEnficc_T{
 key string RECURSO;
 key int    PERIODO;
 float      MAXIMO;}    
{TechoEnficc_T}TechoEnficc=...;											/*M�ximo valor permitido al recurso para las exportaciones*/                                                  
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|��������������������������������������������������������������������������������INFORMACI�N GENERAL DE LAS UNIDADES���������������������������������������������������������������������������������������|*/
tuple RecursoUnidades_T {
	string RECURSO;
	string UNIDAD;}
{RecursoUnidades_T}RecursoUnidades=...;									/*Relaciona a que recurso pertenece cada unidad*/ 	

{string} Unidades=...;											/*Conjunto de unidades activas en el sistema*/
string Codigo_Und[Unidades]=...;									/*Vector que entrega para cada unidad activa en el Sistema el c�digo UNI de DRP*/
string Numero_Und[Unidades]=...;									/*Vector que entrega para cada unidad activa en el Sistema el CODNUMERO de DRP*/
{string} Und_Termica=...;	 									/*Conjunto de unidades t�rmicas despachadas centralmente*/
{string} Und_Hidraulica=...;	 									/*Unidades Hidraulicas*/
{string} Und_Solar=...;	 										/*Unidades Solares*/
{string} Und_Eolica=...;	 									/*Recursos E�licas*/
{string} Und_noCentral=...;	 									/*Recursos no Despachados Centralmente*/           						
{string} Und_Internacional=...;	 									/*Recursos/Enlaces Internacionales*/
float MaximoUnidad[Unidades][Periodos]=...;								/*M�ximo valor ingresado por perfiles para cada unidad en cada periodo*/
float MT_Und[Unidades]=...;										/*M�nimo t�cnico de las unidades hidr�ulicas*/	
{string} RecH_MT_Esp=...; 										/*Recursos con unidades hidr�ulicas con m�nimo t�cnico inicial*/
float MinUnd_Esp[Und_Hidraulica][Periodos]=...;								/*M�nimo ingresado por perfiles para las unidades*/

tuple Cadena_Pagua_T {
	string PARAISO;
	string GUACA;}
{Cadena_Pagua_T}Cadena_Pagua=...;									/*Relaciona a que recurso pertenece cada unidad*/

{string} Unds_Paraiso=...;										/*Relaci�n entre las unidades de la cadena Pagua*/

tuple MinObl_Und_T {
	string UNIDAD;
	int  PERIODO;
	float  MIN;}
{MinObl_Und_T}MinObl_Und=...;										/*M�nimo ingresado por perfiles para las unidades con check box activo*/

tuple MaxObl_Und_T {
	string UNIDAD;
	int  PERIODO;
	float  MAX;}
{MaxObl_Und_T}MaxObl_Und=...;											/*M�ximo ingresado por perfiles para las unidades con check box activo*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|��������������������������������������������������������������������������������INFORMACI�N GENERAL DE LAS SUB�REAS���������������������������������������������������������������������������������������|*/
{string} Subarea=...;													/*Conjunto de sub�reas activas en el sistema*/
string Codigo_Subarea[Subarea]=...;										/*Vector que entrega para cada sub�rea activa en el sistema el c�digo de DRP*/
float CostoRacSubarea[Subarea][Periodos]=...;							/*Costo de racionamiento para cada sub�rea en cada periodo*/

tuple UnidadSubarea_T {
	string UNIDAD;
	string SUBAREA;}
{UnidadSubarea_T}UnidadSubarea=...; 									/*Relaciona que unidades pertenecen a la sub�rea*/

float DemandaSubarea[Subarea][Periodos]=...;							/*Demanda de cada sub�rea en cada periodo*/ 
int BanderaSubarea[Subarea]=...;	 									/*Bandera que indica si aplica el l�mite de �nico o l�mite por periodo para cada sub�rea.  1 es que aplica por periodo*/
float ImpSubarea[Subarea][Periodos]=...;								/*L�mite de importaci�n de cada sub�rea en cada periodo*/
float ExpSubarea[Subarea][Periodos]=...;								/*L�mite de exportaci�n de cada sub�rea en cada periodo*/
float RacMin_Subarea[Subarea][Periodos]=...;			 				/*Racionamiento obligado para cada sub�rea en cada periodo*/
float ImpSub_Unico[Subarea]=...; 										/*L�mite de imporaci�n �nico para la sub�rea*/ 
float ExpSub_Unico[Subarea]=...;	 									/*L�mite de exportaci�n �nico para la sub�rea*/ 
/*|____________________________________________________________________________________________________________________________________________________________________________________________________________|*/       							


/*|�����������������������������������������������������������������������������������INFORMACI�N GENERAL DE LAS �REAS�����������������������������������������������������������������������������������������|*/       							
{string} Areas=...;														/*Conjunto de �reas activas en el sistema*/
string Codigo_Area[Areas]=...;											/*Vector que entrega para cada �rea activa en el sistema el c�digo de DRP*/

tuple SubareaArea_T {
	string SUBAREA;
	string AREA;}
{SubareaArea_T}SubareaArea=...;	 										/*Para cada sub�rea, entrega el �rea a la que pertenece*/

float DemandaArea[Areas][Periodos]=...;									/*Demanda de cada �rea en cada periodo*/
int BanderaArea[Areas]=...;												/*Bandera que indica si aplica el l�mite de �nico o l�mite por periodo para cada �rea.  1 es que aplica por periodo*/
float ImpArea[Areas][Periodos]=...;										/*L�mite de importaci�n de cada �rea en cada periodo*/
float ExpArea[Areas][Periodos]=...;										/*L�mite de exportaci�n de cada �rea en cada periodo*/
float ImpArea_Unico[Areas]=...; 										/*L�mite de imporaci�n �nico para el �rea*/						
float ExpArea_Unico[Areas]=...; 										/*L�mite de exportaci�n �nico para el �rea*/						
/*|____________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������INFORMACI�N RECURSOS CON ZONAS INFACTIBLES������������������������������������������������������������������������������������|*/
{string} RecursosInfactibles=...;										/*Conjunto de recursos que tienen zonas infactibles*/
{string} BloquesFactibles=...;											/*Identificaci�n de cada bloque factible concatenando el Recurso y el segmento*/

tuple ValoresFactibles_T{
  string RECURSO;
  key string SEGMENTO;
  float VALMIN;
  float VALMAX;}			
{ValoresFactibles_T} ValoresFactibles=...;								/*Detalle de los bloques factibles identificando el valor m�nimo, el m�ximo y la combinaci�n Recurso_Segmento correspondiente*/

{string} RecInfact_Esp=...;  											/*Conjunto de recursos t�rmicos con zonas infactibles especiales*/

tuple ZonaInfact_Esp_T {
 key string NOMBRE;
 float        Vmin;
 float        Vmax; 
}    
{ZonaInfact_Esp_T}ZonaInfact_Esp=...;									/*Detalle de los valores m�nimos y m�ximos los cuales se utilizan para definir las zonas FactibleMin-Infactible-FactibleMax*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������������������INFORMACI�N DEL AGC������������������������������������������������������������������������������������������|*/
{string}RecursoAGC=...;													/*Recursos habilitados para hacer AGC*/
float AGC[RecursoAGC][Periodos]=...;									/*Asignaci�n de AGC a cada recurso en cada periodo*/	
int BanderaAGC[RecursoAGC][Periodos]=...; 								/*Bandera que indica si el Recurso tiene AGC asignado en un periodo*/
{string}UnidadesAGC=...;												/*Unidades habilitadas para hacer AGC*/
float AGCUnd[UnidadesAGC][Periodos]=...;								/*Asignaci�n de AGC a cada unidad en cada periodo*/         
float MinTec_AGC_Und[UnidadesAGC][Periodos]=...;						/*M�nimo t�cnico de las unidades para hacer AGC*/		   					
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������������������INFORMACI�N DE LA OFERTA����������������������������������������������������������������������������������������|*/
float Disp_Rec[Recursos][Periodos]=...;									/*Disponibilidad Declarada de los Recursos por Periodo*/
float Disp_Und[Unidades][Periodos]=...;									/*Disponibilidad Declarada de las unidades por Periodo*/
float OfertaRecurso[Recursos][Periodos]=...;							/*Precio de Oferta del Recurso*/
float PAP_Recurso[Rec_Termicos][Periodos]=...;							/*Precio de Arranque y Parada del Recurso T�rmico en cada Periodo*/
string Conf_Prd[Rec_Termicos][Periodos]=...;							/*Configuraci�n de cada recurso t�rmico en cada periodo*/
int BanderaPruebas[Recursos][Periodos]=...;								/*Bandera que indica si el recurso est� o no en pruebas, es 1 si tienen pruebas*/
int BanderaPruebasUnidad[Unidades][Periodos]=...;						/*Bandera que indica si la unidad est� o no en pruebas, es 1 si tienen pruebas*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������������������������������������INFORMACI�N DE CONDICIONES INICIALES�����������������������������������������������������������������������������������|*/
float GenRecT_t_1[Rec_Termicos]=...;									/*Generaci�n en el periodo t-1 para los recursos t�rmicos*/
float GenRecT_t_2[Rec_Termicos]=...; 									/*Generaci�n en el periodo t-2 para los recursos t�rmicos*/
string Conf_t_1[Rec_Termicos]=...;										/*Configuraci�n en el periodo t-1 para los recursos t�rmicos*/
string Conf_Salida[Rec_Termicos]=...;									/*Configuraci�n con la cual se realiz� la salida del recurso en la condici�n inicial*/
string Conf_Entrada[Rec_Termicos]=...;									/*Configuraci�n con la cual se realiz� la entrad del recurso en la condici�n inicial*/
int nEnt_ini[Rec_Termicos]=...;											/*Bloques de entrada que lleva el recurso en la condici�n inicial*/
int nEnt_ini_Cal[Rec_Termicos]=...;										/*Bloques de entrada caliente que lleva el recurso en la condici�n inicial*/
int nEnt_ini_Tib[Rec_Termicos]=...;										/*Bloques de entrada tibio que lleva el recurso en la condici�n inicial*/
int nEnt_ini_Fri[Rec_Termicos]=...;										/*Bloques de entrada tibio que lleva el recurso en la condici�n inicial*/
int nSal_ini[Rec_Termicos]=...;											/*Bloques de salida que lleva el recurso en la condici�n inicial*/
int nSal_ini_Nor[Rec_Termicos]=...;										/*Bloques de salida normal que lleva el recurso en la condici�n inicial*/
int nSal_ini_Esp[Rec_Termicos]=...;										/*Bloques de salida especial que lleva el recurso en la condici�n inicial*/
int Tiempo_en_Linea[Rec_Termicos]=...;									/*Tiempo que lleva el recurso t�rmico en l�nea en la condici�n inicial*/
int Tiempo_fuera_Linea[Rec_Termicos]=...;								/*Tiempo que lleva el recurso t�rmico fuera de l�nea en la condici�n inicial*/
int nArr_ini[Rec_Termicos]=...;											/*N�mero de arranques que lleva el recurso en la condici�n inicial para el d�a de an�lisis*/
int Publicacion[Rec_Termicos]=...;										/*Tiempo de publicaci�n de referencia para el tiempo de aviso*/
int TDispPini_1[Rec_Termicos]=...;										/*N�mero de periodos que lleva el recurso disponible en la condici�n inicial (Hasta el periodo Pini-1)*/
int Disp_t_1[Rec_Termicos]=...;											/*Disponibilidad en el periodo t-1 para los recursos t�rmicos*/
int TCE_P[Rec_Termicos]=...;											/*Tiempo de carga estable que tiene pendiente el recurso t�rmico*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|��������������������������������������������������������������������������������INFORMACI�N PARA CONTROL DE RESTRICCIONES���������������������������������������������������������������������������������|*/
int c_Mod1_Ent[Rec_Termicos]=...;						                /*Control para la restricci�n de Modelo1 de entrada*/
int c_Mod1_Sal[Rec_Termicos]=...;						                /*Control para la restricci�n de Modelo1 de salida*/
int RampaObl[Rec_Termicos][Periodos]=...;								/*Valor de Rampa que se quiere aplicar cuando el modelo 1 est� inactivo*/
int c_CE[Rec_Termicos][Periodos]=...;				                    /*Control para la restricci�n de carga estable*/
int c_TL[Rec_Termicos]=...;							                    /*Control para la restricci�n de tiempo en l�nea*/
int c_TFL[Rec_Termicos]=...;							                /*Control para la restricci�n de tiempo fuera de l�nea*/
int c_TC[Rec_Termicos]=...;							                    /*Control para la restricci�n de tiempo de calentamiento*/
int c_TA[Rec_Termicos]=...;							                    /*Control para la restricci�n de tiempo de aviso*/
int c_NAR[Rec_Termicos]=...;											/*Control para la restricci�n de n�mero de arranques*/
int c_Mod23[Rec_Termicos][Periodos]=...;					            /*Control para la restricci�n de modelo 2 o 3 seg�n aplique, esta implica tambi�n el control de los UR' y DR'*/
int c_Mod2H[RH_ModRamp][Periodos]=...;									/*Control para la restricci�n de modelo 2 para recursos hidr�ulicos*/
{int} c_NO_Z_S=...;														/*Control para relajar las zonas de seguridad, lo ideal es que est� en "0"*/
int c_NO_Z=first(c_NO_Z_S);			
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������������INFORMACI�N GENERAL DE RECURSOS T�RMICOS��������������������������������������������������������������������������������|*/
int nArranques[Rec_Termicos]=...;										/*Informaci�n del n�mero m�ximo de arranques de un recurso t�rmico*/
int Bandera_Disp[Rec_Termicos][Periodos]=...;   						/*Bandera que indica si el recurso est� disponible o no en el periodo, se usa para el tiempo de calentamiento*/  
{string} R_Conf=...;													/*Configuraciones posibles  para cada recurso t�rmico, se concatena Recurso y n�mero*/	
float MinTecRecurso_T[R_Conf]=...;										/*M�nimo T�cnico de los Recursos T�rmicos seg�n Configuraci�n*/

tuple Conf_Tabla_T{
	string CONF;
	string RECURSO;
	string NUMERO;}
{Conf_Tabla_T} Conf_Tabla=...;											/*Tabla que relaciona las configuraciones (Concatenada Recurso_Numero) con los recursos t�rmicos y el n�mero*/

int TiempoCaliente[R_Conf]=...;											/*M�ximo Tiempo Fuera de L�nea para Considerar el Recurso Caliente, indexado por configuraci�n*/
int TiempoTibio[R_Conf]=...;											/*M�ximo Tiempo Fuera de L�nea para Considerar el Recurso Tibio, indexado por configuraci�n*/
int Min_Tiempo_en_Linea[Rec_Termicos]=...;								/*M�nimo Tiempo en L�nea para cada uno de los recursos t�rmicos*/
int Min_Tiempo_fuera_Linea[Rec_Termicos]=...;			 				/*M�nimo Tiempo que debe estar fuera de l�nea el recurso*/

tuple Tiempo_Aviso_Calentamiento_T{
	key string CONF;
	int TCFRIO;
	int TCTIBIO;
	int TCCALIENTE;
	int TAFRIO;
	int TATIBIO;
	int TACALIENTE;}
{Tiempo_Aviso_Calentamiento_T} Tiempo_Aviso_Calentamiento=...; 			/*Tupla con la informaci�n del tiempo de aviso y calentamiento para cada combinaci�n recurso-configuraci�n*/						
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/  


/*|����������������������������������������������������������������������������������������INFORMACI�N PARA EL MODELO 1��������������������������������������������������������������������������������������|*/
int nSegmentosFrio[R_Conf]=...;											/*N�mero m�ximo de segmentos para cada combinaci�n Recurso_Configuraci�n en el estado frio*/
int nSegmentosTibio[R_Conf]=...;										/*N�mero m�ximo de segmentos para cada combinaci�n Recurso_Configuraci�n en el estado tibio*/
int nSegmentosCaliente[R_Conf]=...;										/*N�mero m�ximo de segmentos para cada combinaci�n Recurso_Configuraci�n en el estado caliente*/
int Nmax=...;															/*N�mero m�ximo de segmentos que se pueden declarar seg�n el acuerdo CNO 531*/
float SegRampas_Frio[R_Conf][1..Nmax]=...;								/*Valor de cada segmento de entrada para el estado frio*/								
float SegRampas_Tibio[R_Conf][1..Nmax]=...;								/*Valor de cada segmento de entrada para el estado frio*/	
float SegRampas_Caliente[R_Conf][1..Nmax]=...;							/*Valor de cada segmento de entrada para el estado frio*/
int nSegmentoSalida[R_Conf]=...;										/*N�mero m�ximo de segmentos para cada combinaci�n Recurso_Configuracion en la rampa de salida*/
int SegRampas_Salida[R_Conf][1..Nmax]=...;								/*Valor de cada segmento de salida*/

tuple RampasSalida_Esp_T{	
	key string CONF;
	int BLOQUEOESP;}
{RampasSalida_Esp_T} RampasSalida_Esp=...;								/*Valor del segmento de salida especial*/

{string} Rec_Salida_Esp=...;											/*Recursos con salida especial*/	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/		


/*|����������������������������������������������������������������������������������������INFORMACI�N PARA EL MODELO 2��������������������������������������������������������������������������������������|*/
{string}RT_Mod2=...;													/*Recursos t�rmicos con modelo 2*/

tuple Interv_Mod2_UR_T {
	string CONF;                        
	key string INTERVALO;                           
	float VALMIN;                                
	float VALMAX;                                
	float URMAX;} 
{Interv_Mod2_UR_T} Interv_Mod2_UR=...;									/*Detalle de los intervalos del modelo 2 para subir (UR) para los recursos t�rmicos*/

tuple Interv_Mod2_DR_T {
	string CONF;                        
	key string INTERVALO;                           
	float VALMIN;                                
	float VALMAX;                                
	float DRMAX;} 
{Interv_Mod2_DR_T} Interv_Mod2_DR=...;									/*Detalle de los intervalos del modelo 2 para bajar (DR) para los recursos t�rmicos*/

{string} Interv_UR=...;													/*Etiqueta de los intervalos del modelo 2 para subir (UR) para los recursos t�rmicos*/
{string} Interv_DR=...;													/*Etiqueta de los intervalos del modelo 2 para bajar (DR) para los recursos t�rmicos*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/													


/*|����������������������������������������������������������������������������������INFORMACI�N PARA EL DESPACHO ALTERNATIVO��������������������������������������������������������������������������������|*/
{string} RT_URPrima=...; 												/*Recursos t�rmicos con modelo de despacho alternativo de subida*/	

tuple Dat_URPrima_T {
	key string CONF;             
	float URPRIMA;} 
{Dat_URPrima_T}Dat_URPrima=...; 										/*Informaci�n del valor de UR prima para cada uno de los recursos en cada configuraci�n*/

{string} RT_DRPrima=...;  												/*Recursos t�rmicos con modelo de despacho alternativo de bajada*/

tuple Dat_DRPrima_T {
	key string CONF;              
	float DRPRIMA;} 
{Dat_DRPrima_T}Dat_DRPrima=...; 										/*Informaci�n del valor de DR prima para cada uno de los recursos en cada configuraci�n*/	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������������������INFORMACI�N PARA EL MODELO 3��������������������������������������������������������������������������������������|*/
{string} RT_Mod3=...; 													/*Recursos t�rmicos con modelo 3*/					

tuple Mod3_ABCD_T {
	key string CONF;
	float A;
	float B;
	float UR;
	float C;
	float D;
	float DR;} 
{Mod3_ABCD_T}Mod3_ABCD=...;												/*Detalle de los par�metros del modelo 3 para cada combinaci�n Recurso-Configuraci�n*/	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������INFORMACI�N PARA EL MODELO DE CARGA ESTABLE������������������������������������������������������������������������������|*/
{string} RT_ModCE=...; 													/*Recursos t�rmicos con modelo de carga estable*/

tuple Dat_ModCE_T {
	key string CONF;
	float MAXCE;
	int TCE;}
{Dat_ModCE_T}Dat_ModCE=...;												/*Detalle de los par�metros del modelo de carga estable para cada combinaci�n Recurso-Configuraci�n*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������INFORMACI�N PARA EL MODELO DE RAMPAS DE RECURSOS HIDR�ULICOS����������������������������������������������������������������������|*/
tuple Dat_RH_UR_T {
	string RECURSO;
	key string INTERVALO;
	float VALMIN;                                
	float VALMAX;                                
	float URMAX;}
{Dat_RH_UR_T}Dat_RH_UR=...;	 											/*Detalle de los intervalos para subir para los recursos hidr�ulicos con rampas*/

tuple Dat_RH_DR_T {
	key string RECURSO;
	key string INTERVALO;
	float VALMIN;                                
	float VALMAX;                                
	float DRMAX;}
{Dat_RH_DR_T}Dat_RH_DR=...;												/*Detalle de los intervalos para bajar para los recursos hidr�ulicos con rampas*/
									
{string} IntervRH_UR=...;	 											/*Etiqueta de los intervalos para subir para los recursos hidr�ulicos con rampas*/					
{string} IntervRH_DR=...;							 					/*Etiqueta de los intervalos para subir para los recursos hidr�ulicos con rampas*/	

float GenRecH_t_1[RH_ModRamp]=...;										/*Generaci�n en el periodo t-1 para los recursos hidr�ulico con rampas*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������������INFORMACI�N PARA LAS ZONAS DE SEGURIDAD��������������������������������������������������������������������������������|*/
{string} Zonas_UndMinimas=...;											/*Conjunto de zonas de unidades m�nimas activas para el problema*/													
float Valor_Z_UndMin[Zonas_UndMinimas][Periodos]=...;					/*Valor que se debe cumplir para las unidades m�nimas en cada periodo*/	
				
tuple Pesos_Z_UndMin_T {
	string ZONA;	
	string UNIDAD;                                
	int PERIODO;                                
	float PESO;}
{Pesos_Z_UndMin_T}Pesos_Z_UndMin=...;									/*Peso que cada unidad tiene en una zona de unidades m�nimas*/	

int Bandera_Seg[Unidades][Periodos]=...;								/*Bandera de seguridad de las unidades, es cero si la unidad no puede cubrir seguridad*/

{string} Zonas_MWMinimos=...;											/*Conjunto de zonas de generaci�n m�nima activas para el problema*/
float Valor_Z_MWMin[Zonas_MWMinimos][Periodos]=...;						/*Valor que se debe cumplir para la generaci�n m�nima en cada periodo*/		
			
tuple Info_Z_MWMin_T {
	string ZONA;	
	string UNIDAD;}
{Info_Z_MWMin_T}Info_Z_MWMin=...;										/*Detalle de las unidades que pertenecen a la zona de seguridad de generaci�n m�nima*/

{string} Zonas_MWMaximos=...;											/*Conjunto de zonas de generaci�n m�xima activas para el problema*/
int BanderaAGCZona[Zonas_MWMaximos]=...;								/*Bandera que indica si se considera el AGC en las zonas de MW Max*/				
float Valor_Z_MWMax[Zonas_MWMaximos][Periodos]=...;						/*Valor que se debe cumplir para la generaci�n m�xima en cada periodo*/	

tuple Info_Z_MWMax_T {
	string ZONA;	
	string UNIDAD;}
{Info_Z_MWMax_T}Info_Z_MWMax=...;										/*Detalle de las unidades que pertenecen a la zona de seguridad de generaci�n m�xima*/		
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/



/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   PREPROCESO   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

execute Ajuste_Segmentos{												/*Se encarga de hacer cero el n�mero de segmentos cuando el control de restricci�n de modelo 1 est� incactivo*/
	for (var CT in Conf_Tabla){		
			nSegmentosCaliente[CT.CONF]=c_Mod1_Ent[CT.RECURSO]*nSegmentosCaliente[CT.CONF];  
			nSegmentosTibio[CT.CONF]=c_Mod1_Ent[CT.RECURSO]*nSegmentosTibio[CT.CONF];  
			nSegmentosFrio[CT.CONF]=c_Mod1_Ent[CT.RECURSO]*nSegmentosFrio[CT.CONF];  
			nSegmentoSalida[CT.CONF]=c_Mod1_Sal[CT.RECURSO]*nSegmentoSalida[CT.CONF]; 
	} 
}

int ContPru[Rec_Termicos];
int ContInd[Rec_Termicos];
execute PruebasIndisp24{												/*Cuando un recurso tiene pruebas o est� indisponible los 24 periodos  se desactiva todo el control de restricciones para ese recurso*/
	for (var Rpru in Rec_Termicos){
	  	ContPru[Rpru]=0;
	  	ContInd[Rpru]=0;
		for (var tpru in Periodos){
			if(BanderaPruebas[Rpru][tpru]==1){
				ContPru[Rpru]=ContPru[Rpru]+1;	
			}
			if(Bandera_Disp[Rpru][tpru]==0){
				ContInd[Rpru]=ContInd[Rpru]+1;	
			}			
		}	
		
		if(ContPru[Rpru]==24 || ContInd[Rpru]==24){
			for(var tpru2 in Periodos){
				RampaObl[Rpru][tpru2]=0;								/*SI SE CREAN CONTROLES NUEVOS, DEBEN IR EN ESTE CICLO*/
				c_Mod23[Rpru][tpru2]=0;
				c_CE[Rpru][tpru2]=0;
				TCE_P[Rpru]=0;											/*No hay un control para la carga estable pendiente*/
			}
			c_Mod1_Ent[Rpru]=0;
			c_Mod1_Sal[Rpru]=0;			
			c_TL[Rpru]=0;
			c_TFL[Rpru]=0;
			c_TC[Rpru]=0;
			c_TA[Rpru]=0;
			c_NAR[Rpru]=0;
		}
	
		if(Disp_Rec[Rpru][Pini]<=0.00001 && GenRecT_t_1[Rpru]>0.00001){		/*Si la disponibilidad del periodo Pini es cero, entonces se asume que el periodo anterior es el �ltimo bloque de una salida normal*/
			for(var CT_d in Conf_Tabla){	
				if(Conf_t_1[Rpru]==CT_d.NUMERO && Rpru==CT_d.RECURSO){
					if(nSegmentoSalida[CT_d.CONF]>0){	
						Conf_Salida[Rpru]=Conf_t_1[Rpru];
						Conf_Entrada[Rpru]="NA";
						nEnt_ini[Rpru]=0;
						nEnt_ini_Cal[Rpru]=0;
						nEnt_ini_Tib[Rpru]=0;
						nEnt_ini_Fri[Rpru]=0;
						nSal_ini[Rpru]=nSegmentoSalida[CT_d.CONF];
						nSal_ini_Nor[Rpru]=nSegmentoSalida[CT_d.CONF];
						nSal_ini_Esp[Rpru]=0;					
						Tiempo_en_Linea[Rpru]=0;	
						Tiempo_fuera_Linea[Rpru]=0;
						TCE_P[Rpru]=0;
						c_Mod23[Rpru][Pini]=0;
					}
					if(nSegmentoSalida[CT_d.CONF]==0){		/*Si el recurso no tiene bloques de salida, se asume que ya cumpli� todo el tiempo en l�nea*/	
						Conf_Salida[Rpru]="NA";
						Conf_Entrada[Rpru]="NA";
						nEnt_ini[Rpru]=0;
						nEnt_ini_Cal[Rpru]=0;
						nEnt_ini_Tib[Rpru]=0;
						nEnt_ini_Fri[Rpru]=0;
						nSal_ini[Rpru]=0;
						nSal_ini_Nor[Rpru]=0;
						nSal_ini_Esp[Rpru]=0;					
						Tiempo_en_Linea[Rpru]=1000;	
						Tiempo_fuera_Linea[Rpru]=0;
						TCE_P[Rpru]=0;
						c_Mod23[Rpru][Pini]=0;
					}					
				}
			}				
   		}
	}	
}

/*|����������������������������������������������������������PREPROCESO DE VALORES DE GENERACI�N DEL PERIODO 23 Y 24 PARA EL <<<< DESPACHO IDEAL >>>>���������������������������������������������������������|*/
range rnmax=1..Nmax;													/*Rango que va desde 1 al Nmax*/
int Ce[Rec_Termicos];													/*Bandera para saber cuando encontr� el bloque de entrada correspondiente*/
int Cs[Rec_Termicos];													/*Bandera para saber cuando encontr� el bloque de salida correspondiente*/
execute CI_2324{
	if(TipoMod=="IDE"){
		for(var CT_CI in Conf_Tabla){
			for(var RT_CI in Rec_Termicos){
				if(Conf_t_1[RT_CI]==CT_CI.NUMERO && RT_CI==CT_CI.RECURSO){
				  	if(GenRecT_t_1[RT_CI]>1.05*MinTecRecurso_T[CT_CI.CONF]){
				  		GenRecT_t_1[RT_CI]=Math.round(GenRecT_t_1[RT_CI]);
				  		GenRecT_t_2[RT_CI]=Math.round(GenRecT_t_2[RT_CI]);
		   			}
				  	if(GenRecT_t_1[RT_CI]>=0.95*MinTecRecurso_T[CT_CI.CONF] && GenRecT_t_1[RT_CI]<=1.05*MinTecRecurso_T[CT_CI.CONF]){
				  		GenRecT_t_1[RT_CI]=MinTecRecurso_T[CT_CI.CONF];
				  		Tiempo_en_Linea[RT_CI]=Math.max(Tiempo_en_Linea[RT_CI],1);
				  		Tiempo_fuera_Linea[RT_CI]=0;
		   			}			  	
				  	if(GenRecT_t_1[RT_CI]<0.95*MinTecRecurso_T[CT_CI.CONF]){
						if(nSegmentosCaliente[CT_CI.CONF]>0){			  	  
					  		if(GenRecT_t_1[RT_CI]>GenRecT_t_2[RT_CI] && GenRecT_t_1[RT_CI]>=0.95*SegRampas_Caliente[CT_CI.CONF][1]){
					  			Tiempo_en_Linea[RT_CI]=0;
					  			Tiempo_fuera_Linea[RT_CI]=0;
					  			nEnt_ini[RT_CI]=nSegmentosCaliente[CT_CI.CONF];
					  			nEnt_ini_Cal[RT_CI]=nSegmentosCaliente[CT_CI.CONF];
					  			Conf_Entrada[RT_CI]=Conf_t_1[RT_CI];  
					  			for(var n1 in rnmax){
					  			  if(Ce[RT_CI]==0 && GenRecT_t_1[RT_CI]<0.95*SegRampas_Caliente[CT_CI.CONF][n1] && n1<=nSegmentosCaliente[CT_CI.CONF]){
										if(n1==1){		/*Si el recurso va subiendo y la generaci�n del periodo 24 es menor al 95% del primer bloque de entrada, se asume que lleva un bloque.*/
							  			  	nEnt_ini[RT_CI]=n1;
							  			  	nEnt_ini_Cal[RT_CI]=n1;	
							  			  	Ce[RT_CI]=1;								  
										}
										else{
							  			  	nEnt_ini[RT_CI]=n1-1;
							  			  	nEnt_ini_Cal[RT_CI]=n1-1;	
							  			  	Ce[RT_CI]=1;
		        						}					  			
					  			  }			  			  
					  			}
					  		}
					  		if(GenRecT_t_1[RT_CI]<GenRecT_t_2[RT_CI] && GenRecT_t_1[RT_CI]>=0.95*SegRampas_Salida[CT_CI.CONF][nSegmentoSalida[CT_CI.CONF]]){
					  		  	Tiempo_en_Linea[RT_CI]=0;
					  			Tiempo_fuera_Linea[RT_CI]=0;
					  			nSal_ini[RT_CI]=nSegmentoSalida[CT_CI.CONF];
					  			nSal_ini_Nor[RT_CI]=nSegmentoSalida[CT_CI.CONF];	
					  			Conf_Salida[RT_CI]=Conf_t_1[RT_CI];
					  			for(var n2 in rnmax){			  			  
					  			  if(Cs[RT_CI]==0 && GenRecT_t_1[RT_CI]>1.05*SegRampas_Salida[CT_CI.CONF][n2] && n2<=nSegmentoSalida[CT_CI.CONF]){
		
										if(n2==1){		/*Si el recurso va bajando y la generaci�n del periodo 24 es mayor al 105% del primer bloque de salida, se asume que lleva un bloque.*/
							  			  	nSal_ini[RT_CI]=n2;
							  			  	nSal_ini_Nor[RT_CI]=n2;	
							  			  	Cs[RT_CI]=1;								  
										}
										else{
										   	nSal_ini[RT_CI]=n2-1;
							  			  	nSal_ini_Nor[RT_CI]=n2-1;			  			  			  			  	 
							  			  	Cs[RT_CI]=1;					  			  	
		        						}				  			  	
					  			  }			  			  
					  			}			  			
					  		}
					  		if(GenRecT_t_1[RT_CI]>GenRecT_t_2[RT_CI] && GenRecT_t_1[RT_CI]<0.95*SegRampas_Caliente[CT_CI.CONF][1]){
					  		  	GenRecT_t_2[RT_CI]=0;
					  			GenRecT_t_1[RT_CI]=0;	
					  			Tiempo_en_Linea[RT_CI]=0;
					  			Tiempo_fuera_Linea[RT_CI]=Math.max(Tiempo_fuera_Linea[RT_CI],2);
							}
							if(GenRecT_t_1[RT_CI]<GenRecT_t_2[RT_CI] && GenRecT_t_1[RT_CI]<0.95*SegRampas_Salida[CT_CI.CONF][nSegmentoSalida[CT_CI.CONF]]){
					  		  	GenRecT_t_1[RT_CI]=0;	
					  			Tiempo_en_Linea[RT_CI]=0;
					  			Tiempo_fuera_Linea[RT_CI]=Math.max(Tiempo_fuera_Linea[RT_CI],1);							  
							}
					  		if(GenRecT_t_1[RT_CI]==GenRecT_t_2[RT_CI]){
					  			GenRecT_t_1[RT_CI]=0;
					  			GenRecT_t_2[RT_CI]=0;
					  			Tiempo_en_Linea[RT_CI]=0;
					  			Tiempo_fuera_Linea[RT_CI]=Math.max(Tiempo_fuera_Linea[RT_CI],2);
					  		}
						}
						else{
								GenRecT_t_1[RT_CI]=0;
					  			Tiempo_en_Linea[RT_CI]=0;
					  			Tiempo_fuera_Linea[RT_CI]=Math.max(Tiempo_fuera_Linea[RT_CI],1);					  
						}									  		
			 		} 
	 			}				  
			} 
		}	
	}	
}
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   DECLARACI�N DE VARIABLES   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*|����������������������������������������������������������������������������������������VARIABLES CONTINUAS DEL MODELO�������������������������������������������������������������������������������������|*/
dvar float+ V_Gen_Rec[Recursos][Periodos];								/*Generaci�n asignada a cada recurso en cada periodo*/
dvar float+ V_GenFirme[Rec_Termicos][Periodos];							/*Generaci�n en firme del recurso t�rmico*/
dvar float+ V_GenRampaDR[Rec_Termicos][Periodos];						/*Generaci�n de rampa de salida del recurso t�rmico que tiene modelo de rampas*/
dvar float+ V_GenRampaUR[Rec_Termicos][Periodos];						/*Generaci�n de rampa de entrada del recurso t�rmico que tiene modelo de rampas*/
dvar float+ V_RacionamientoSubArea[Subarea][Periodos];					/*Racionamiento asignada a cada sub�rea en cada periodo*/
dvar float+ V_RacSubAreaFO[Subarea][Periodos];							/*Racionamiento asignada a cada sub�rea en cada periodo que se penaliza en la funci�n objetivo*/
dvar float+ V_RacSubAreaProgramado[Subarea][Periodos];					/*Racionamiento programado asignado a cada sub�rea en cada periodo*/
dvar float+ V_Racionamiento[Periodos];									/*Racionamiento en cada periodo (Se utiliza solamente para el despacho ideal)*/
dvar float+ V_Gen_Und[Unidades][Periodos];								/*Generaci�n asignada a cada unidad en cada periodo*/
dvar float+ V_GenUndFirme[Und_Termica][Periodos];						/*Generaci�n en firme de la unidad t�rmica*/
dvar float+ V_GenUndRampaDR[Und_Termica][Periodos];						/*Generaci�n de rampa de salida de la unidad t�rmica que tiene modelo de rampas*/
dvar float+ V_GenUndRampaUR[Und_Termica][Periodos];						/*Generaci�n de rampa de entrada de la unidad t�rmica que tiene modelo de rampas*/
dvar float  V_IntSubArea[Subarea][Periodos];							/*Variable para almacenar el intercambio de la subarea*/
dvar float  V_IntArea[Areas][Periodos];									/*Variable para almacenar el intercambio del �rea*/
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������������VARIABLES CONTINUAS DE HOLGURA DEL MODELO��������������������������������������������������������������������������������|*/
dvar float+ Ho_Z_UndMin[Zonas_UndMinimas][Periodos];					/*Variable de holgura para relajar las zonas de unidades m�nimas*/
dvar float+ Ho_Z_MWMin[Zonas_MWMinimos][Periodos]; 						/*Variable de holgura para relajar las zonas de MW m�nimos*/
dvar float+ Ho_Z_MWMax[Zonas_MWMaximos][Periodos];						/*Variable de holgura para relajar las zonas de MW m�ximos*/
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������������������VARIABLES BINARIAS DEL MODELO��������������������������������������������������������������������������������������|*/
/*IMPORTANTE: Si se adiciona una variable binaria o entera nueva, hay que modificar el script Main_ProgRec, esto debido a que  es necesario fijarlos para el c�lculo del marginal*/
dvar boolean B_OnOff_Rec[Rec_Hidraulico union Rec_Solar union Rec_Eolico][Periodos];	/*On Off de los recursos a excepci�n de los t�rmicos, si este se enciende el resultado debe ser 1*/
dvar boolean B_OnOff_RecT[Rec_Termicos][Periodos];						/*On Off del recurso t�rmico, si este se enciende el resultado debe ser 1*/
dvar boolean B_RampaUR[Rec_Termicos][Periodos];						/*Si en un periodo existe generaci�n V_GenRampaUR para un recurso en un periodo*/
dvar boolean B_RampaDR[Rec_Termicos][Periodos];						/*Si en un periodo existe generaci�n V_GenRampaDR para un recurso en un periodo*/
//dvar boolean B_Arranque[Rec_Termicos][Periodos];							/*Arranque del recurso t�rmico, si este arranca en el periodo t el resultado debe ser 1.  Se toma respecto la generaci�n en firme*/
dvar float+  B_Arranque[Rec_Termicos][Periodos];						/*Aunque es una variable binaria, esto lo obligan las restricciones y se puede definir como continua*/
dvar boolean B_Parada[Rec_Termicos][Periodos];							/*Parada del recurso t�rmico, si este para en el periodo t el resultado debe ser 1. Se toma respecto la generaci�n en firme*/
//dvar boolean B_Arr_Caliente[Rec_Termicos][Periodos];					/*Arranque en caliente del recurso t�rmico, si est� en estado caliente el valor del arranque debe ser 1*/	
dvar float+  B_Arr_Caliente[Rec_Termicos][Periodos];					/*Aunque es una variable binaria, esto lo obligan las restricciones y se puede definir como continua*/
dvar boolean B_Arr_Tibio[Rec_Termicos][Periodos];						/*Arranque en Tibio del recurso t�rmico, si est� en estado caliente el valor del arranque debe ser 1*/	
dvar boolean B_Arr_Frio[Rec_Termicos][Periodos];						/*Arranque en Frio del recurso t�rmico, si est� en estado caliente el valor del arranque debe ser 1*/
dvar boolean B_Ufact[BloquesFactibles][Periodos];						/*Indica que intervalo factible se activ� en cada periodo para los recursos con zonas infactibles*/
dvar boolean B_uFact_min[RecInfact_Esp][Periodos];						/*Indica si la generaci�n del recurso t�rmico con zona infactible especial est� en el intervalo m�nimo factible */
dvar boolean B_uInfact[RecInfact_Esp][Periodos];						/*Indica si la generaci�n del recurso t�rmico con zona infactible especial est� en el intervalo infactible */
dvar boolean B_uFact_max[RecInfact_Esp][Periodos];						/*Indica si la generaci�n del recurso t�rmico con zona infactible especial est� en el intervalo m�ximo factible*/
//dvar boolean B_Par_Normal[Rec_Termicos][Periodos];						/*Indica si la parada del recurso se da por la salida de bloques normal*/
dvar float+  B_Par_Normal[Rec_Termicos][Periodos];						/*Aunque es una variable binaria, esto lo obligan las restricciones y se puede definir como continua*/
dvar boolean B_Par_Especial[Rec_Termicos][Periodos];						/*Indica si la parada del recurso se da por la salida de bloque especial*/
dvar boolean B_UR[Interv_UR][Periodos];								/*Indica si el intervalo del modelo 2 para subir (UR) se activa o no*/	
dvar boolean B_DR[Interv_DR][Periodos];								/*Indica si el intervalo del modelo 2 para bajar (DR) se activa o no*/
dvar boolean B_DR_Prima[RT_DRPrima][Periodos];							/*Indica si aplica o no el despacho alternativo de bajada  entre la generaci�n del periodo t-1 y t*/
dvar boolean B_UR_Prima[RT_URPrima][Periodos];							/*Indica si aplica o no el despacho alternativo de subida  entre la generaci�n del periodo t-1 y t*/
dvar boolean B_uDisp[RT_DRPrima][Periodos];							/*Indica si la generaci�n del recurso se encuentra en la disponibilidad*/
dvar boolean B_uMinT[RT_URPrima][Periodos];							/*Indica si la generaci�n del recurso se encuentra en el m�nimo t�cnico*/
dvar boolean B_bCE[RT_ModCE][Periodos];								/*Indica si la diferencia de la generaci�n entre dos periodos supera el m�ximo valor para CE*/		
dvar boolean B_RHUR[IntervRH_UR][Periodos];							/*Indica si el intervalo del modelo 2 para subir (UR) se activa o no. Rec. Hidr�ulicos*/	
dvar boolean B_RHDR[IntervRH_DR][Periodos];							/*Indica si el intervalo del modelo 2 para bajar (DR) se activa o no. Rec. Hidr�ulicos*/	
dvar boolean B_OnOff_Und[Und_Hidraulica union Und_Solar union Und_Eolica][Periodos];		/*On Off de la unidad, si este se enciende el resultado debe ser 1 (No aplica para unidades t�rmicas)*/	
dvar boolean B_OnOff_UMenor[Und_noCentral][Periodos];						/*On Off de la unidad no despachada centralmente, si este se enciende el resultado debe ser 1*/	
dvar boolean B_OnOff_UndT[Und_Termica][Periodos];						/*On Off de la unidad t�rmica, si este se enciende el resultado debe ser 1*/
dvar boolean B_MC_On[Rec_Termicos][Periodos];							/*Variable binaria que indica que el recurso tiene una generaci�n mayo que cero*/
//dvar boolean B_MC_Arr[Rec_Termicos][Periodos];						/*Variable binaria que indica que el recurso arranc� con referencia a una generaci�n mayor que cero*/
dvar float+  B_MC_Arr[Rec_Termicos][Periodos];							/*Aunque es una variable binaria, esto lo obligan las restricciones y se puede definir como continua*/
dvar boolean B_MC_Par[Rec_Termicos][Periodos];							/*Variable binaria que indica que el recurso par� con referencia a una generaci�n mayor que cero*/
//dvar boolean B_MC_Arr_Caliente[Rec_Termicos][Periodos];					/*Arranque Caliente del recurso respeco la generaci�n Mayor que cero*/			
dvar float+  B_MC_Arr_Caliente[Rec_Termicos][Periodos];						/*Aunque es una variable binaria, esto lo obligan las restricciones y se puede definir como continua*/
dvar boolean B_MC_Arr_Tibio[Rec_Termicos][Periodos];						/*Arranque Tibio del recurso respeco la generaci�n Mayor que cero*/
dvar boolean B_MC_Arr_Frio[Rec_Termicos][Periodos];						/*Arranque Frio del recurso respeco la generaci�n Mayor que cero*/
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/



/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   DECLARACI�N DE RESTRICCIONES   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*|���������������������������������������������������������������������������������RESTRICCIONES GENERALES PARA LOS RECURSOS���������������������������������������������������������������������������������|*/
constraint BalanceGlobal[Periodos];								/*Balance global, corresponde a la atenci�n de la demanda en todos los periodos*/
constraint Disp_Recursos[Recursos][Periodos];							/*Limitaci�n de la generaci�n al m�nimo valor entre la disponibilidad ofertada por cada recurso en cada periodo y el valor m�ximo
												  ingresado por perfiles de Recurso en DRP*/
constraint MinTecnico_Rec[Rec_Hidraulico union Rec_Solar union Rec_Eolico][Periodos];		/*La generaci�n del recurso debe ser mayor al m�nimo t�cnico si este se utiliza (aplica para los recursos a excepci�n de los t�rmicos)*/
constraint Dispon_Rec[Rec_Hidraulico union Rec_Solar union Rec_Eolico][Periodos];		/*La generaci�n del recurso debe ser menor a la disponibildad si este se utiliza (aplica para los recursos a excepci�n de los t�rmicos)*/																		  
constraint GenMin_Recurso[Recursos][Periodos];							/*Generaci�n m�nima obligada ingresada por perfiles de Recurso en DRP*/
constraint GenInflex_Recurso[Recursos][Periodos];						/*Generaci�n m�nima obligada por inflexibilidades.  SOLO APLICA PARA EL IDEAL*/
constraint GenEnficc_Recurso[Recursos][Periodos];						/*Limitaci�n de la generaci�n al techo por ENFICC para los generadores que aplique*/
constraint Pruebas[Recursos][Periodos];									/*Generaci�n de los recursos que se encuentran en pruebas*/
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/    


/*|���������������������������������������������������������������������������������������RECURSOS CON ZONAS INFACTIBLES��������������������������������������������������������������������������������������|*/
constraint MinValFactible[RecursosInfactibles][Periodos];				/*Restricci�n auxiliar para identificar si la generaci�n est� por encima del valor m�nimo factible*/
constraint MaxValFactible[RecursosInfactibles][Periodos];				/*Restricci�n auxiliar para identificar si la generaci�n est� por debajo del valor m�ximo factible*/
constraint Ufact_OnOff[RecursosInfactibles][Periodos];					/*Relaciona el OnOff del recurso con la Ufact, si el recurso no se enciende se garantiza que ningun intervalo se encienda */
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|����������������������������������������������������������������������������������RECURSOS CON ZONAS INFACTIBLES ESPECIALES��������������������������������������������������������������������������������|*/   
constraint Infact_Esp_Inf[RecInfact_Esp][Periodos];						/*L�mite inferior para la generaci�n factible m�nima, generaci�n infactible y generaci�n factible m�xima, respectivamente*/
constraint Infact_Esp_Sup[RecInfact_Esp][Periodos];						/*L�mite superior para la generaci�n factible m�nima, generaci�n infactible y generaci�n factible m�xima, respectivamente*/
constraint Causalidad_Infact[RecInfact_Esp][Periodos];					/*Permite que la generaci�n infactible solamente se active en uno de dos periodos consecutivos*/
constraint Causalidad_ZonasF[RecInfact_Esp][Periodos];					/*Permite que en un mismo periodo solamente se active uno de los intervalos*/
constraint Causalidad_InfactibleUp[RecInfact_Esp][Periodos];			/*Si la generaci�n va subiendo, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_InfactibleDn[RecInfact_Esp][Periodos]; 			/*Si la generaci�n va bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_MT_Ginf_Rampa[RecInfact_Esp][Periodos];			/*Causalidad MT-Ginf-Rampa  para que no haga por ejemplo 31-49-16*/
constraint Causalidad_Rampa_Ginf_MT[RecInfact_Esp][Periodos]; 			/*Causalidad Rampa-Ginf-MT  para que no haga por ejemplo 16-49-31*/
constraint Auxiliar_uInfact_CE[RecInfact_Esp][Periodos]; 				/*Restricci�n auxiliar para garantizar que en pruebas de las ZIPAS sea cero el intervalo infactible, esto es porque 
	  																	en pruebas no se aplica el modelo de infactibilidad de ZIPAS, y esta variable se utiliza en las retricciones de 
	  																	carga estable */
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|����������������������������������������������������������������������RECURSOS CON ZONAS INFACTIBLES ESPECIALES EN LA CONDICI�N INICIAL��������������������������������������������������������������������|*/  
constraint Causalidad_Infac_CI[RecInfact_Esp];						/*Condici�n inicial para que la generaci�n infactible solamente se active en uno de dos periodos consecutivos*/
constraint Causalidad_InfactibleUp_CI[RecInfact_Esp];					/*Condici�n inicial para la generaci�n subiendo, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_MT_Ginf_Rampa_CI[RecInfact_Esp];					/*Condici�n inicial para la generaci�n bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_InfactibleUp_CI_C[RecInfact_Esp];					/*Condici�n inicial COMPLEMENTARIA para la generaci�n subiendo, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_MT_Ginf_Rampa_CI_C[RecInfact_Esp];				/*Condici�n inicial COMPLEMENTARIA para la Causalidad MT-Ginf-Rampa*/
constraint Causalidad_InfactibleDn_CI[RecInfact_Esp];					/*Condici�n inicial para la generaci�n bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_InfactibleDn_CI_C[RecInfact_Esp];					/*Condici�n inicial COMPLEMENTARIA para la generaci�n bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
constraint Causalidad_Rampa_Ginf_MT_CI[RecInfact_Esp];					/*Condici�n inicial para la Causalidad Rampa-Ginf-MT*/
constraint Causalidad_Rampa_Ginf_MT_CI_C[RecInfact_Esp];				/*Condici�n inicial COMPLEMENTARIA para la Causalidad Rampa-Ginf-MT*/
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������RESTRICCIONES GENERALES PARA LOS RECURSOS T�RMICOS����������������������������������������������������������������������������|*/		
constraint Mod_RecTermico[Rec_Termicos][Periodos];						/*Partici�n de la generaci�n del recurso t�rmico en Generaci�n firme, rampa de entrada y rampa de salida*/
constraint MinTecnico_RecT[Rec_Termicos][Periodos];						/*La generaci�n del recurso T�rmico debe ser mayor al m�nimo t�cnico si este se utiliza*/	
constraint Disp_RecT[Rec_Termicos][Periodos];							/*La generaci�n del recurso T�rmico debe ser menor a la disponibildad si este se utiliza*/
constraint Mod1_Ent_Inactivo[Rec_Termicos][Periodos];					/*Se iguala al valor de Rampa obligado por perfiles cuando el Modelo 1 de entrada est� inactivo*/
constraint Mod1_Sal_Inactivo[Rec_Termicos][Periodos];					/*Se iguala al valor de Rampa obligado por perfiles cuando el Modelo 1 de salida est� inactivo*/
constraint Mod1_Inactivo[Rec_Termicos][Periodos];						/*Se iguala al valor de Rampa obligado por perfiles cuando el Modelo 1 de salida y entrada est� inactivo*/
constraint CausalRampasONOFF[Rec_Termicos][Periodos];						/*Solo permite que se active en un periodo los bloques para subir o para bajar, cuando el ONOFF sea cero*/
constraint CausalidaRampasUR[Rec_Termicos][Periodos];					/*Garantiza que la generaci�n de rampa UR solo exista cuando el OnOff sea cero */
constraint CausalidaRampasDR[Rec_Termicos][Periodos];					/*Garantiza que la generaci�n de rampa DR solo exista cuando el OnOff sea cero*/
constraint ArranqueParada[Rec_Termicos][Periodos];						/*Relaci�n de arranque y parada para los recursos t�rmicos, se define en funci�n del OnOff*/
constraint ArranqueParada_Inicial[Rec_Termicos];						/*Condici�n inicial para el arranque-parada del recurso t�rmico*/
constraint Numero_Arranques[Rec_Termicos];								/*N�mero m�ximo de arranques permitidos para un recurso t�rmico*/
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������������������������������ON_OFF Y ARRANQUES PARA LA GENERACI�N MAYOR A CERO����������������������������������������������������������������������������|*/
constraint MayorQueCero[Rec_Termicos][Periodos];						/*Identifica que la generaci�n del recurso t�rmico sea mayor a cero*/
constraint DispMayorQueCero[Rec_Termicos][Periodos];					/*Cota superior para la activaci�n de la variable binaria que identifica que la generaci�n del recurso es mayor a cero*/
constraint ArrPar_MayorQueCero[Rec_Termicos][Periodos];					/*Relaci�n de arranque y parada para los recursos t�rmicos, con referencia a que la generaci�n del recurso sea mayor que cero*/
constraint ArrPar_MayorQueCero_CI[Rec_Termicos];						/*Condici�n inicial para el arranque-parada de generaci�n mayor que cero del recurso t�rmico*/
constraint Parada__DN_CI[Rec_Termicos];									/*Parada obligada seg�n los bloques de salida normal en la condici�n inicial, respecto la generaci�n mayor a cero*/
constraint Parada__DNE_CI[Rec_Termicos];								/*Parada obligada seg�n los bloques de salida especial en la condici�n inicial, respecto la generaci�n mayor a cero*/  
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������RESTRICCIONES M�NIMO TIEMPO EN L�NEA Y FUERA DE L�NEA���������������������������������������������������������������������������|*/    
constraint TiempoMinLinea_Pend[Rec_Termicos];							/*Tiempo m�nimo en l�nea que debe quedar el recurso seg�n la condici�n inicial*/
constraint TiempoMinimoLinea[Rec_Termicos][Periodos];					/*Tiempo m�nimo en l�nea que debe quedar el recurso seg�n el arranque*/
constraint TiempoMinFLinea_Pend[Rec_Termicos];							/*Tiempo m�nimo fuera de l�nea que debe quedar el recurso seg�n la condici�n inicial*/
constraint TiempoMinimoFLinea[Rec_Termicos][Periodos];					/*Tiempo m�nimo fuera de l�nea que debe quedar el recurso seg�n la parada (Respecto la generaci�n mayor a cero)*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�������������������������������������������������������������������������������������������ARRANQUES POR ESTADO�������������������������������������������������������������������������������������������|*/
constraint Tipos_Arranque[Rec_Termicos][Periodos];						/*Partici�n de variable de arranque en tres: caliente, tibio, frio*/
constraint Tipos_Arranque_MC[Rec_Termicos][Periodos];					/*Partici�n de variable de arranque en tres: caliente, tibio, frio.  (Respecto la generaci�n mayor a cero)*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*|���������������������������������������������������������������������������������������ARRANQUES POR ESTADO: CALIENTE�������������������������������������������������������������������������������������|*/
constraint Arranque_Caliente[Rec_Termicos][Periodos];					/*Condiciones para que el arranque del recurso t�rmico sea en caliente*/
constraint Relacion_Arr_Caliente[Rec_Termicos][Periodos];				/*Relacion de los arranques de generaci�n en firme y generaci�n mayor que cero para el estado caliente*/
constraint Arr_Caliente_Ini[Rec_Termicos];								/*Arranque obligado debido a que se tienen bloques de entrada en caliente pendientes*/
constraint TechoArrIniCaliente[Rec_Termicos][Periodos];					/*Techo para el arranque inicial caliente seg�n el modelo 1*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/																																										

/*|�����������������������������������������������������������������������������������������ARRANQUES POR ESTADO: TIBIO��������������������������������������������������������������������������������������|*/		
constraint Arranque_Tibio[Rec_Termicos][Periodos];						/*Condiciones para que el arranque del recurso t�rmico sea en tibio*/
constraint Relacion_Arr_Tibio[Rec_Termicos][Periodos];					/*Relacion de los arranques de generaci�n en firme y generaci�n mayor que cero para el estado tibio*/
constraint Arr_Tibio_Ini[Rec_Termicos];									/*Arranque obligado debido a que se tienen bloques de entrada en tibio pendientes*/
constraint TechoArrIniTibio[Rec_Termicos][Periodos];					/*Techo para el arranque inicial tibio seg�n el modelo 1*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/																																	

/*|�����������������������������������������������������������������������������������������ARRANQUES POR ESTADO: FRIO���������������������������������������������������������������������������������������|*/	
constraint Arranque_Frio[Rec_Termicos][Periodos];						/*Condiciones para que el arranque del recurso t�rmico sea en frio*/
constraint Relacion_Arr_Frio[Rec_Termicos][Periodos];					/*Relacion de los arranques de generaci�n en firme y generaci�n mayor que cero para el estado Frio*/
constraint Arr_Frio_Ini[Rec_Termicos];									/*Arranque obligado debido a que se tienen bloques de entrada en frio pendientes*/
constraint TechoArrIniFrio[Rec_Termicos][Periodos];						/*Techo para el arranque inicial frio seg�n el modelo 1*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/     


/*|��������������������������������������������������������������������������������TIEMPO DE AVISO SEG�N PERIODO DE PUBLICACI�N������������������������������������������������������������������������������|*/
constraint Techo_TiempoAviso_Caliente[Rec_Termicos][Periodos]; 			/*Techo correspondiente al tiempo de aviso en caliente*/
constraint Techo_TiempoAviso_Tibio[Rec_Termicos][Periodos]; 			/*Techo correspondiente al tiempo de aviso en tibio*/
constraint Techo_TiempoAviso_Frio[Rec_Termicos][Periodos];		 		/*Techo correspondiente al tiempo de aviso en frio*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������������������TIEMPO DE CALENTAMIENTO�����������������������������������������������������������������������������������������|*/
constraint Techo_TCalentamiento_Caliente[Rec_Termicos][Periodos]; 		/*Techo correspondiente al tiempo de calentamiento en Caliente*/
constraint Techo_TCalentamiento_Tibio[Rec_Termicos][Periodos];			/*Techo correspondiente al tiempo de calentamiento en Tibio*/
constraint Techo_TCalentamiento_Frio[Rec_Termicos][Periodos];			/*Techo correspondiente al tiempo de calentamiento en Frio*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 1�������������������������������������������������������������������������������������|*/
constraint Modelo1_Entrada[Rec_Termicos][Periodos];						/*Descripci�n del modelo 1 para rampas de entrada caliente, tibio y frio*/
constraint Modelo1_Salida[Rec_Termicos][Periodos];						/*Descripci�n del modelo 1 para rampas de salida*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	
	

/*|���������������������������������������������������������������������������������RESTRICCIONES DE SALIDA ESPECIAL Y NORMAL��������������������������������������������������������������������������������|*/
constraint BloqueNormal_Especial[Rec_Termicos][Periodos];				/*Partici�n de la variable Parada en Bloque especial o Bloque normal*/
constraint Bloque_Especial_Cero[Rec_Termicos][Periodos];				/*Se garantiza que los recursos que no tienen salida especial tengan esta variable como cero*/
constraint Bloque_Especial_Cero_CI[Rec_Termicos];						/*Se garantiza que los recursos que no tienen salida especial tengan esta variable como cero en la condici�n inicial*/
constraint Activ_Bloque_Esp[Rec_Salida_Esp][Periodos];					/*Activaci�n del bloque de salida especial*/
constraint Activ_Bloque_Esp_CI[Rec_Salida_Esp];							/*Activaci�n del bloque de salida especial en la condici�n inicial*/
constraint Activ_Blq_Esp_TEMCALI[Periodos];								/*Activaci�n del bloque de salida especial para TEMCALI*/
constraint Activ_Blq_Esp_TEMCALI_CI[Pini .. Pini];						/*Activaci�n del bloque de salida especial en la condici�n inicial para TEMCALI*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|���������������������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 2�������������������������������������������������������������������������������������|*/
constraint UR_DR_Vmin[RT_Mod2][Periodos];								/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar*/
constraint UR_DR_Vmax[RT_Mod2][Periodos];								/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar*/
constraint UR_MaxVar[RT_Mod2][Periodos];								/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active*/
constraint DR_MaxVar[RT_Mod2][Periodos];								/*L�mita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active*/
constraint UR_DR_Causal[RT_Mod2][Periodos];								/*Verifica que solo se active uno de los intervalos ya sea para subir o bajar en un periodo*/
constraint UR_DR_Vmin_Frt[RT_Mod2][Periodos];							/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2*/
constraint UR_DR_Vmax_Frt[RT_Mod2][Periodos];							/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2*/
constraint UR_MaxVar_Frt[RT_Mod2][Periodos];							/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la frontera Mod1-Mod2*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 2 EN LA CONDICI�N INICIAL�������������������������������������������������������������������������|*/
constraint UR_DR_Vmin_CI[RT_Mod2];										/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la condici�n inicial*/
constraint UR_DR_Vmax_CI[RT_Mod2];										/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la condici�n inicial*/
constraint UR_MaxVar_CI[RT_Mod2];										/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la condici�n inicial*/					
constraint DR_MaxVar_CI[RT_Mod2];										/*L�mita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active en la condici�n inicial*/
constraint UR_DR_Vmin_Frt_CI[RT_Mod2];									/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2 en la condici�n inicial*/
constraint UR_DR_Vmax_Frt_CI[RT_Mod2];									/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2 en la condici�n inicial*/
constraint UR_MaxVar_Frt_CI[RT_Mod2];									/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la frontera Mod1-Mod2 en la condici�n inicial*/
constraint UR_DR_Causal_CI[RT_Mod2];									/*Verifica que solo se active uno de los intervalos ya sea para subir o bajar en la condici�n inicial*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������RESTRICCIONES PARA EL DESPACHO ALTERNATIVO�������������������������������������������������������������������������������|*/
constraint URp_Prima[RT_URPrima][Periodos];								/*Limita la m�xima variaci�n para subir con un despacho alternativo*/
constraint Actv_MinT[RT_URPrima][Periodos];								/*Define cuando la generaci�n en firme es igual al m�nimo t�cnico*/
constraint Actv_Disp[RT_DRPrima][Periodos];								/*Define cuando la generaci�n en firme es igual a la disponibilidad*/
constraint DRp_Prima[RT_DRPrima][Periodos];								/*Limita la m�xima variaci�n para bajar con un despacho alternativo*/
constraint Activacion_URp[RT_URPrima][Periodos];						/*Activaci�n del despacho alternativo para subir, se iguala al DR del periodo anterior*/
constraint Activacion_DRp[RT_DRPrima][Periodos];						/*Activaci�n del despacho alternativo para bajar, se iguala al UR del periodo anterior*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/    


/*|����������������������������������������������������������������������RESTRICCIONES PARA EL DESPACHO ALTERNATIVO EN LA CONDICI�N INICIAL������������������������������������������������������������������|*/
constraint URp_Prima_CI[RT_URPrima];									/*Limita la m�xima variaci�n para subir con un despacho alternativo en la condici�n inicial*/
constraint DRp_Prima_CI[RT_DRPrima];									/*Limita la m�xima variaci�n para bajar con un despacho alternativo en la condici�n inicial*/
constraint Activ_URp_CI_Pini[RT_URPrima];								/*Activaci�n del despacho alternativo para subir para el periodo Pini, se iguala al DR del periodo anterior*/
constraint Activ_URp_CI_Pini_1[RT_URPrima];								/*Activaci�n del despacho alternativo para subir para el periodo Pini+1, se iguala al DR del periodo anterior*/
constraint Activ_DRp_CI_Pini[RT_DRPrima];								/*Activaci�n del despacho alternativo para bajar para el periodo Pini, se iguala al UR del periodo anterior*/
constraint Activ_DRp_CI_Pini_1[RT_DRPrima];								/*Activaci�n del despacho alternativo para bajar para el periodo Pini+1, se iguala al UR del periodo anterior*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 3�������������������������������������������������������������������������������������|*/
constraint Modelo3_Up[RT_Mod3][Periodos];								/*Limitaci�n de la generaci�n con el modelo 3 para subir*/       
constraint Modelo3_Dn[RT_Mod3][Periodos];								/*Limitaci�n de la generaci�n con el modelo 3 para bajar*/
constraint Modelo3_Up_Frt[RT_Mod3][Periodos];							/*Limitaci�n de la generaci�n con el modelo 3 para subir en la frontera mod1-mod3*/
constraint Modelo3_Up_CI[RT_Mod3];										/*Limitaci�n de la generaci�n con el modelo 3 para subir en la condici�n inicial*/
constraint Modelo3_Dn_CI[RT_Mod3];										/*Limitaci�n de la generaci�n con el modelo 3 para bajar en la condici�n inicial*/
constraint Modelo3_Up_Frt_CI[RT_Mod3];									/*Limitaci�n de la generaci�n con el modelo 3 para subir en la frontera mod1-mod3 en la condici�n inicial*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������������������MODELO DE CARGA ESTABLE�����������������������������������������������������������������������������������������|*/
constraint Max_CE_Up[RT_ModCE][Periodos];								/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n sube*/
constraint Max_CE_Dn[RT_ModCE][Periodos];								/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n baja*/
constraint CargaEstableUp[RT_ModCE][Periodos][Periodos];				/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n sube*/
constraint CargaEstableDn[RT_ModCE][Periodos][Periodos];				/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n baja*/
constraint CE_uInfact_Esp[RT_ModCE][Periodos];							/*Si en un mismo periodo se activa el cambio por CE y la generaci�n infactible especial, la bandera de CE se pasa el siguiente periodo*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������MODELO DE CARGA ESTABLE EN LA CONDICI�N INICIAL�����������������������������������������������������������������������������|*/   
constraint Max_CE_Up_CI[RT_ModCE];										/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n sube en la condici�n inicial*/		
constraint Max_CE_Dn_CI[RT_ModCE];										/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n baja en la condici�n inicial*/		
constraint CargaEstableUp_CI[RT_ModCE][Periodos];						/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n sube en la condici�n inicial*/
constraint CargaEstableDn_CI[RT_ModCE][Periodos];						/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n sube*/
constraint CE_uInfact_Esp_CI[RT_ModCE];									/*Si en Pini-1 se activa el cambio por CE y la generaci�n infactible especial, la bandera de CE se pasa el periodo Pini*/	
constraint CE_Inicial[RT_ModCE][Periodos];								/*Iguala la generaci�n de los periodos restantes cuando se debe carga estable*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������������MODELO DE RAMPAS DE RECURSOS HIDR�ULICOS��������������������������������������������������������������������������������|*/
constraint RHUR_DR_Vmin[RH_ModRamp][Periodos];							/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar. Rec Hidr�ulicos*/
constraint RHUR_DR_Vmax[RH_ModRamp][Periodos];							/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar. Rec Hidr�ulicos*/
constraint RHUR_MaxVar[RH_ModRamp][Periodos];							/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active. Rec Hidr�ulicos*/					
constraint RHDR_MaxVar[RH_ModRamp][Periodos];							/*L�mita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active. Rec Hidr�ulicos*/
constraint RHUR_DR_Causal[RH_ModRamp][Periodos];						/*Verifica que solo se active uno de los intervalos ya sea para subir o bajar en un periodo. Rec Hidr�ulicos*/
constraint RHUR_DR_Vmin_CI[RH_ModRamp];									/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la condici�n inicial. Rec Hidr�ulicos*/
constraint RHUR_DR_Vmax_CI[RH_ModRamp];									/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la condici�n inicial. Rec Hidr�ulicos*/
constraint RHUR_MaxVar_CI[RH_ModRamp];									/*Limita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la condici�n inicial. Rec Hidr�ulicos*/					
constraint RHDR_MaxVar_CI[RH_ModRamp];									/*Limita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active en la condici�n inicial. Rec Hidr�ulicos*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|��������������������������������������������������������������������������������RESTRICCIONES GENERALES PARA LAS UNIDADES���������������������������������������������������������������������������������|*/
constraint Relacion_Recurso_Unidad[Recursos][Periodos];					/*La generaci�n de cada recurso debe ser igual a la suma de todas sus unidades*/
constraint Disp_Unidades[Unidades][Periodos];						/*Limitaci�n de la generaci�n de la unidad a la disponibilidad ofertada*/
constraint MinTecnico_Und[Unidades][Periodos];  					/*La generaci�n de la unidad debe ser mayor al m�nimo t�cnico si esta se utiliza (no aplica para las t�rmicas)*/
constraint Disponibilidad_Und[Unidades][Periodos];  					/*La generaci�n de la unidad  debe ser menor a la disponibildad si este se utiliza (no aplica para t�rmicas)*/
constraint MinTecnico_UMenor[Und_noCentral][Periodos];  				/*La generaci�n de la unidad menor debe ser mayor al m�nimo t�cnico si esta se utiliza*/
constraint Disponibilidad_UMenor[Und_noCentral][Periodos];  				/*La generaci�n de la unidad menor debe ser menor a la disponibildad si este se utiliza*/
constraint AGCUp_Und[UnidadesAGC][Periodos];						/*L�mite inferior de la generaci�n de una unidad que tiene asignado AGC*/
constraint AGCDn_Und[UnidadesAGC][Periodos];						/*L�mite superior de la generaci�n de una unidad que tiene asignado AGC*/
constraint GenOblMin_Und[Unidades][Periodos];						/*Generaci�n m�nima obligada para las unidades de generaci�n*/
constraint GenOblMax_Und[Unidades][Periodos];						/*Generaci�n m�xima obligada para las unidades de generaci�n*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/   	


/*|��������������������������������������������������������������������������������RESTRICCIONES PARA LAS UNIDADES T�RMICAS���������������������������������������������������������������������������������|*/
constraint MinTecnico_UndT[Und_Termica][Periodos];  					/*La generaci�n en firme de la unidad t�rmica debe ser mayor al m�nimo t�cnico si esta se utiliza*/
constraint Disponibilidad_UndT[Und_Termica][Periodos]; 					/*La generaci�n de la unidad t�rmica debe ser menor a la disponibildad si este se utiliza*/
constraint Modelo_UndT[Und_Termica][Periodos];  						/*Partici�n de la generaci�n de la unidad t�rmica en: generaci�n firme, rampa de entrada y rampa de salida*/
constraint RampaUR_RecUnd[Rec_Termicos][Periodos];						/*La generaci�n por rampa de entrada de las unidades t�rmicas debe corresponder a la del recurso*/	
constraint RampaDR_RecUnd[Rec_Termicos][Periodos];						/*La generaci�n por rampa de salida de las unidades t�rmicas debe corresponder a la del recurso*/
constraint GFirme_RecUnd[Rec_Termicos][Periodos];						/*La generaci�n en firme de las unidades t�rmicas debe corresponder a la del recurso*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�������������������������������������������������������������������������������RESTRICCIONES PARTICULARES PARA LAS UNIDADES�������������������������������������������������������������������������������|*/   	
constraint MinTecUnd_Esp[Und_Hidraulica][Periodos];	 					/*M�nimo t�cnico de las unidades con m�nimo t�cnico especial, equivale al m�nimo ingresado por perfiles para esas unidades*/
constraint OnOffDisp0[Und_Hidraulica union Und_Solar union Und_Eolica][Periodos];		/*Cuando la disponibilidad es 0 para los recursos de minimo t�cnico 0, garantiza que el ONOFF sea 0*/
constraint CadenaHid_Pagua[Periodos];								/*Obliga la generaci�n de PAraiso y Guaca seg�n la relaci�n de la cadena*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|��������������������������������������������������������������������������������������������ZONAS DE SEGURIDAD��������������������������������������������������������������������������������������������|*/
constraint Unds_Minimas_Seg[Zonas_UndMinimas][Periodos];				/*Cumplimiento de las unidades m�nimas necesarias por seguridad*/
constraint MW_Minimos_Seg[Zonas_MWMinimos][Periodos];					/*Cumplimiento de generaci�n m�nima necesaria por seguridad*/
constraint MW_Maximos_Seg[Zonas_MWMaximos][Periodos];					/*Cumplimiento de generaci�n m�xima necesaria por seguridad*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������������������������������������L�MITES DE EXPORTACI�N E IMPORTACI�N�����������������������������������������������������������������������������������|*/
constraint Intercambio_Sub[Subarea][Periodos];							/*Restricci�n de la variable para almacenar el intercambio de la subarea*/
constraint Limite_Imp_Sub[Subarea][Periodos];							/*Cumplimiento del l�mite de importaci�n de la sub�rea*/
constraint Limite_Exp_Sub[Subarea][Periodos];							/*Cumplimiento del l�mite de exportaci�n de la sub�rea*/
constraint Rac_Minimo[Subarea][Periodos];							/*Cumplimiento del racionamiento obligado para cada sub�rea en cada periodo*/
constraint Tipo_Racionamiento[Subarea][Periodos];						/*Tipo racionamiento para cada sub�rea en cada periodo*/
constraint Intercambio_Are[Areas][Periodos];							/*Restricci�n de la variable para almacenar el intercambio del �rea*/
constraint Limite_Imp_Area[Areas][Periodos];							/*Cumplimiento del l�mite de importaci�n de la sub�rea*/
constraint Limite_Exp_Area[Areas][Periodos];							/*Cumplimiento del l�mite de exportaci�n de la sub�rea*/
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/



/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   DECLARACI�N DE FUNCI�N OBJETIVO   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

																		/*Costo de la generaci�n calculado como Precio de oferta por la generaci�n del recurso*/
dexpr float FO_Generacion=sum(R in Recursos,t in Periodos:OfertaRecurso[R][t]>0 && t>=Pini)OfertaRecurso[R][t]*V_Gen_Rec[R][t];

																		/*Costo del racionamiento discriminado por sub�reas*/																
dexpr float FO_Racionamiento= sum(Sub in Subarea, t in Periodos: t>=Pini && TipoMod!="IDE")CostoRacSubarea[Sub][t]*V_RacSubAreaFO[Sub][t]+sum(t in Periodos: t>=Pini && TipoMod=="IDE")99999999*V_Racionamiento[t];
dexpr float FO_RacioDespacho= sum(Sub in Subarea, t in Periodos: t>=Pini && TipoMod!="IDE")CostoRacSubarea[Sub][t]*V_RacionamientoSubArea[Sub][t]+sum(t in Periodos: t>=Pini && TipoMod=="IDE")99999999*V_Racionamiento[t];

																		/*Costo del arranque de una planta t�rmica*/
dexpr float FO_ArranqueParada=sum(Rec in Rec_Termicos, t in Periodos: t>=Pini)PAP_Recurso[Rec][t]*B_Arranque[Rec][t];

																		/*Penalizaci�n de las zonas y l�mites que no se pueden cubrir*/
dexpr float FO_Zonas=700000000*sum(t in Periodos: t>=Pini)(sum(Zu in Zonas_UndMinimas)Ho_Z_UndMin[Zu][t]+sum(ZMW in Zonas_MWMinimos)Ho_Z_MWMin[ZMW][t]
																		+sum(ZMx in Zonas_MWMaximos)Ho_Z_MWMax[ZMx][t]);
																		/*Costo real del despacho econ�mico*/
dexpr float F_Despacho=FO_Generacion+FO_RacioDespacho+FO_ArranqueParada;	

								
																		/*Funci�n objetivo que se minimiza en el proceso de optmizaci�n */							
//dexpr float F_Objetivo=F_Despacho+10*FO_Racionamiento;
dexpr float F_Objetivo=FO_Generacion+FO_ArranqueParada+10*FO_Racionamiento+c_NO_Z*FO_Zonas;



/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   DEFINICI�N DEL PROBLEMA   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

minimize F_Objetivo;

subject to {
  

/*|���������������������������������������������������������������������������������RESTRICCIONES GENERALES PARA LOS RECURSOS���������������������������������������������������������������������������������|*/
	forall(t in Periodos:  t>=Pini){
		BalanceGlobal[t]:												/*Balance global, corresponde a la atenci�n de la demanda en todos los periodos*/
			if (TipoMod=="IDE"){sum(R in Recursos)V_Gen_Rec[R][t]+V_Racionamiento[t]==Demanda[t];}
  			else{sum(R in Recursos)V_Gen_Rec[R][t]+sum(Sub in Subarea)V_RacionamientoSubArea[Sub][t]==Demanda[t];}        
    }  
    
    forall(R in Recursos, t in Periodos:  t>=Pini){
																		/*Limitaci�n de la generaci�n al m�nimo valor entre la disponibilidad ofertada por cada recurso en cada periodo y el valor m�ximo
																		  ingresado por perfiles en DRP*/
		Disp_Recursos[R][t]:
		  	if (TipoMod=="PID"){V_Gen_Rec[R][t]<=Disp_Rec[R][t];}
			else{V_Gen_Rec[R][t]<=minl(Disp_Rec[R][t],MaximoRecurso[R][t]);}  
	}
	
    forall(RH in (Rec_Hidraulico union Rec_Solar union Rec_Eolico),t in Periodos: t>=Pini){
		MinTecnico_Rec[RH][t]:											/*La generaci�n del recurso debe ser mayor al m�nimo t�cnico si este se utiliza (aplica para los recursos a excepci�n de los t�rmicos)*/
			if (TipoMod=="PID"){V_Gen_Rec[RH][t]>=B_OnOff_Rec[RH][t];}
			if (TipoMod!="PID" && BanderaPruebas[RH][t]==0){V_Gen_Rec[RH][t]>=MinTecRecurso[RH]*B_OnOff_Rec[RH][t];}
	}
				
	forall(RH in (Rec_Hidraulico union Rec_Solar union Rec_Eolico),t in Periodos: t>=Pini ){
		Dispon_Rec[RH][t]:											/*La generaci�n del recurso  debe ser menor a la disponibildad si este se utiliza (aplica para los recursos a excepci�n de los t�rmicos)*/
			V_Gen_Rec[RH][t]<=Disp_Rec[RH][t]*B_OnOff_Rec[RH][t];
    }   
    
    forall (MO in MinimoRecursoObl:BanderaPruebas[MO.RECURSO][MO.PERIODO]==0 &&  TipoMod!="PID" && MO.PERIODO>=Pini){
		GenMin_Recurso[MO.RECURSO][MO.PERIODO]:							/*Generaci�n m�nima obligada ingresada por perfiles de Recurso en DRP*/
			V_Gen_Rec[MO.RECURSO][MO.PERIODO]>=minl(MO.MINIMO,Disp_Rec[MO.RECURSO][MO.PERIODO])+sum(Ragc in RecursoAGC:Ragc==MO.RECURSO && TipoMod!="IDE")AGC[Ragc][MO.PERIODO];  
    }     
    
    forall (Cin in CandidataInflex: BanderaPruebas[Cin.RECURSO][Cin.PERIODO]==0 &&  TipoMod=="IDE" && Cin.PERIODO>=Pini){
		GenInflex_Recurso[Cin.RECURSO][Cin.PERIODO]:					/*Generaci�n m�nima obligada por inflexibilidades.  SOLO APLICA PARA EL IDEAL*/			  
			V_Gen_Rec[Cin.RECURSO][Cin.PERIODO]>=minl(Cin.CANINFLEX,Disp_Rec[Cin.RECURSO][Cin.PERIODO]);
    }  
    
    forall (EF in TechoEnficc: TipoMod!="PID" && EF.PERIODO>=Pini ){
		GenEnficc_Recurso[EF.RECURSO][EF.PERIODO]:						/*Limitaci�n de la generaci�n al techo por ENFICC para los generadores que aplique*/
			V_Gen_Rec[EF.RECURSO][EF.PERIODO]<=EF.MAXIMO;  
    }     
    
	forall (R in Recursos, t in Periodos: BanderaPruebas[R][t]==1 && t>=Pini && TipoMod!="PID"){
     	Pruebas[R][t]:													/*Generaci�n de los recursos que se encuentran en pruebas*/
			V_Gen_Rec[R][t]==minl(Disp_Rec[R][t],MaximoRecurso[R][t],MaximoRecursoUnd[R][t])-sum(Ragc in RecursoAGC:Ragc==R  && TipoMod!="IDE")AGC[R][t];
    }    
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/    


/*|���������������������������������������������������������������������������������������RECURSOS CON ZONAS INFACTIBLES��������������������������������������������������������������������������������������|*/
	forall (RF in RecursosInfactibles,t in Periodos:BanderaPruebas[RF][t]==0 && t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")){
		MinValFactible[RF][t]:											/*Restricci�n auxiliar para identificar si la generaci�n est� por encima del valor m�nimo factible*/
			V_Gen_Rec[RF][t]>=sum(VF in ValoresFactibles: VF.RECURSO==RF)(VF.VALMIN*B_Ufact[VF.SEGMENTO][t]);
			
		MaxValFactible[RF][t]:											/*Restricci�n auxiliar para identificar si la generaci�n est� por debajo del valor m�ximo factible*/
			V_Gen_Rec[RF][t]<=sum(VF in ValoresFactibles: VF.RECURSO==RF)(VF.VALMAX*B_Ufact[VF.SEGMENTO][t]);
  
		Ufact_OnOff[RF][t]:												/*Relaciona el OnOff del recurso con la Ufact, si el recurso no se enciende se garantiza que ningun intervalo se encienda */
			sum(VF in ValoresFactibles: VF.RECURSO==RF)B_Ufact[VF.SEGMENTO][t]==sum(RH in (Rec_Hidraulico union Rec_Solar union Rec_Eolico): RH==RF)B_OnOff_Rec[RH][t]+sum(RT in Rec_Termicos: RT==RF)B_OnOff_RecT[RT][t];
    }  
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|����������������������������������������������������������������������������������RECURSOS CON ZONAS INFACTIBLES ESPECIALES��������������������������������������������������������������������������������|*/   
    /*Los siguientes conjuntos de restricciones se utilizan para representar el comportamiento de los recursos t�rmicos con zonas infactibles, pero que para pasar de una zona factible a otra debe pasar 
	  por una zona infactible, situaci�n que corresponde a la caracter�stica t�cnica de las ZIPAS. */    
	  
    
    /*Se definen los l�mites de cada una de las variables factible m�nima, infactible y factible m�xima, tambi�n se relacionan estos l�mites con las variables que definen la activaci�n
    de cada intervalo*/
	forall(Zi in ZonaInfact_Esp, t in Periodos:BanderaPruebas[Zi.NOMBRE][t]==0 && t>=Pini && TipoMod!="PID"){
		Infact_Esp_Inf[Zi.NOMBRE][t]:									/*L�mite inferior para la generaci�n factible m�nima, generaci�n infactible y generaci�n factible m�xima, respectivamente*/
			V_GenFirme[Zi.NOMBRE][t]>=	(sum(RCt in Conf_Tabla: RCt.RECURSO==Zi.NOMBRE && RCt.NUMERO==Conf_Prd[Zi.NOMBRE][t])MinTecRecurso_T[RCt.CONF])*B_uFact_min[Zi.NOMBRE][t]+																	
										Zi.Vmin*B_uInfact[Zi.NOMBRE][t]+(Zi.Vmax)*B_uFact_max[Zi.NOMBRE][t];
			
		Infact_Esp_Sup[Zi.NOMBRE][t]:									/*L�mite superior para la generaci�n factible m�nima, generaci�n infactible y generaci�n factible m�xima, respectivamente*/
        		V_GenFirme[Zi.NOMBRE][t]<=	(Zi.Vmin-1)*B_uFact_min[Zi.NOMBRE][t]+(Zi.Vmax-1)*B_uInfact[Zi.NOMBRE][t]+Disp_Rec[Zi.NOMBRE][t]*B_uFact_max[Zi.NOMBRE][t];	        	

	}
	
	/*Se definen las diferentes situaciones que se deben cumplir para la transici�n entre intervalos, es decir, las reglas para pasar de invervalos factibles a infactibles e interacci�n con las rampas*/
	forall(Ri in RecInfact_Esp,t in Periodos: t<Pfin && BanderaPruebas[Ri][t]==0 && t>=Pini && TipoMod!="PID"){
		Causalidad_Infact[Ri][t]:										/*Permite que la generaci�n infactible solamente se active en uno de dos periodos consecutivos*/
			B_uInfact[Ri][t]+B_uInfact[Ri][t+1]<=1;
	}
	
	forall(Ri in RecInfact_Esp,t in Periodos: BanderaPruebas[Ri][t]==0 && t>=Pini && TipoMod!="PID"){			
		Causalidad_ZonasF[Ri][t]:										/*Permite que en un mismo periodo solamente se active uno de los intervalos*/
			B_uFact_min[Ri][t]+B_uInfact[Ri][t]+B_uFact_max[Ri][t]<=1;
    	}
    
	forall(Ri in RecInfact_Esp,t in Periodos: t>Pini && t<Pfin && BanderaPruebas[Ri][t]==0  && TipoMod!="PID"){
		Causalidad_InfactibleUp[Ri][t]:									/*Si la generaci�n va subiendo, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
			B_uFact_min[Ri][t-1]+B_uInfact[Ri][t]+B_uFact_min[Ri][t+1]<=2;
			
		Causalidad_InfactibleDn[Ri][t]: 								/*Si la generaci�n va bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/ 
        		B_uFact_max[Ri][t-1]+B_uInfact[Ri][t]+B_uFact_max[Ri][t+1]<=2;
      
      		Causalidad_MT_Ginf_Rampa[Ri][t]:								/*Causalidad MT-Ginf-Rampa  para que no haga por ejemplo 31-49-16*/
      			B_uFact_min[Ri][t-1]+B_uInfact[Ri][t]<=1+B_OnOff_RecT[Ri][t+1];
      
      		Causalidad_Rampa_Ginf_MT[Ri][t]: 								/*Causalidad Rampa-Ginf-MT  para que no haga por ejemplo 16-49-31*/
      			B_uFact_min[Ri][t+1]+B_uInfact[Ri][t]<=1+B_OnOff_RecT[Ri][t-1];    	
     	}
     
	forall(Ri in RecInfact_Esp,t in Periodos: t>=Pini && t<Pfin && BanderaPruebas[Ri][t]==1  && TipoMod!="PID"){
	  	Auxiliar_uInfact_CE[Ri][t]: 									/*Restricci�n auxiliar para garantizar que en pruebas de las ZIPAS sea cero el intervalo infactible, esto es porque 
	  																	en pruebas no se aplica el modelo de infactibilidad de ZIPAS, y esta variable se utiliza en las retricciones de 
	  																	carga estable */
	  		B_uInfact[Ri][t]<=0;
 	}	  
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|����������������������������������������������������������������������RECURSOS CON ZONAS INFACTIBLES ESPECIALES EN LA CONDICI�N INICIAL��������������������������������������������������������������������|*/  
	/*Los siguientes conjuntos de restricciones se utilizan para las condiciones iniciales de los recursos t�rmicos con zonas infactibles especiales, cuya restriccion tenga acople en el tiempo */ 
	        
    forall(Zi in ZonaInfact_Esp:  BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_1[Zi.NOMBRE]<=(Zi.Vmax-1) && GenRecT_t_1[Zi.NOMBRE]>=Zi.Vmin  && TipoMod!="PID"){
		Causalidad_Infac_CI[Zi.NOMBRE]:									/*Condici�n inicial para que la generaci�n infactible solamente se active en uno de dos periodos consecutivos*/
			B_uInfact[Zi.NOMBRE][Pini]<=0;			
    }  
    
    
    forall(Zi in ZonaInfact_Esp, RC in Conf_Tabla:  BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_1[Zi.NOMBRE]>=MinTecRecurso_T[RC.CONF] && GenRecT_t_1[Zi.NOMBRE]<=(Zi.Vmin-1) &&
													RC.RECURSO==Zi.NOMBRE && RC.NUMERO==Conf_t_1[Zi.NOMBRE] && Pini<Pfin  && TipoMod!="PID")	{
		Causalidad_InfactibleUp_CI[Zi.NOMBRE]:							/*Condici�n inicial para la generaci�n subiendo, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
			B_uInfact[Zi.NOMBRE][Pini]+B_uFact_min[Zi.NOMBRE][Pini+1]<=1;
		Causalidad_MT_Ginf_Rampa_CI[Zi.NOMBRE]:							/*Condici�n inicial para la Causalidad MT-Ginf-Rampa*/
			B_uInfact[Zi.NOMBRE][Pini]<=B_OnOff_RecT[Zi.NOMBRE][Pini+1];        
    }   

    forall(Zi in ZonaInfact_Esp, RC in Conf_Tabla:  BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_2[Zi.NOMBRE]>=MinTecRecurso_T[RC.CONF] && GenRecT_t_2[Zi.NOMBRE]<=(Zi.Vmin-1) &&
    													GenRecT_t_1[Zi.NOMBRE]>=(Zi.Vmin) && GenRecT_t_1[Zi.NOMBRE]<=(Zi.Vmax-1) &&
													RC.RECURSO==Zi.NOMBRE && RC.NUMERO==Conf_t_1[Zi.NOMBRE] && Pini<Pfin  && TipoMod!="PID")	{
		Causalidad_InfactibleUp_CI_C[Zi.NOMBRE]:						/*Condici�n inicial COMPLEMENTARIA para la generaci�n subiendo, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
			B_uFact_min[Zi.NOMBRE][Pini]<=0;
		Causalidad_MT_Ginf_Rampa_CI_C[Zi.NOMBRE]:						/*Condici�n inicial COMPLEMENTARIA para la Causalidad MT-Ginf-Rampa*/
			1<=B_OnOff_RecT[Zi.NOMBRE][Pini];        
    }        
    
    forall(Zi in ZonaInfact_Esp:  BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_1[Zi.NOMBRE]>=(Zi.Vmax) && GenRecT_t_1[Zi.NOMBRE]<=Disp_Rec[Zi.NOMBRE][Pini] && Pini<Pfin && TipoMod!="PID"){
		Causalidad_InfactibleDn_CI[Zi.NOMBRE]:							/*Condici�n inicial para la generaci�n bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
			B_uInfact[Zi.NOMBRE][Pini]+B_uFact_max[Zi.NOMBRE][Pini+1]<=1;
    }   
    
    forall(Zi in ZonaInfact_Esp:  BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_2[Zi.NOMBRE]>=(Zi.Vmax) && GenRecT_t_2[Zi.NOMBRE]<=Disp_Rec[Zi.NOMBRE][Pini] && GenRecT_t_1[Zi.NOMBRE]>=(Zi.Vmin) && GenRecT_t_1[Zi.NOMBRE]<=(Zi.Vmax-1) && Pini<Pfin && TipoMod!="PID"){
		Causalidad_InfactibleDn_CI_C[Zi.NOMBRE]:						/*Condici�n inicial COMPLEMENTARIA para la generaci�n bajando, el intervalo infactible solo se permite una vez en tres periodos consecutivos*/
			B_uFact_max[Zi.NOMBRE][Pini]<=0;
    }       
	
    forall(Zi in ZonaInfact_Esp,RC in Conf_Tabla:	BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_1[Zi.NOMBRE]<=MinTecRecurso_T[RC.CONF] && (nEnt_ini[Zi.NOMBRE]>0) &&
													(Tiempo_en_Linea[Zi.NOMBRE]==0 && Tiempo_fuera_Linea[Zi.NOMBRE]==0) && RC.RECURSO==Zi.NOMBRE && RC.NUMERO==Conf_t_1[Zi.NOMBRE] && Pini<Pfin && TipoMod!="PID"){
		Causalidad_Rampa_Ginf_MT_CI[Zi.NOMBRE]:							/*Condici�n inicial para la Causalidad Rampa-Ginf-MT*/
			B_uFact_min[Zi.NOMBRE][Pini+1]+B_uInfact[Zi.NOMBRE][Pini]<=1;    
    }

    forall(Zi in ZonaInfact_Esp,RC in Conf_Tabla:	BanderaPruebas[Zi.NOMBRE][Pini]==0 && GenRecT_t_2[Zi.NOMBRE]<=MinTecRecurso_T[RC.CONF] && (nEnt_ini[Zi.NOMBRE]>0) &&
    													GenRecT_t_1[Zi.NOMBRE]>=(Zi.Vmin) && GenRecT_t_1[Zi.NOMBRE]<=(Zi.Vmax-1) &&
													(Tiempo_en_Linea[Zi.NOMBRE]==0 && Tiempo_fuera_Linea[Zi.NOMBRE]==0) && RC.RECURSO==Zi.NOMBRE && RC.NUMERO==Conf_t_1[Zi.NOMBRE] && Pini<Pfin && TipoMod!="PID"){
		Causalidad_Rampa_Ginf_MT_CI_C[Zi.NOMBRE]:						/*Condici�n inicial COMPLEMENTARIA para la Causalidad Rampa-Ginf-MT*/
			B_uFact_min[Zi.NOMBRE][Pini]<=0;    
    }    
/*|___________________________________________________________________________________________________________________________________________________________________________________________________________|*/
	
	
/*|����������������������������������������������������������������������������RESTRICCIONES GENERALES PARA LOS RECURSOS T�RMICOS����������������������������������������������������������������������������|*/		
    forall(RT in Rec_Termicos,t in Periodos: t>=Pini && TipoMod!="PID"){
      	Mod_RecTermico[RT][t]:											/*Partici�n de la generaci�n del recurso t�rmico en Generaci�n firme, rampa de entrada y rampa de salida*/	
			V_Gen_Rec[RT][t]==V_GenFirme[RT][t]+ (V_GenRampaUR[RT][t]+V_GenRampaDR[RT][t]); 
	}					      		
    
    forall(RT in Rec_Termicos,t in Periodos: t>=Pini){  		
		MinTecnico_RecT[RT][t]:											/*La generaci�n del recurso T�rmico debe ser mayor al m�nimo t�cnico si esta se utiliza*/
			if (TipoMod=="PID"){V_Gen_Rec[RT][t]>=B_OnOff_RecT[RT][t];} /*Para el preideal el m�nimo t�cnico de los recursos t�rmicos se asume 1 MW*/
			if (TipoMod!="PID" && BanderaPruebas[RT][t]==0){V_GenFirme[RT][t]>=(sum(RCt in Conf_Tabla: RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])MinTecRecurso_T[RCt.CONF])*B_OnOff_RecT[RT][t];}  			 
  	}
  	
  	forall(RT in Rec_Termicos,t in Periodos: t>=Pini){       
		Disp_RecT[RT][t]:												/*La generaci�n del recurso T�rmico debe ser menor a la disponibildad si este se utiliza*/			
			if (TipoMod=="PID"){V_Gen_Rec[RT][t]<=Disp_Rec[RT][t]*B_OnOff_RecT[RT][t];} 
			else{V_GenFirme[RT][t]<=Disp_Rec[RT][t]*B_OnOff_RecT[RT][t];}  			
    }
    
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && c_Mod1_Ent[RT]==0 && c_Mod1_Sal[RT]==1 && TipoMod!="PID" && BanderaPruebas[RT][t]==0){
		Mod1_Ent_Inactivo[RT][t]:										/*Se iguala a 0 cuando el Modelo 1 de entrada est� inactivo*/
			V_GenRampaUR[RT][t]==0;
	}	
	
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && c_Mod1_Ent[RT]==1 && c_Mod1_Sal[RT]==0 && TipoMod!="PID" && BanderaPruebas[RT][t]==0){
		Mod1_Sal_Inactivo[RT][t]:										/*Se iguala a 0 cuando el Modelo 1 de salida est� inactivo*/
			V_GenRampaDR[RT][t]==0;
	}
	
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && c_Mod1_Ent[RT]==0 && c_Mod1_Sal[RT]==0 && TipoMod!="PID" && BanderaPruebas[RT][t]==0){
		Mod1_Inactivo[RT][t]:										/*Se iguala al valor de Rampa obligado por perfiles cuando el Modelo 1 de salida est� inactivo*/
			V_GenRampaUR[RT][t]+V_GenRampaDR[RT][t]==minl(RampaObl[RT][t],Disp_Rec[RT][t]);
	}   	
    
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && TipoMod!="PID"){
		CausalRampasONOFF[RT][t]:
			B_RampaUR[RT][t]+B_RampaDR[RT][t]<=1-B_OnOff_RecT[RT][t];					/*Solo permite que se active en un periodo los bloques para subir o para bajar, cuando el ONOFF sea cero*/
		
		CausalidaRampasUR[RT][t]:										/*Garantiza que la generaci�n de rampa UR solo exista cuando el OnOff sea cero */
			if(c_Mod1_Ent[RT]==1){V_GenRampaUR[RT][t]<=9999*B_RampaUR[RT][t];} /*Si OnOff=0: Con Mod1 de Entrada inactivo, V_GenRampaUR queda libre sino se limita al MT*/
			else{V_GenRampaUR[RT][t]<=(sum(RCt in Conf_Tabla: RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])MinTecRecurso_T[RCt.CONF])*B_RampaUR[RT][t];}
			
		CausalidaRampasDR[RT][t]:										/*Garantiza que la generaci�n de rampa DR solo exista cuando el OnOff sea cero*/
			if(c_Mod1_Sal[RT]==1){V_GenRampaDR[RT][t]<=9999*B_RampaDR[RT][t];} /*Si OnOff=0: Con Mod1 de Salida inactivo, V_GenRampaUR queda libre sino se limita al MT*/
			else{V_GenRampaDR[RT][t]<=(sum(RCt in Conf_Tabla: RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])MinTecRecurso_T[RCt.CONF])*B_RampaDR[RT][t];}						
	}         
    
	forall(RT in Rec_Termicos, t in Periodos: t>Pini){
		ArranqueParada[RT][t]:											/*Relaci�n de arranque y parada para los recursos t�rmicos, se define en funci�n del OnOff*/
			B_Arranque[RT][t]-B_Parada[RT][t]==B_OnOff_RecT[RT][t]-B_OnOff_RecT[RT][t-1]; 
	}
    
	forall(RT in Rec_Termicos){
		ArranqueParada_Inicial[RT]:										/*Condici�n inicial para el arranque-parada del recurso t�rmico*/
			B_Arranque[RT][Pini]-B_Parada[RT][Pini]==B_OnOff_RecT[RT][Pini]-sum(On in 1 .. 1: Tiempo_en_Linea[RT]>0 && Tiempo_fuera_Linea[RT]==0 && TipoMod!="PID")On-sum(OnPid in 1 .. 1: GenRecT_t_1[RT]>0.1 && TipoMod=="PID" && Pini>1)OnPid; 
	} 

	forall(RT in Rec_Termicos:  c_NAR[RT]==1  && TipoMod!="PID"){
      	Numero_Arranques[RT]:											/*N�mero m�ximo de arranques permitidos para un recurso t�rmico*/
        	sum(t in Periodos: t>=Pini)(B_Arranque[RT][t])+sum(xi in 1..1:Pini>1)xi*nArr_ini[RT]<= maxl(nArranques[RT],1); 
	}  	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|�����������������������������������������������������������������������������ON_OFF Y ARRANQUES PARA LA GENERACI�N MAYOR A CERO���������������������������������������������������������������������������|*/
	forall(RT in Rec_Termicos,t in Periodos: t>=Pini  && BanderaPruebas[RT][t]==0 && TipoMod!="PID"){
		MayorQueCero[RT][t]:											/*Identifica que la generaci�n del recurso t�rmico sea mayor a cero*/
			V_Gen_Rec[RT][t]>=0.01*B_MC_On[RT][t]; 
  	}       
  	
  	forall(RT in Rec_Termicos,t in Periodos: t>=Pini && TipoMod!="PID"){
		DispMayorQueCero[RT][t]:										/*Cota superior para la activaci�n de la variable binaria que identifica que la generaci�n del recurso es mayor a cero*/
			V_Gen_Rec[RT][t]<=Disp_Rec[RT][t]*B_MC_On[RT][t];			
	}

	forall(RT in Rec_Termicos, t in Periodos: t>Pini && TipoMod!="PID"){
		ArrPar_MayorQueCero[RT][t]:										/*Relaci�n de arranque y parada para los recursos t�rmicos, con referencia a que la generaci�n del recurso sea mayor que cero*/
			B_MC_Arr[RT][t]-B_MC_Par[RT][t]==B_MC_On[RT][t]-B_MC_On[RT][t-1]; 
	}
    
	forall(RT in Rec_Termicos: TipoMod!="PID" ){
		ArrPar_MayorQueCero_CI[RT]:										/*Condici�n inicial para el arranque-parada de generaci�n mayor que cero del recurso t�rmico*/
			B_MC_Arr[RT][Pini]-B_MC_Par[RT][Pini]==B_MC_On[RT][Pini]-sum(ui in 1..1: GenRecT_t_1[RT]>0.0001)ui;  
	}	  
	
	/*Cuando existen bloques de salida en la condici�n inicial, es necesario relacionar la parada respecto al m�nimo t�cnico y la parada respecto a la generaci�n mayor a cero.  Esto solo es indispensable
	  en la condici�n inicial ya que en el resto de periodos se cumple naturalmente con la formulaci�n*/
	forall(RT in Rec_Termicos, RCts in Conf_Tabla: 	nSal_ini_Nor[RT]>0 && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0 &&
													nSegmentoSalida[RCts.CONF]-nSal_ini_Nor[RT]>=0 &&
													RCts.RECURSO==RT && RCts.NUMERO==Conf_Salida[RT] && TipoMod!="PID"){	
		Parada__DN_CI[RT]:												/*Parada obligada seg�n los bloques de salida normal en la condici�n inicial, respecto la generaci�n mayor a cero*/
		  		B_MC_Par[RT][Pini-nSal_ini_Nor[RT]+nSegmentoSalida[RCts.CONF]]==1;
	}						   			
		
	forall(RT in Rec_Termicos, RCts in Conf_Tabla: 	nSal_ini_Esp[RT]>0 && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0 &&
													1-nSal_ini_Esp[RT]>=0 &&  /*Se asume que todos los generadores tienen solo un bloque especial*/
													RCts.RECURSO==RT && RCts.NUMERO==Conf_Salida[RT] && TipoMod!="PID"){	
		Parada__DNE_CI[RT]:												/*Parada obligada seg�n los bloques de salida especial en la condici�n inicial, respecto la generaci�n mayor a cero*/
		  		B_MC_Par[RT][Pini-nSal_ini_Esp[RT]+1]==1;
	}	

/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

	
/*|��������������������������������������������������������������������������RESTRICCIONES M�NIMO TIEMPO EN L�NEA Y FUERA DE L�NEA���������������������������������������������������������������������������|*/    
	forall(RT in Rec_Termicos:Tiempo_en_Linea[RT]>0 && (Min_Tiempo_en_Linea[RT]-Tiempo_en_Linea[RT])>0 && c_TL[RT]==1 && TipoMod!="PID"){
		TiempoMinLinea_Pend[RT]:										/*Tiempo m�nimo en l�nea que debe quedar el recurso seg�n la condici�n inicial*/
			sum(t in Periodos: t>=Pini && t<=minl(Pfin,Min_Tiempo_en_Linea[RT]-Tiempo_en_Linea[RT]+Pini-1))B_OnOff_RecT[RT][t]
			>=minl(Pfin-Pini+1,Min_Tiempo_en_Linea[RT]-Tiempo_en_Linea[RT]); 
	}
	
	forall(RT in Rec_Termicos,t in Periodos: t>=Pini && c_TL[RT]==1 && TipoMod!="PID"){
		TiempoMinimoLinea[RT][t]:										/*Tiempo m�nimo en l�nea que debe quedar el recurso seg�n el arranque*/
			sum(Pr in t.. minl(Pfin,Min_Tiempo_en_Linea[RT]+t-1)) B_OnOff_RecT[RT][Pr]
			>=B_Arranque[RT][t]*minl(Pfin-t+1,Min_Tiempo_en_Linea[RT]);    
	}   
  	
	forall(RT in Rec_Termicos:Tiempo_fuera_Linea[RT]>0 && (Min_Tiempo_fuera_Linea[RT]-Tiempo_fuera_Linea[RT]>0) && c_TFL[RT]==1 && TipoMod!="PID"){
		TiempoMinFLinea_Pend[RT]:										/*Tiempo m�nimo fuera de l�nea que debe quedar el recurso seg�n la condici�n inicial*/
			sum(t in Periodos:t>=Pini && t<=minl(Pfin,Min_Tiempo_fuera_Linea[RT]-Tiempo_fuera_Linea[RT]+Pini-1))
				V_Gen_Rec[RT][t]<=0;
	}   
			
	forall(RT in Rec_Termicos, t in Periodos: 	t>=Pini && c_TFL[RT]==1 && TipoMod!="PID"){	
		TiempoMinimoFLinea[RT][t]:										/*Tiempo m�nimo fuera de l�nea que debe quedar el recurso seg�n la parada (Respecto la generaci�n mayor a cero)*/
		  	sum(iFL in 1 .. Min_Tiempo_fuera_Linea[RT]: t+iFL-1<=Pfin)V_Gen_Rec[RT][t+iFL-1]<=999999*(1-B_MC_Par[RT][t]);
	}						
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/
	
	
/*|�������������������������������������������������������������������������������������������ARRANQUES POR ESTADO�������������������������������������������������������������������������������������������|*/
 	/*Este conjunto de restricciones son las que definen los arranques por estado, la primera tiene que ver con la partici�n de la variable de arranque en tres,
  	las otras utilizan el tiempo para definir si es caliente, tibio o frio en funci�n de la parada del recurso y el n�mero de segmentos de entrada y salida,
  	el �ltimo conjunto se utiliza para los primeros arranques, es decir para los recursos que est�n fuera de l�nea.  */
  	
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && TipoMod!="PID"){
		Tipos_Arranque[RT][t]:											/*Partici�n de variable de arranque en tres: caliente, tibio, frio*/
			B_Arranque[RT][t]==B_Arr_Caliente[RT][t]+B_Arr_Tibio[RT][t]+B_Arr_Frio[RT][t];

		Tipos_Arranque_MC[RT][t]:										/*Partici�n de variable de arranque en tres: caliente, tibio, frio.  (Respecto la generaci�n mayor a cero)*/
			B_MC_Arr[RT][t]==B_MC_Arr_Caliente[RT][t]+B_MC_Arr_Tibio[RT][t]+B_MC_Arr_Frio[RT][t];			
	}				
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*|���������������������������������������������������������������������������������������ARRANQUES POR ESTADO: CALIENTE�������������������������������������������������������������������������������������|*/
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && TipoMod!="PID"){		
		Arranque_Caliente[RT][t]:										/*Condiciones para que el arranque del recurso t�rmico sea en caliente*/
			B_MC_Arr_Caliente[RT][t]<=sum(ti in 1 .. t, RCt in Conf_Tabla:	ti<=TiempoCaliente[RCt.CONF] && t-ti>=Pini && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])
																			B_MC_Par[RT][t-ti]		/*Arranque caliente en funci�n de la parada (Respecto la Generaci�n Mayor a Cero) del recurso*/        
																							+
									  sum(xi in 1..1, RCt in Conf_Tabla:	Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]>0 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] &&
																			(t-Pini+Tiempo_fuera_Linea[RT])<=TiempoCaliente[RCt.CONF])
																			xi;						/*Techo para el arranque de los recursos fuera de l�nea en la condici�n inicial*/	

		Relacion_Arr_Caliente[RT][t]:									/*Relacion de los arranques de generaci�n en firme y generaci�n mayor que cero para el estado caliente*/
			B_MC_Arr_Caliente[RT][t]==sum(nc in 0 .. Nmax, RCt in Conf_Tabla: 	RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t+nc] 
																				&& t+nc>=Pini && t+nc<=Pfin && nSegmentosCaliente[RCt.CONF]==nc)
																				B_Arr_Caliente[RT][t+nc]*(c_Mod1_Ent[RT])+B_MC_Arr_Caliente[RT][t]*(1-c_Mod1_Ent[RT]);
	}	

	forall (RT in Rec_Termicos, RCe in Conf_Tabla: 	nEnt_ini_Cal[RT]>0 && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0 && RCe.RECURSO==RT && RCe.NUMERO==Conf_Entrada[RT] 
													&& nSegmentosCaliente[RCe.CONF]-nEnt_ini_Cal[RT]>=0 && c_Mod1_Ent[RT]==1 && TipoMod!="PID"){
	  	Arr_Caliente_Ini[RT]:											/*Arranque obligado debido a que se tienen bloques de entrada en caliente pendientes*/
			B_Arr_Caliente[RT][nSegmentosCaliente[RCe.CONF]-nEnt_ini_Cal[RT]+Pini]==1;				  			  	  	  	  	
	}		

	forall(RT in Rec_Termicos,t in Periodos, RCt in Conf_Tabla: 	t>=Pini && c_Mod1_Ent[RT]==1 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && BanderaPruebas[RT][t]==0 && TipoMod!="PID" &&
    																Tiempo_en_Linea[RT]==0 && (Tiempo_fuera_Linea[RT]>0 || nEnt_ini_Cal[RT]>0) && t<=Pini-1+(nSegmentosCaliente[RCt.CONF]-nEnt_ini_Cal[RT])){
		TechoArrIniCaliente[RT][t]:									/*Techo para el arranque inicial caliente seg�n el modelo 1*/
			B_Arr_Caliente[RT][t]==0;
    } 																									
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/																																										

/*|�����������������������������������������������������������������������������������������ARRANQUES POR ESTADO: TIBIO��������������������������������������������������������������������������������������|*/		
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && TipoMod!="PID"){				
		Arranque_Tibio[RT][t]:											/*Condiciones para que el arranque del recurso t�rmico sea en tibio*/
			B_MC_Arr_Tibio[RT][t]<=	sum(ti in 1 .. t, RCt in Conf_Tabla:	ti>TiempoCaliente[RCt.CONF] && ti<=TiempoTibio[RCt.CONF]  && t-ti>=Pini &&
																			RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])
																			B_MC_Par[RT][t-ti]  	/*Arranque tibio en funci�n de la parada (Respecto la Generaci�n Mayor a Cero) del recurso*/
																							+	       		
									sum(xi in 1..1, RCt in Conf_Tabla:		Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]>0 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && 
																			(t-Pini+Tiempo_fuera_Linea[RT])>TiempoCaliente[RCt.CONF] && 
																			(t-Pini+Tiempo_fuera_Linea[RT])<=TiempoTibio[RCt.CONF])
																			xi;	 					/*Techo para el arranque de los recursos fuera de l�nea en la condici�n inicial*/
																											
	
		Relacion_Arr_Tibio[RT][t]:										/*Relacion de los arranques de generaci�n en firme y generaci�n mayor que cero para el estado tibio*/
			B_MC_Arr_Tibio[RT][t]==sum(nc in 0 .. Nmax, RCt in Conf_Tabla: 	RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t+nc] 
																			&& t+nc>=Pini && t+nc<=Pfin && nSegmentosTibio[RCt.CONF]==nc)
																			B_Arr_Tibio[RT][t+nc]*(c_Mod1_Ent[RT])+B_MC_Arr_Tibio[RT][t]*(1-c_Mod1_Ent[RT]);																		
	}		
	
	forall (RT in Rec_Termicos,RCe in Conf_Tabla: 	nEnt_ini_Tib[RT]>0 && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0 && RCe.RECURSO==RT && RCe.NUMERO==Conf_Entrada[RT]
													&& nSegmentosTibio[RCe.CONF]-nEnt_ini_Tib[RT]>=0  && c_Mod1_Ent[RT]==1 && TipoMod!="PID"){
	  	Arr_Tibio_Ini[RT]:												/*Arranque obligado debido a que se tienen bloques de entrada en tibio pendientes*/
			B_Arr_Tibio[RT][nSegmentosTibio[RCe.CONF]-nEnt_ini_Tib[RT]+Pini]==1;				  			  	  	  	  	
	}	

    forall(RT in Rec_Termicos,t in Periodos, RCt in Conf_Tabla: 	t>=Pini && c_Mod1_Ent[RT]==1 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && BanderaPruebas[RT][t]==0 && TipoMod!="PID" && 
    																Tiempo_en_Linea[RT]==0 && (Tiempo_fuera_Linea[RT]>0 || nEnt_ini_Tib[RT]>0) && t<=Pini-1+(nSegmentosTibio[RCt.CONF]-nEnt_ini_Tib[RT]) ){
		TechoArrIniTibio[RT][t]:										/*Techo para el arranque inicial tibio seg�n el modelo 1*/
			B_Arr_Tibio[RT][t]==0;
    } 																		
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/																																	

/*|�����������������������������������������������������������������������������������������ARRANQUES POR ESTADO: FRIO���������������������������������������������������������������������������������������|*/	
	forall(RT in Rec_Termicos, t in Periodos: t>=Pini && TipoMod!="PID"){		
		Arranque_Frio[RT][t]:											/*Condiciones para que el arranque del recurso t�rmico sea en frio*/
			B_MC_Arr_Frio[RT][t]<=	sum(ti in 1 .. t, RCt in Conf_Tabla:	ti>TiempoTibio[RCt.CONF] && t-ti>=Pini &&
																			RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])
																			B_MC_Par[RT][t-ti]  	/*Arranque frio en funci�n de la parada del recurso*/
																							+
									sum(xi in 1..1, RCt in Conf_Tabla:		Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]>0 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && 
								   											(t-Pini+Tiempo_fuera_Linea[RT])>TiempoTibio[RCt.CONF])
								   											xi; 					/*Techo para el arranque de los recursos fuera de l�nea en la condici�n inicial*/
								   	
																		
		Relacion_Arr_Frio[RT][t]:										/*Relacion de los arranques de generaci�n en firme y generaci�n mayor que cero para el estado frio*/
			B_MC_Arr_Frio[RT][t]==sum(nc in 0 .. Nmax, RCt in Conf_Tabla: 	RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t+nc] 
																			&& t+nc>=Pini && t+nc<=Pfin && nSegmentosFrio[RCt.CONF]==nc)
																			B_Arr_Frio[RT][t+nc]*(c_Mod1_Ent[RT])+B_MC_Arr_Frio[RT][t]*(1-c_Mod1_Ent[RT]);		
	} 	
	
	forall (RT in Rec_Termicos,RCe in Conf_Tabla: 	nEnt_ini_Fri[RT]>0 && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0 && RCe.RECURSO==RT && RCe.NUMERO==Conf_Entrada[RT]
													&& nSegmentosFrio[RCe.CONF]-nEnt_ini_Fri[RT]>=0  && c_Mod1_Ent[RT]==1 && TipoMod!="PID"){
	  	Arr_Frio_Ini[RT]:												/*Arranque obligado debido a que se tienen bloques de entrada en frio pendientes*/
			B_Arr_Frio[RT][nSegmentosFrio[RCe.CONF]-nEnt_ini_Fri[RT]+Pini]==1;				  			  	  	  	  	
	}		
	
 	forall(RT in Rec_Termicos,t in Periodos, RCt in Conf_Tabla: 	t>=Pini && c_Mod1_Ent[RT]==1 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && BanderaPruebas[RT][t]==0 && TipoMod!="PID" && 
    																Tiempo_en_Linea[RT]==0 && (Tiempo_fuera_Linea[RT]>0 || nEnt_ini_Fri[RT]>0) && t<=Pini-1+(nSegmentosFrio[RCt.CONF]-nEnt_ini_Fri[RT])){
		TechoArrIniFrio[RT][t]:											/*Techo para el arranque inicial frio seg�n el modelo 1*/
			B_Arr_Frio[RT][t]==0;
    }   	 	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/     

	
/*|��������������������������������������������������������������������������������TIEMPO DE AVISO SEG�N PERIODO DE PUBLICACI�N������������������������������������������������������������������������������|*/
	forall (RT in Rec_Termicos, t in Periodos, TAV in Tiempo_Aviso_Calentamiento,  RCt in Conf_Tabla:	RCt.RECURSO==RT && RCt.CONF==TAV.CONF && RCt.NUMERO==Conf_Prd[RT][t]
																										&& t<=(TAV.TACALIENTE+Publicacion[RT]+1) &&  c_TA[RT]==1 && (TipoMod=="DPC" || TipoMod=="RDP") &&
																										Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]>0 && BanderaPruebas[RT][t]==0 && t>=Pini){
		Techo_TiempoAviso_Caliente[RT][t]:								/*Techo correspondiente al tiempo de aviso en caliente*/
			B_MC_Arr_Caliente[RT][t]==0;	  	
	}		
	
	forall (RT in Rec_Termicos, t in Periodos, TAV in Tiempo_Aviso_Calentamiento,  RCt in Conf_Tabla:	RCt.RECURSO==RT && RCt.CONF==TAV.CONF && RCt.NUMERO==Conf_Prd[RT][t]																										
																										&& t<=(TAV.TATIBIO+Publicacion[RT]+1) &&  c_TA[RT]==1 && (TipoMod=="DPC" || TipoMod=="RDP") &&
																										Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]>0 && BanderaPruebas[RT][t]==0 && t>=Pini){
		Techo_TiempoAviso_Tibio[RT][t]:									/*Techo correspondiente al tiempo de aviso en tibio*/
		  	B_MC_Arr_Tibio[RT][t]==0;	  	
	}

	forall (RT in Rec_Termicos, t in Periodos, TAV in Tiempo_Aviso_Calentamiento,  RCt in Conf_Tabla:	RCt.RECURSO==RT && RCt.CONF==TAV.CONF && RCt.NUMERO==Conf_Prd[RT][t]																										
																										&& t<=(TAV.TAFRIO+Publicacion[RT]+1) &&  c_TA[RT]==1 && (TipoMod=="DPC" || TipoMod=="RDP") &&
																										Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]>0 && BanderaPruebas[RT][t]==0 && t>=Pini){
		Techo_TiempoAviso_Frio[RT][t]:									/*Techo correspondiente al tiempo de aviso en frio*/
		  	B_MC_Arr_Frio[RT][t]==0;
	}		
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������������������TIEMPO DE CALENTAMIENTO�����������������������������������������������������������������������������������������|*/

	forall (RT in Rec_Termicos, t in Periodos, TCA in Tiempo_Aviso_Calentamiento,  RCt in Conf_Tabla:	RCt.RECURSO==RT && RCt.CONF==TCA.CONF && RCt.NUMERO==Conf_Prd[RT][t] && 
																										BanderaPruebas[RT][t]==0 && t>=Pini && c_TC[RT]==1 && (TipoMod=="DPC" || TipoMod=="RDP")){
		Techo_TCalentamiento_Caliente[RT][t]:							/*Techo correspondiente al tiempo de calentamiento en Caliente*/
			B_MC_Arr_Caliente[RT][t]*(TCA.TCCALIENTE)<=
							sum(ti in 1..(TCA.TCCALIENTE): t-ti>=Pini)Bandera_Disp[RT][t-ti]+
							minl(maxl(0,(TCA.TCCALIENTE)+Pini-t),maxl(0,TDispPini_1[RT])); 	/*Este t�rmino representa la suma restante cuando ti>=Prd*/

		Techo_TCalentamiento_Tibio[RT][t]:								/*Techo correspondiente al tiempo de calentamiento en Tibio*/
		  	B_MC_Arr_Tibio[RT][t]*(TCA.TCTIBIO)<=
							sum(ti in 1..(TCA.TCTIBIO): t-ti>=Pini)Bandera_Disp[RT][t-ti]+
							minl(maxl(0,(TCA.TCTIBIO)+Pini-t),maxl(0,TDispPini_1[RT])); 	/*Este t�rmino representa la suma restante cuando ti>=Prd*/

		Techo_TCalentamiento_Frio[RT][t]:								/*Techo correspondiente al tiempo de calentamiento en Frio*/
		  	B_MC_Arr_Frio[RT][t]*(TCA.TCFRIO)<=
							sum(ti in 1..(TCA.TCFRIO): t-ti>=Pini)Bandera_Disp[RT][t-ti]+
							minl(maxl(0,(TCA.TCFRIO)+Pini-t),maxl(0,TDispPini_1[RT])); 		/*Este t�rmino representa la suma restante cuando ti>=Prd*/											
	}	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

	
/*|���������������������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 1�������������������������������������������������������������������������������������|*/

/*La estrategia de modelado para esta restricci�n se puede entender con la siguiente tabla, como :
	P01		P02		P03		P04		P05		...		P24
	B1		B2		Ar
			B1		B2		Ar
					B1		B2		Ar

Por ejemplo para el periodo 3 se tiene que la generaci�n de rampa de entrada correspondiente es B2 si el arranque es en el periodo 4 o B1 si el arranque es el periodo 5, debido a que la variable arranque es
binaria, esta relaci�n l�gica se pude expresar con la siguiente suma:
  
  V_GenRampaUR(3)=Ar(4)*B2+Ar(5)*B1*/
	
/*SE HACE UNA MODIFICACI�N  EN EL MODELO 1 PARA QUE NO HAGA RAMPAS DE ENTRADA NI SALIDA CUANDO EN EL PERIODO EST� EN PRUEBAS Y LA DISPONIBILIDAD ES CERO CON EL T�RMINO (1-sum(NObup in 1..1: BanderaPruebas[RT][t+ti]==1 && Disp_Rec[RT][t+ti]==0)NObup*/
	forall (RT in Rec_Termicos,t in Periodos: t>=Pini && c_Mod1_Ent[RT]==1 && TipoMod!="PID"){
		Modelo1_Entrada[RT][t]:											/*Descripci�n del modelo 1 para rampas de entrada caliente, tibio y frio*/
			V_GenRampaUR[RT][t]==	sum(ti in 1..Nmax, RCti in Conf_Tabla: 	t+ti>Pini+(nSegmentosCaliente[RCti.CONF]-nEnt_ini_Cal[RT])-1 && t+ti<=Pfin && nSegmentosCaliente[RCti.CONF]-ti+1>0 &&
																			RCti.RECURSO==RT && RCti.NUMERO==Conf_Prd[RT][t+ti])
																			B_Arr_Caliente[RT][t+ti]*SegRampas_Caliente[RCti.CONF][nSegmentosCaliente[RCti.CONF]-ti+1]*(1-sum(NObup in 1..1: BanderaPruebas[RT][t+ti]==1 && Disp_Rec[RT][t+ti]==0)NObup)
																		+
								  	sum(ti in 1..Nmax, RCti in Conf_Tabla: 	t+ti>Pini+(nSegmentosTibio[RCti.CONF]-nEnt_ini_Tib[RT])-1 && t+ti<=Pfin && nSegmentosTibio[RCti.CONF]-ti+1>0 && 
								  											RCti.RECURSO==RT && RCti.NUMERO==Conf_Prd[RT][t+ti])
																			B_Arr_Tibio[RT][t+ti]*SegRampas_Tibio[RCti.CONF][nSegmentosTibio[RCti.CONF]-ti+1]*(1-sum(NObup in 1..1: BanderaPruebas[RT][t+ti]==1 && Disp_Rec[RT][t+ti]==0)NObup)		
																		+
								  	sum(ti in 1..Nmax, RCti in Conf_Tabla: 	t+ti>Pini+(nSegmentosFrio[RCti.CONF]-nEnt_ini_Fri[RT])-1 && t+ti<=Pfin && nSegmentosFrio[RCti.CONF]-ti+1>0 && 
								  											RCti.RECURSO==RT && RCti.NUMERO==Conf_Prd[RT][t+ti])
																			B_Arr_Frio[RT][t+ti]*SegRampas_Frio[RCti.CONF][nSegmentosFrio[RCti.CONF]-ti+1]*(1-sum(NObup in 1..1: BanderaPruebas[RT][t+ti]==1 && Disp_Rec[RT][t+ti]==0)NObup);		
	}
	
	 
	
	forall (RT in Rec_Termicos,t in Periodos: t>=Pini && c_Mod1_Sal[RT]==1 && TipoMod!="PID"){	
		Modelo1_Salida[RT][t]:											/*Descripci�n del modelo 1 para rampas de salida:  La primera parte de la suma corresponde a una salida normal y aplica para periodos
																		  mayores a Pini, la segunda es necesaria para el periodo Pini pues se necesita que la configuraci�n sea de Pini-1 para salir, la
																		  tercera corresponde a la condici�n inicial si se llevan ya bloques de salida ejecutados y la cuarta corresponde a la salida especial*/
        	V_GenRampaDR[RT][t]==	sum(ti in 1..Nmax, RCti in Conf_Tabla:	RCti.RECURSO==RT && (RCti.NUMERO==Conf_Prd[RT][t-ti]) && t-ti+1>Pini)SegRampas_Salida[RCti.CONF][ti]*B_Par_Normal[RT][t-ti+1]*(1-sum(NObdn in 1..1: BanderaPruebas[RT][t-ti]==1 && Disp_Rec[RT][t-ti]==0)NObdn)
        							+sum(ti in 1..Nmax, RCti in Conf_Tabla:	RCti.RECURSO==RT && (RCti.NUMERO==Conf_t_1[RT]) && t-ti+1==Pini)SegRampas_Salida[RCti.CONF][ti]*B_Par_Normal[RT][t-ti+1]*(1-sum(NObdn in 1..1: BanderaPruebas[RT][t-ti+1]==1 && Disp_Rec[RT][t-ti+1]==0)NObdn)  
        							+sum(ti in 1..Nmax, RCti in Conf_Tabla:	RCti.RECURSO==RT && (RCti.NUMERO==Conf_Salida[RT]) && t-ti+1<Pini && 
        																	nSal_ini[RT]>0 && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0)
        																	(SegRampas_Salida[RCti.CONF][ti]*sum(Pri in 1..1:ti-nSal_ini[RT]==t-Pini+1)Pri)    							
            	                 	+sum(Be in RampasSalida_Esp, RCt1 in Conf_Tabla: RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && RCt1.CONF==Be.CONF && t>Pini)Be.BLOQUEOESP*B_Par_Especial[RT][t]*(1-sum(NObdn in 1..1: BanderaPruebas[RT][t-1]==1 && Disp_Rec[RT][t-1]==0)NObdn)
            	                 	+sum(Be in RampasSalida_Esp, RCt1 in Conf_Tabla: RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && RCt1.CONF==Be.CONF && t==Pini)Be.BLOQUEOESP*B_Par_Especial[RT][Pini]*(1-sum(NObdn in 1..1: BanderaPruebas[RT][Pini]==1 && Disp_Rec[RT][Pini]==0)NObdn);

	}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|���������������������������������������������������������������������������������RESTRICCIONES DE SALIDA ESPECIAL Y NORMAL��������������������������������������������������������������������������������|*/	
	forall (RT in Rec_Termicos,t in Periodos: t>=Pini && TipoMod!="PID"){	
		BloqueNormal_Especial[RT][t]:									/*Partici�n de la variable Parada en Bloque especial o Bloque normal*/
			B_Par_Normal[RT][t]+sum(Be in RampasSalida_Esp, RCt in Conf_Tabla: RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && RCt.CONF==Be.CONF)B_Par_Especial[RT][t]==B_Parada[RT][t];	
	} 	
	
	forall (RT in Rec_Termicos,t in Periodos,RCt1 in Conf_Tabla: t>Pini &&  RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && TipoMod!="PID"){	
		Bloque_Especial_Cero[RT][t]:									/*Se garantiza que los recursos que no tienen salida especial tengan esta variable como cero*/
			B_Par_Especial[RT][t]<=sum(xe in 1..1, RSe in RampasSalida_Esp: RCt1.CONF==RSe.CONF)xe;	
	} 
	
	forall (RT in Rec_Termicos,RCt1 in Conf_Tabla: RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && TipoMod!="PID"){	
		Bloque_Especial_Cero_CI[RT]:									/*Se garantiza que los recursos que no tienen salida especial tengan esta variable como cero en la condici�n inicial*/
			B_Par_Especial[RT][Pini]<=sum(xe in 1..1, RSe in RampasSalida_Esp: RCt1.CONF==RSe.CONF)xe;
	} 

	forall(RTe in Rec_Salida_Esp, t in Periodos: t>Pini && TipoMod!="PID"){
		Activ_Bloque_Esp[RTe][t]:										/*Activaci�n del bloque de salida especial*/	
			V_GenFirme[RTe][t-1]>=(sum(RCt in Conf_Tabla: RCt.RECURSO==RTe && RCt.NUMERO==Conf_Prd[RTe][t-1])MinTecRecurso_T[RCt.CONF]+1)*B_Par_Especial[RTe][t];
	}
	
	forall(RTe in Rec_Salida_Esp: TipoMod!="PID"){
		Activ_Bloque_Esp_CI[RTe]:										/*Activaci�n del bloque de salida especial en la condici�n inicial*/	
			GenRecT_t_1[RTe]>=(sum(RCt in Conf_Tabla: RCt.RECURSO==RTe && RCt.NUMERO==Conf_t_1[RTe])MinTecRecurso_T[RCt.CONF]+1)*B_Par_Especial[RTe][Pini];
	}	
	
	forall(t in Periodos: t>Pini && TipoMod!="PID"){
		Activ_Blq_Esp_TEMCALI[t]:										/*Activaci�n del bloque de salida especial para TEMCALI*/	
			V_GenFirme["TEMCALI"][t-1]>=(Disp_Rec["TEMCALI"][t-1])*B_Par_Especial["TEMCALI"][t];
	}

	forall(Pi in Pini .. Pini: TipoMod!="PID"){
		Activ_Blq_Esp_TEMCALI_CI[Pi]:									/*Activaci�n del bloque de salida especial en la condici�n inicial para TEMCALI*/	
			GenRecT_t_1["TEMCALI"]>=(Disp_t_1["TEMCALI"])*B_Par_Especial["TEMCALI"][Pini];
	}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 


/*|���������������������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 2�������������������������������������������������������������������������������������|*/
	forall(RT in RT_Mod2,t in Periodos, RCt1 in Conf_Tabla: t>Pini && BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && c_Mod23[RT][t]==1 && TipoMod!="PID"){
		UR_DR_Vmin[RT][t]:												/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar*/
			V_GenFirme[RT][t-1]>=sum(Su in Interv_Mod2_UR: Su.CONF==RCt1.CONF)Su.VALMIN*B_UR[Su.INTERVALO][t]
								+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt1.CONF)Sd.VALMIN*B_DR[Sd.INTERVALO][t]-9999*(1-B_OnOff_RecT[RT][t])-9999*(B_Arranque[RT][t]); 
																																					
		UR_DR_Vmax[RT][t]:												/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar*/
			V_GenFirme[RT][t-1]<=sum(Su in Interv_Mod2_UR: Su.CONF==RCt1.CONF)Su.VALMAX*B_UR[Su.INTERVALO][t]
								+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt1.CONF)Sd.VALMAX*B_DR[Sd.INTERVALO][t]+9999*(B_Arranque[RT][t]);
		
		UR_MaxVar[RT][t]:												/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active*/					
			V_GenFirme[RT][t]-V_GenFirme[RT][t-1]<=
        						sum(Su in Interv_Mod2_UR: Su.CONF==RCt1.CONF)Su.URMAX*B_UR[Su.INTERVALO][t]+9999*(B_Arranque[RT][t]);
		
		DR_MaxVar[RT][t]:												/*L�mita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active*/
	        V_GenFirme[RT][t-1]-V_GenFirme[RT][t]-V_GenRampaDR[RT][t]<=
	        					sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt1.CONF)Sd.DRMAX*B_DR[Sd.INTERVALO][t]
	       						+sum(RTe in Rec_Salida_Esp: RTe==RT)9999*B_Par_Especial[RT][t];        
	}
	
	forall(RT in RT_Mod2,t in Periodos: t>Pini && TipoMod!="PID"){		
		UR_DR_Causal[RT][t]:											/*Verifica que solo se active uno de los intervalos ya sea para subir o bajar en un periodo*/
        	sum(Su in Interv_Mod2_UR, RCt1 in Conf_Tabla: Su.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_Prd[RT][t-1] || RCt1.NUMERO==Conf_Prd[RT][t]))B_UR[Su.INTERVALO][t]
       		+sum(Sd in Interv_Mod2_DR, RCt1 in Conf_Tabla: Sd.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_Prd[RT][t-1] || RCt1.NUMERO==Conf_Prd[RT][t]))B_DR[Sd.INTERVALO][t]<=1;	       		
  	}    
  	    		
	/*El siguiente conjunto de restricciones corresponde a la frontera Mod1 en (t-1)-Mod2 en (t), la m�xima variaci�n se realiza con la configuraci�n de (t). Se valida que el recurso tenga Mod1*/    

	forall(RT in RT_Mod2,t in Periodos, RCt in Conf_Tabla: t>Pini && BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && c_Mod23[RT][t]==1 && TipoMod!="PID"){
		UR_DR_Vmin_Frt[RT][t]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2*/
			V_GenRampaUR[RT][t-1]>=	sum(Su in Interv_Mod2_UR: Su.CONF==RCt.CONF)Su.VALMIN*B_UR[Su.INTERVALO][t]
									+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt.CONF)Sd.VALMIN*B_DR[Sd.INTERVALO][t]
									-9999*((1-B_Arranque[RT][t])+(1-c_Mod1_Ent[RT]));
						
		UR_DR_Vmax_Frt[RT][t]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2*/
			V_GenRampaUR[RT][t-1]<=	sum(Su in Interv_Mod2_UR: Su.CONF==RCt.CONF)Su.VALMAX*B_UR[Su.INTERVALO][t]
									+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt.CONF)Sd.VALMAX*B_DR[Sd.INTERVALO][t]
									+9999*((1-B_Arranque[RT][t])+(1-c_Mod1_Ent[RT]));	

		UR_MaxVar_Frt[RT][t]:											/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la frontera Mod1-Mod2*/					
			V_GenFirme[RT][t]-V_GenRampaUR[RT][t-1]<=
        							sum(Su in Interv_Mod2_UR: Su.CONF==RCt.CONF)Su.URMAX*B_UR[Su.INTERVALO][t]
        							+9999*((1-B_Arranque[RT][t])+(1-c_Mod1_Ent[RT]));/*Se deja de cumplir la restricci�n si el modelo 1 de entrada est� inactivo*/							
	}   
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|���������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 2 EN LA CONDICI�N INICIAL�������������������������������������������������������������������������|*/
	forall(RT in RT_Mod2, RCt1 in Conf_Tabla: 	nSal_ini[RT]<=0 && nEnt_ini[RT]<=0 && (Tiempo_en_Linea[RT]>0 || Tiempo_fuera_Linea[RT]>0) && 
												BanderaPruebas[RT][Pini]==0 && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && c_Mod23[RT][Pini]==1 && TipoMod!="PID"){
		UR_DR_Vmin_CI[RT]:												/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la condici�n inicial*/
			GenRecT_t_1[RT]>=sum(Su in Interv_Mod2_UR: Su.CONF==RCt1.CONF)Su.VALMIN*B_UR[Su.INTERVALO][Pini]
							+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt1.CONF)Sd.VALMIN*B_DR[Sd.INTERVALO][Pini]-9999*(1-B_OnOff_RecT[RT][Pini])-9999*(B_Arranque[RT][Pini]); 
																																					
		UR_DR_Vmax_CI[RT]:												/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la condici�n inicial*/
			GenRecT_t_1[RT]<=sum(Su in Interv_Mod2_UR: Su.CONF==RCt1.CONF)Su.VALMAX*B_UR[Su.INTERVALO][Pini]
							+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt1.CONF)Sd.VALMAX*B_DR[Sd.INTERVALO][Pini];
		
		UR_MaxVar_CI[RT]:												/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la condici�n inicial*/					
			V_GenFirme[RT][Pini]-GenRecT_t_1[RT]<=
        					sum(Su in Interv_Mod2_UR: Su.CONF==RCt1.CONF)Su.URMAX*B_UR[Su.INTERVALO][Pini];		
		
		DR_MaxVar_CI[RT]:												/*L�mita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active en la condici�n inicial*/
	        GenRecT_t_1[RT]-V_GenFirme[RT][Pini]-V_GenRampaDR[RT][Pini]<=
	        sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt1.CONF)Sd.DRMAX*B_DR[Sd.INTERVALO][Pini]
	       +sum(RTe in Rec_Salida_Esp: RTe==RT)9999*B_Par_Especial[RT][Pini];              					
	}

	forall(RT in RT_Mod2, RCt in Conf_Tabla:	((nEnt_ini[RT]>0  && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0) || GenRecT_t_1[RT]<0.00001) && BanderaPruebas[RT][Pini]==0 &&
	  											RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][Pini] && c_Mod23[RT][Pini]==1 && TipoMod!="PID"){
		UR_DR_Vmin_Frt_CI[RT]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2 en la condici�n inicial*/
			GenRecT_t_1[RT]>=sum(Su in Interv_Mod2_UR: Su.CONF==RCt.CONF)Su.VALMIN*B_UR[Su.INTERVALO][Pini]
							+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt.CONF)Sd.VALMIN*B_DR[Sd.INTERVALO][Pini]
							-9999*(1-B_Arranque[RT][Pini]+(1-c_Mod1_Ent[RT]));
						
		UR_DR_Vmax_Frt_CI[RT]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la frontera Mod1-Mod2 en la condici�n inicial*/
			GenRecT_t_1[RT]<=sum(Su in Interv_Mod2_UR: Su.CONF==RCt.CONF)Su.VALMAX*B_UR[Su.INTERVALO][Pini]
							+sum(Sd in Interv_Mod2_DR: Sd.CONF==RCt.CONF)Sd.VALMAX*B_DR[Sd.INTERVALO][Pini]
							+9999*(1-B_Arranque[RT][Pini]+(1-c_Mod1_Ent[RT]));	

		UR_MaxVar_Frt_CI[RT]:											/*L�mita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la frontera Mod1-Mod2 en la condici�n inicial*/					
			V_GenFirme[RT][Pini]-GenRecT_t_1[RT]<=
        					sum(Su in Interv_Mod2_UR: Su.CONF==RCt.CONF)Su.URMAX*B_UR[Su.INTERVALO][Pini]
        					+9999*(1-B_Arranque[RT][Pini]+(1-c_Mod1_Ent[RT]));/*Se deja de cumplir la restricci�n si el modelo 1 de entrada est� inactivo*/							
	}     
	
	forall(RT in RT_Mod2: TipoMod!="PID"){		
		UR_DR_Causal_CI[RT]:											/*Verifica que solo se active uno de los intervalos ya sea para subir o bajar en la condici�n inicial*/
        	sum(Su in Interv_Mod2_UR, RCt1 in Conf_Tabla: Su.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_t_1[RT] || RCt1.NUMERO==Conf_Prd[RT][Pini]))B_UR[Su.INTERVALO][Pini]
       		+sum(Sd in Interv_Mod2_DR, RCt1 in Conf_Tabla: Sd.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_t_1[RT] || RCt1.NUMERO==Conf_Prd[RT][Pini]))B_DR[Sd.INTERVALO][Pini]<=1;
	}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������RESTRICCIONES PARA EL DESPACHO ALTERNATIVO�������������������������������������������������������������������������������|*/
	forall(RT in RT_URPrima,t in Periodos, RCt1 in Conf_Tabla: t>Pini && BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && c_Mod23[RT][t]==1 && TipoMod!="PID"){
		URp_Prima[RT][t]:												/*Limita la m�xima variaci�n para subir con un despacho alternativo*/
        	V_GenFirme[RT][t]-(V_GenFirme[RT][t-1]+V_GenRampaUR[RT][t-1])<=
        	sum(Sup in Dat_URPrima: Sup.CONF==RCt1.CONF)Sup.URPRIMA*B_UR_Prima[RT][t]+9999*(1-B_UR_Prima[RT][t])
        	+9999*B_uMinT[RT][t-1];	
	}

	forall(RT in RT_URPrima,t in Periodos: t>=Pini && TipoMod!="PID"){
		Actv_MinT[RT][t]:												/*Define cuando la generaci�n en firme es igual al m�nimo t�cnico*/
			V_GenFirme[RT][t]<=	sum(RCt in Conf_Tabla: RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t])MinTecRecurso_T[RCt.CONF]+9999*(1-B_uMinT[RT][t]);
	}
	 	  	  		
	
	forall(RT in RT_DRPrima,t in Periodos: t>=Pini && TipoMod!="PID"){
		Actv_Disp[RT][t]:												/*Define cuando la generaci�n en firme es igual a la disponibilidad*/
			V_GenFirme[RT][t]>=Disp_Rec[RT][t]*B_uDisp[RT][t];
	}	
     		
	forall(RT in RT_DRPrima,t in Periodos, RCt1 in Conf_Tabla: t>Pini && BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && c_Mod23[RT][t]==1 && TipoMod!="PID"){
		DRp_Prima[RT][t]:												/*Limita la m�xima variaci�n para bajar con un despacho alternativo*/
 			V_GenFirme[RT][t-1]-(V_GenFirme[RT][t]+V_GenRampaDR[RT][t])<=
 			sum(Sdp in Dat_DRPrima: Sdp.CONF==RCt1.CONF )Sdp.DRPRIMA*B_DR_Prima[RT][t]+9999*(1-B_DR_Prima[RT][t])
        	+9999*B_uDisp[RT][t-1]+9999*B_uMinT[RT][t-1]+sum(RTe in Rec_Salida_Esp: RTe==RT)9999*B_Par_Especial[RT][t]; ;
	}
       
	forall(RT in RT_URPrima,t in Periodos: t>Pini+1 && BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && TipoMod!="PID"){
		Activacion_URp[RT][t]:											/*Activaci�n del despacho alternativo para subir, se iguala al DR del periodo anterior*/
			B_UR_Prima[RT][t]==sum(Sd in Interv_Mod2_DR, RCt1 in Conf_Tabla: Sd.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_Prd[RT][t-2] || RCt1.NUMERO==Conf_Prd[RT][t-1]))B_DR[Sd.INTERVALO][t-1];
 	}
 					
	forall(RT in RT_DRPrima,t in Periodos: t>Pini+1 && BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && TipoMod!="PID"){		
		Activacion_DRp[RT][t]:											/*Activaci�n del despacho alternativo para bajar, se iguala al UR del periodo anterior*/
			B_DR_Prima[RT][t]==sum(Su in Interv_Mod2_UR, RCt1 in Conf_Tabla: Su.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_Prd[RT][t-2] || RCt1.NUMERO==Conf_Prd[RT][t-1]))B_UR[Su.INTERVALO][t-1];			
  	}	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/    


/*|����������������������������������������������������������������������RESTRICCIONES PARA EL DESPACHO ALTERNATIVO EN LA CONDICI�N INICIAL������������������������������������������������������������������|*/
	forall(RT in RT_URPrima, RCt1 in Conf_Tabla: BanderaPruebas[RT][Pini]==0 && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && nSal_ini[RT]<=0 && c_Mod23[RT][Pini]==1 && TipoMod!="PID"){
		URp_Prima_CI[RT]:												/*Limita la m�xima variaci�n para subir con un despacho alternativo en la condici�n inicial*/
        	V_GenFirme[RT][Pini]-GenRecT_t_1[RT]<=
        	sum(Sup in Dat_URPrima: Sup.CONF==RCt1.CONF)(Sup.URPRIMA*B_UR_Prima[RT][Pini])+9999*(1-B_UR_Prima[RT][Pini])
        	+9999*sum(uM in 1..1: GenRecT_t_1[RT]==MinTecRecurso_T[RCt1.CONF])uM;	
	}	        	

	forall(RT in RT_DRPrima, RCt1 in Conf_Tabla: 	BanderaPruebas[RT][Pini]==0  && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] &&
													nSal_ini[RT]<=0 && nEnt_ini[RT]<=0 && (Tiempo_en_Linea[RT]>0 || Tiempo_fuera_Linea[RT]>0) && c_Mod23[RT][Pini]==1 && TipoMod!="PID"){
		DRp_Prima_CI[RT]:												/*Limita la m�xima variaci�n para bajar con un despacho alternativo en la condici�n inicial*/
 			GenRecT_t_1[RT]-(V_GenFirme[RT][Pini]+V_GenRampaDR[RT][Pini])<=
 			sum(Sdp in Dat_DRPrima: Sdp.CONF==RCt1.CONF)(Sdp.DRPRIMA*B_DR_Prima[RT][Pini])+9999*(1-B_DR_Prima[RT][Pini])
        	+9999*sum(uD in 1..1: GenRecT_t_1[RT]==Disp_t_1[RT])uD+9999*sum(uM in 1..1: GenRecT_t_1[RT]==MinTecRecurso_T[RCt1.CONF])uM
        	+sum(RTe in Rec_Salida_Esp: RTe==RT)9999*B_Par_Especial[RT][Pini];
	}	        	
	
	forall(RT in RT_URPrima: BanderaPruebas[RT][Pini]==0 && TipoMod!="PID"){
		Activ_URp_CI_Pini[RT]:											/*Activaci�n del despacho alternativo para subir para el periodo Pini, se iguala al DR del periodo anterior*/
			B_UR_Prima[RT][Pini]==sum(uDr in 1..1: GenRecT_t_2[RT]>GenRecT_t_1[RT])uDr;			        	
	}
	
	forall(RT in RT_URPrima: BanderaPruebas[RT][Pini+1]+BanderaPruebas[RT][Pini]<=1 && Pini<Pfin && TipoMod!="PID"){
		Activ_URp_CI_Pini_1[RT]:										/*Activaci�n del despacho alternativo para subir para el periodo Pini+1, se iguala al DR del periodo anterior*/
			B_UR_Prima[RT][Pini+1]==sum(Sd in Interv_Mod2_DR, RCt1 in Conf_Tabla: Sd.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_t_1[RT] || RCt1.NUMERO==Conf_Prd[RT][Pini]))B_DR[Sd.INTERVALO][Pini];			        	
	}
     		
	forall(RT in RT_DRPrima: BanderaPruebas[RT][Pini]==0 && TipoMod!="PID"){	
		
		Activ_DRp_CI_Pini[RT]:											/*Activaci�n del despacho alternativo para bajar para el periodo Pini, se iguala al UR del periodo anterior*/
			B_DR_Prima[RT][Pini]==sum(uUr in 1..1: GenRecT_t_2[RT]<GenRecT_t_1[RT])uUr;			        	
	}        	
	
	forall(RT in RT_DRPrima: BanderaPruebas[RT][Pini+1]+BanderaPruebas[RT][Pini]<=1 && Pini<Pfin && TipoMod!="PID"){		
		Activ_DRp_CI_Pini_1[RT]:										/*Activaci�n del despacho alternativo para bajar para el periodo Pini+1, se iguala al UR del periodo anterior*/
			B_DR_Prima[RT][Pini+1]==sum(Su in Interv_Mod2_UR, RCt1 in Conf_Tabla: Su.CONF==RCt1.CONF && RCt1.RECURSO==RT && (RCt1.NUMERO==Conf_t_1[RT] || RCt1.NUMERO==Conf_Prd[RT][Pini]))B_UR[Su.INTERVALO][Pini];			        	
	}   				
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������������������������������������������RESTRICCIONES PARA EL MODELO 3�������������������������������������������������������������������������������������|*/
	forall (RT in RT_Mod3,t in Periodos, RCt1 in Conf_Tabla, M3 in Mod3_ABCD: 	t>Pini && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && M3.CONF==RCt1.CONF 
																				&& BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && c_Mod23[RT][t]==1 && TipoMod!="PID"){
		Modelo3_Up[RT][t]:												/*Limitaci�n de la generaci�n con el modelo 3 para subir*/
           V_GenFirme[RT][t]<= (M3.UR+M3.B*V_GenFirme[RT][t-1])/M3.A+9999*(1-B_OnOff_RecT[RT][t-1])+9999*(B_Arranque[RT][t]);    
                 
		Modelo3_Dn[RT][t]:												/*Limitaci�n de la generaci�n con el modelo 3 para bajar*/
           V_GenFirme[RT][t]+V_GenRampaDR[RT][t]>=(M3.C*V_GenFirme[RT][t-1]-M3.DR)/M3.D;
    } 
    
	forall (RT in RT_Mod3,t in Periodos, RCt in Conf_Tabla, M3 in Mod3_ABCD: 	t>Pini && RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][t] && M3.CONF==RCt.CONF  
																				&& BanderaPruebas[RT][t]+BanderaPruebas[RT][t-1]<=1 && c_Mod23[RT][t]==1 && TipoMod!="PID"){
		Modelo3_Up_Frt[RT][t]:											/*Limitaci�n de la generaci�n con el modelo 3 para subir en la frontera mod1-mod3*/
           V_GenFirme[RT][t]<= (M3.UR+M3.B*V_GenRampaUR[RT][t-1])/M3.A+9999*((1-B_Arranque[RT][t])+(1-c_Mod1_Ent[RT]));
    }  
    
	forall (RT in RT_Mod3, RCt1 in Conf_Tabla, M3 in Mod3_ABCD: RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && M3.CONF==RCt1.CONF && 
																nSal_ini[RT]<=0 && nEnt_ini[RT]<=0 && (Tiempo_en_Linea[RT]>0 || Tiempo_fuera_Linea[RT]>0)
																&& BanderaPruebas[RT][Pini]==0 && c_Mod23[RT][Pini]==1 && TipoMod!="PID"){
		Modelo3_Up_CI[RT]:												/*Limitaci�n de la generaci�n con el modelo 3 para subir en la condici�n inicial*/
           V_GenFirme[RT][Pini]<= (M3.UR+M3.B*GenRecT_t_1[RT])/M3.A;    

		Modelo3_Dn_CI[RT]:												/*Limitaci�n de la generaci�n con el modelo 3 para bajar en la condici�n inicial*/
           V_GenFirme[RT][Pini]+V_GenRampaDR[RT][Pini]>=(M3.C*GenRecT_t_1[RT]-M3.DR)/M3.D;
    } 
    
	forall (RT in RT_Mod3, RCt in Conf_Tabla, M3 in Mod3_ABCD: 	RCt.RECURSO==RT && RCt.NUMERO==Conf_Prd[RT][Pini] && M3.CONF==RCt.CONF 
																&& GenRecT_t_1[RT]<=MinTecRecurso_T[RCt.CONF] && BanderaPruebas[RT][Pini]==0
																&& ((nEnt_ini[RT]>0  && Tiempo_en_Linea[RT]==0 && Tiempo_fuera_Linea[RT]==0) || GenRecT_t_1[RT]<0.00001) && c_Mod23[RT][Pini]==1 && TipoMod!="PID"){
		Modelo3_Up_Frt_CI[RT]:											/*Limitaci�n de la generaci�n con el modelo 3 para subir en la frontera mod1-mod3 en la condici�n inicial*/
			V_GenFirme[RT][Pini]<= (M3.UR+M3.B*GenRecT_t_1[RT])/M3.A+9999*((1-B_Arranque[RT][Pini])+(1-c_Mod1_Ent[RT]));
    }      
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������������������MODELO DE CARGA ESTABLE�����������������������������������������������������������������������������������������|*/
	forall(RT in RT_ModCE, t in Periodos, RCt1 in Conf_Tabla, CE in Dat_ModCE: 	t>Pini && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && CE.CONF==RCt1.CONF && c_CE[RT][t]==1 && TipoMod!="PID"){
		Max_CE_Up[RT][t]:												/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n sube*/
			V_GenFirme[RT][t]-V_GenFirme[RT][t-1]<=			
			CE.MAXCE+9999*B_bCE[RT][t]+9999*(2-B_OnOff_RecT[RT][t]-B_OnOff_RecT[RT][t-1]);
			
		Max_CE_Dn[RT][t]:												/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n baja*/
			V_GenFirme[RT][t-1]-V_GenFirme[RT][t]<=			
			CE.MAXCE+9999*B_bCE[RT][t]+9999*(2-B_OnOff_RecT[RT][t]-B_OnOff_RecT[RT][t-1]);
	}
     
	forall(	RT in RT_ModCE, t in Periodos, RCt1 in Conf_Tabla, CE in Dat_ModCE, Pce in 1..(CE.TCE-1): t>Pini && t+Pce<=Pfin && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_Prd[RT][t-1] && CE.CONF==RCt1.CONF && TipoMod!="PID"){
		CargaEstableUp[RT][t+Pce][t]:									/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n sube*/
			V_GenFirme[RT][t+Pce]-V_GenFirme[RT][t+Pce-1]<=9999*(1-B_bCE[RT][t])+9999*sum(RI in RecInfact_Esp: RI==RT)(B_uInfact[RT][t])+9999*(1-c_CE[RT][t]);
			
		CargaEstableDn[RT][t+Pce][t]:									/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n baja*/
			V_GenFirme[RT][t+Pce-1]-V_GenFirme[RT][t+Pce]<=9999*(1-B_bCE[RT][t])+9999*sum(RI in RecInfact_Esp: RI==RT)(B_uInfact[RT][t])+9999*(1-c_CE[RT][t]);       
	}
	
	forall(RT in RT_ModCE, t in Periodos: t>Pini && c_CE[RT][t]==1 && TipoMod!="PID"){
		CE_uInfact_Esp[RT][t]:											/*Si en un mismo periodo se activa el cambio por CE y la generaci�n infactible especial, la bandera de CE se pasa el siguiente periodo*/
			B_bCE[RT][t-1]+sum(RI in RecInfact_Esp: RI==RT)(B_uInfact[RT][t-1])<=1+9999*B_bCE[RT][t];
	}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������������������MODELO DE CARGA ESTABLE EN LA CONDICI�N INICIAL�����������������������������������������������������������������������������|*/     
	forall(RT in RT_ModCE, RCt1 in Conf_Tabla, CE in Dat_ModCE: GenRecT_t_1[RT]>=MinTecRecurso_T[RCt1.CONF] &&  nEnt_ini[RT]+nSal_ini[RT]<=0 && Tiempo_en_Linea[RT]>0 
																&& RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && CE.CONF==RCt1.CONF && c_CE[RT][Pini]==1 && TipoMod!="PID"){
																  
		Max_CE_Up_CI[RT]:												/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n sube en la condici�n inicial*/
			if((TipoMod=="IDE" && (RT in (RT_ModCE diff RecInfact_Esp))) || (TipoMod=="DPC" || TipoMod=="RDP")){		/*En el despacho IDEAL no se activa la CE por la condici�n inicial para ZIPA2, ZIPA3, ZIPA4, ZIPA5*/
				V_GenFirme[RT][Pini]-GenRecT_t_1[RT]<=
													CE.MAXCE+9999*B_bCE[RT][Pini]+9999*(1-B_OnOff_RecT[RT][Pini]);}		
			
		Max_CE_Dn_CI[RT]:												/*Verifica si entre dos periodos se super� la m�xima variaci�n para CE si la generaci�n baja en la condici�n inicial*/
			if((TipoMod=="IDE" && (RT in (RT_ModCE diff RecInfact_Esp))) || (TipoMod=="DPC" || TipoMod=="RDP")){		/*En el despacho IDEAL no se activa la CE por la condici�n inicial para ZIPA2, ZIPA3, ZIPA4, ZIPA5*/
			  	GenRecT_t_1[RT]-V_GenFirme[RT][Pini]<=													
													CE.MAXCE+9999*B_bCE[RT][Pini]+9999*(1-B_OnOff_RecT[RT][Pini]);}
	}
     
	forall(RT in RT_ModCE, RCt1 in Conf_Tabla, CE in Dat_ModCE, Pce in 1..(CE.TCE-1):	Pini+Pce<=Pfin && RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && CE.CONF==RCt1.CONF && TipoMod!="PID"){
		CargaEstableUp_CI[RT][Pini+Pce]:								/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n sube en la condici�n inicial*/
			V_GenFirme[RT][Pini+Pce]-V_GenFirme[RT][Pini+Pce-1]<=9999*(1-B_bCE[RT][Pini])+9999*sum(RI in RecInfact_Esp: RI==RT)(B_uInfact[RT][Pini])+9999*(1-c_CE[RT][Pini]);
			
		CargaEstableDn_CI[RT][Pini+Pce]:								/*Garantiza que no exista cambio entre dos periodos cuando se activa la CE y la generaci�n sube*/
			V_GenFirme[RT][Pini+Pce-1]-V_GenFirme[RT][Pini+Pce]<=9999*(1-B_bCE[RT][Pini])+9999*sum(RI in RecInfact_Esp: RI==RT)(B_uInfact[RT][Pini])+9999*(1-c_CE[RT][Pini]);      
	}
	
	forall(RT in RT_ModCE, RCt1 in Conf_Tabla, CE in Dat_ModCE: nEnt_ini[RT]+nSal_ini[RT]<=0 && Tiempo_en_Linea[RT]>0 && c_CE[RT][Pini]==1
																&& RCt1.RECURSO==RT && RCt1.NUMERO==Conf_t_1[RT] && CE.CONF==RCt1.CONF && TipoMod!="PID"){
		CE_uInfact_Esp_CI[RT]:											/*Si en Pini-1 se activa el cambio por CE y la generaci�n infactible especial, la bandera de CE se pasa el periodo Pini*/
			sum(bi in 1 ..1: abs(GenRecT_t_2[RT]-GenRecT_t_1[RT])>CE.MAXCE)bi+			
			sum(ui in 1..1, ZRI in ZonaInfact_Esp: ZRI.NOMBRE==RT && GenRecT_t_1[RT]>=ZRI.Vmin && GenRecT_t_1[RT]<=(ZRI.Vmax-1))ui<=1+9999*B_bCE[RT][Pini];
	}
	
	forall(RT in RT_ModCE,Pce in 1..TCE_P[RT]: GenRecT_t_1[RT]>0 && TCE_P[RT]>0 && Disp_Rec[RT][Pini+Pce-1]>=GenRecT_t_1[RT] && BanderaPruebas[RT][Pini+Pce-1]==0 && Pini+Pce-1<=Pfin && (TipoMod=="DPC" || TipoMod=="RDP")){
		CE_Inicial[RT][Pce]:											/*Iguala la generaci�n de los periodos restantes cuando se debe carga estable*/
			V_Gen_Rec[RT][Pini+Pce-1]==GenRecT_t_1[RT]; 
	} 
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������������������MODELO DE RAMPAS DE RECURSOS HIDR�ULICOS��������������������������������������������������������������������������������|*/
	forall(RH in RH_ModRamp, t in Periodos: t>Pini && (BanderaPruebas[RH][t]+BanderaPruebas[RH][t-1])<=1 && c_Mod2H[RH][t]==1 && TipoMod!="PID"){	
		RHUR_DR_Vmin[RH][t]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar. Rec Hidr�ulicos*/
			V_Gen_Rec[RH][t-1]>=sum(Su in Dat_RH_UR: Su.RECURSO==RH)Su.VALMIN*B_RHUR[Su.INTERVALO][t]+sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)Sd.VALMIN*B_RHDR[Sd.INTERVALO][t]; 
																																					
		RHUR_DR_Vmax[RH][t]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar. Rec Hidr�ulicos*/
			V_Gen_Rec[RH][t-1]<=sum(Su in Dat_RH_UR: Su.RECURSO==RH)Su.VALMAX*B_RHUR[Su.INTERVALO][t]+sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)Sd.VALMAX*B_RHDR[Sd.INTERVALO][t];
		
		RHUR_MaxVar[RH][t]:												/*Limita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active. Rec Hidr�ulicos*/					
			V_Gen_Rec[RH][t]-V_Gen_Rec[RH][t-1]<=sum(Su in Dat_RH_UR: Su.RECURSO==RH)Su.URMAX*B_RHUR[Su.INTERVALO][t]+sum(RHAGC in RecursoAGC: RHAGC==RH && RH=="MIEL1" && AGC[RH][t]>0 && AGC[RH][t-1]>0)9999;
		
		RHDR_MaxVar[RH][t]:												/*Limita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active. Rec Hidr�ulicos*/
	        	V_Gen_Rec[RH][t-1]-V_Gen_Rec[RH][t]<=sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)Sd.DRMAX*B_RHDR[Sd.INTERVALO][t]+sum(RHAGC in RecursoAGC: RHAGC==RH && RH=="MIEL1" && AGC[RH][t]>0 && AGC[RH][t-1]>0)9999;
	}
	
	forall(RH in RH_ModRamp, t in Periodos: t>=Pini && TipoMod!="PID"){
		RHUR_DR_Causal[RH][t]:											/*Verifica que solo se active uno de los intervalos ya sea para subir o bajar en un periodo. Rec Hidr�ulicos*/
        	sum(Su in Dat_RH_UR: Su.RECURSO==RH)B_RHUR[Su.INTERVALO][t]+sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)B_RHDR[Sd.INTERVALO][t]<=1;
	}    
	
	forall(RH in RH_ModRamp: BanderaPruebas[RH][Pini]==0 && c_Mod2H[RH][Pini]==1 && (TipoMod=="DPC" || TipoMod=="RDP")){	
		RHUR_DR_Vmin_CI[RH]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�nimo en uno de los intervalos para subir o para bajar en la condici�n inicial. Rec Hidr�ulicos*/
			GenRecH_t_1[RH]>=sum(Su in Dat_RH_UR: Su.RECURSO==RH)Su.VALMIN*B_RHUR[Su.INTERVALO][Pini]+sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)Sd.VALMIN*B_RHDR[Sd.INTERVALO][Pini]; 
																																					
		RHUR_DR_Vmax_CI[RH]:											/*Ubica la generaci�n del periodo t-1 respecto el valor m�ximo en uno de los intervalos para subir o para bajar en la condici�n inicial. Rec Hidr�ulicos*/
			GenRecH_t_1[RH]<=sum(Su in Dat_RH_UR: Su.RECURSO==RH)Su.VALMAX*B_RHUR[Su.INTERVALO][Pini]+sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)Sd.VALMAX*B_RHDR[Sd.INTERVALO][Pini];
		
		RHUR_MaxVar_CI[RH]:												/*Limita la m�xima variaci�n para subir entre periodos seg�n el intervalo que se active en la condici�n inicial. Rec Hidr�ulicos*/					
			V_Gen_Rec[RH][Pini]-GenRecH_t_1[RH]<=sum(Su in Dat_RH_UR: Su.RECURSO==RH)Su.URMAX*B_RHUR[Su.INTERVALO][Pini];
		
		RHDR_MaxVar_CI[RH]:												/*Limita la m�xima variaci�n para bajar entre periodos seg�n el intervalo que se active en la condici�n inicial. Rec Hidr�ulicos*/
	        GenRecH_t_1[RH]-V_Gen_Rec[RH][Pini]<=sum(Sd in Dat_RH_DR: Sd.RECURSO==RH)Sd.DRMAX*B_RHDR[Sd.INTERVALO][Pini];   
	}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|��������������������������������������������������������������������������������RESTRICCIONES GENERALES PARA LAS UNIDADES���������������������������������������������������������������������������������|*/
	forall (R in Recursos,t in Periodos: t>=Pini){
		Relacion_Recurso_Unidad[R][t]:								/*La generaci�n de cada recurso debe ser igual a la suma de todas sus unidades*/
			V_Gen_Rec[R][t]==sum(RU in RecursoUnidades:RU.RECURSO==R)V_Gen_Und[RU.UNIDAD][t];
   	}
   	
	forall(U in Unidades,t in Periodos: t>=Pini){
    	Disp_Unidades[U][t]:										/*Limitaci�n de la generaci�n de la unidad a la disponibilidad ofertada*/
    	  	V_Gen_Und[U][t]<=Disp_Und[U][t]; 
	} 
	
	forall(U in (Und_Hidraulica union Und_Solar union Und_Eolica),t in Periodos: t>=Pini && BanderaPruebasUnidad[U][t]==0 && TipoMod!="PID"){
     	MinTecnico_Und[U][t]:  										/*La generaci�n de la unidad  debe ser mayor al m�nimo t�cnico si esta se utiliza (no aplica para t�rmicas)*/
        	V_Gen_Und[U][t]>=MT_Und[U]*B_OnOff_Und[U][t];                                  
   	}	
   	  
   	forall(U in (Und_Hidraulica union Und_Solar union Und_Eolica),t in Periodos: t>=Pini){
     	Disponibilidad_Und[U][t]:  									/*La generaci�n de la unidad  debe ser menor a la disponibildad si este se utiliza (no aplica para t�rmicas)*/
        	V_Gen_Und[U][t]<=Disp_Und[U][t]*B_OnOff_Und[U][t];                                  
   	}
   	
	forall(U in Und_noCentral,t in Periodos: t>=Pini && BanderaPruebasUnidad[U][t]==0 && TipoMod!="PID"){
     	MinTecnico_UMenor[U][t]:  										/*La generaci�n de la unidad menor debe ser mayor al m�nimo t�cnico si esta se utiliza*/
        	//V_Gen_Und[U][t]>=MT_Und[U]*B_OnOff_UMenor[U][t];
        	V_Gen_Und[U][t]>=0.001*B_OnOff_UMenor[U][t];  /*Existen muchas menores con el m�nimo t�cnico malo*/                                
   	}	
   	  
   	forall(U in Und_noCentral,t in Periodos: t>=Pini){
     	Disponibilidad_UMenor[U][t]:  									/*La generaci�n de la unidad menor debe ser menor a la disponibildad si este se utiliza*/
        	V_Gen_Und[U][t]<=Disp_Und[U][t]*B_OnOff_UMenor[U][t];                                  
   	}
   	
	forall(U in (UnidadesAGC diff Und_Internacional),t in Periodos: t>=Pini && AGCUnd[U][t]>0 && (TipoMod=="DPC" || TipoMod=="RDP")){
		AGCUp_Und[U][t]:												/*L�mite inferior de la generaci�n de una unidad que tiene asignado AGC*/												
			sum(Uh in (Und_Hidraulica union Und_Solar union Und_Eolica):Uh==U)V_Gen_Und[U][t]+
			sum(Ut in Und_Termica:Ut==U)V_GenUndFirme[U][t]>=MinTec_AGC_Und[U][t]+AGCUnd[U][t];
			
		AGCDn_Und[U][t]:												/*L�mite superior de la generaci�n de una unidad que tiene asignado AGC*/
     		sum(Uh in (Und_Hidraulica union Und_Solar union Und_Eolica):Uh==U)V_Gen_Und[U][t]+
     		sum(Ut in Und_Termica:Ut==U)V_GenUndFirme[U][t]<=Disp_Und[U][t]-AGCUnd[U][t];
   } 
   
   forall(MiU in MinObl_Und: MiU.PERIODO>=Pini && BanderaPruebasUnidad[MiU.UNIDAD][MiU.PERIODO]==0 && (TipoMod=="DPC" || TipoMod=="RDP")){
   		GenOblMin_Und[MiU.UNIDAD][MiU.PERIODO]:							/*Generaci�n m�nima obligada para las unidades de generaci�n*/
   			V_Gen_Und[MiU.UNIDAD][MiU.PERIODO]>=MiU.MIN;
   }
   
   forall(MxU in MaxObl_Und: MxU.PERIODO>=Pini && BanderaPruebasUnidad[MxU.UNIDAD][MxU.PERIODO]==0 && (TipoMod=="DPC" || TipoMod=="RDP")){
      	GenOblMax_Und[MxU.UNIDAD][MxU.PERIODO]:							/*Generaci�n m�xima obligada para las unidades de generaci�n*/
      		V_Gen_Und[MxU.UNIDAD][MxU.PERIODO]<=MxU.MAX;
   }
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/   	


/*|��������������������������������������������������������������������������������RESTRICCIONES PARA LAS UNIDADES T�RMICAS���������������������������������������������������������������������������������|*/
	forall(UT in Und_Termica,t in Periodos: t>=Pini && BanderaPruebasUnidad[UT][t]==0 && (TipoMod=="DPC" || TipoMod=="RDP")){
		MinTecnico_UndT[UT][t]:  										/*La generaci�n en firme de la unidad t�rmica debe ser mayor al m�nimo t�cnico si esta se utiliza*/
			V_GenUndFirme[UT][t]>=MT_Und[UT]*B_OnOff_UndT[UT][t]; 
	}
     
	forall(UT in Und_Termica,t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")){
		Disponibilidad_UndT[UT][t]:   									/*La generaci�n de la unidad t�rmica debe ser menor a la disponibildad si este se utiliza*/
			V_GenUndFirme[UT][t]<=Disp_Und[UT][t]*B_OnOff_UndT[UT][t];                                  

		Modelo_UndT[UT][t]:  											/*Partici�n de la generaci�n de la unidad t�rmica en: generaci�n firme, rampa de entrada y rampa de salida*/
			V_Gen_Und[UT][t]==V_GenUndFirme[UT][t]+ sum(RU in RecursoUnidades:RU.UNIDAD==UT)((V_GenUndRampaDR[UT][t]+V_GenUndRampaUR[UT][t]));                      
	}
   
	forall(RT in Rec_Termicos,t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP" || TipoMod=="IDE")){
		RampaUR_RecUnd[RT][t]:											/*La generaci�n por rampa de entrada de las unidades t�rmicas debe corresponder a la del recurso*/	
			V_GenRampaUR[RT][t]==sum(RU in RecursoUnidades:RU.RECURSO==RT)V_GenUndRampaUR[RU.UNIDAD][t];
		RampaDR_RecUnd[RT][t]:											/*La generaci�n por rampa de salida de las unidades t�rmicas debe corresponder a la del recurso*/
			V_GenRampaDR[RT][t]==sum(RU in RecursoUnidades:RU.RECURSO==RT)V_GenUndRampaDR[RU.UNIDAD][t];
		GFirme_RecUnd[RT][t]:											/*La generaci�n en firme de las unidades t�rmicas debe corresponder a la del recurso*/
			V_GenFirme[RT][t]==sum(RU in RecursoUnidades:RU.RECURSO==RT)V_GenUndFirme[RU.UNIDAD][t];            
   }
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�������������������������������������������������������������������������������RESTRICCIONES PARTICULARES PARA LAS UNIDADES�������������������������������������������������������������������������������|*/   	
   	forall(U in Und_Hidraulica,RH in RecH_MT_Esp,RU in RecursoUnidades,t in Periodos: t>=Pini && RU.RECURSO==RH && RU.UNIDAD==U && (TipoMod=="DPC" || TipoMod=="RDP")){
		MinTecUnd_Esp[U][t]:											/*M�nimo t�cnico de las unidades con m�nimo t�cnico especial, equivale al m�nimo ingresado por perfiles para esas unidades*/
			V_Gen_Und[U][t]>=MinUnd_Esp[U][t]*B_OnOff_Und[U][t]-sum(UAGC in UnidadesAGC: UAGC==U && AGCUnd[UAGC][t]>0)9999;
   	}
   	  
	forall (U in (Und_Hidraulica union Und_Solar union Und_Eolica),t in Periodos: t>=Pini && Disp_Und[U][t]<=0 && (TipoMod=="DPC" || TipoMod=="RDP")){
		OnOffDisp0[U][t]:												/*Cuando la disponibilidad es 0 para los recursos de minimo t�cnico 0, garantiza que el ONOFF sea 0*/
			B_OnOff_Und[U][t]==0;
	}   	
	
	forall (t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP") && BanderaPruebas["PAGUA"][t]==0){
		CadenaHid_Pagua[t]:									/*Obliga la generaci�n de Paraiso y Guaca seg�n la relaci�n de la cadena*/
			sum(PG in Cadena_Pagua)(B_OnOff_Und[PG.PARAISO][t]-B_OnOff_Und[PG.GUACA][t])==0; 
	}   
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|��������������������������������������������������������������������������������������������ZONAS DE SEGURIDAD��������������������������������������������������������������������������������������������|*/
	forall(Zn in Zonas_UndMinimas,t in Periodos: t>=Pini && Valor_Z_UndMin[Zn][t]>0 && (TipoMod=="DPC" || TipoMod=="RDP")){
		Unds_Minimas_Seg[Zn][t]:										/*Se cumple con el requerimiento m�nimo de unidades por */
			sum(UH in (Und_Hidraulica union Und_Solar union Und_Eolica),Pz in Pesos_Z_UndMin: Zn==Pz.ZONA && UH==Pz.UNIDAD && t==Pz.PERIODO)(Pz.PESO*B_OnOff_Und[UH][t]*Bandera_Seg[UH][t])+
	    		sum(UT in Und_Termica,Pz in Pesos_Z_UndMin: Zn==Pz.ZONA && UT==Pz.UNIDAD && t==Pz.PERIODO)(Pz.PESO*B_OnOff_UndT[UT][t]*Bandera_Seg[UT][t])+
		    	sum(Um in Und_noCentral,Pz in Pesos_Z_UndMin: Zn==Pz.ZONA && Um==Pz.UNIDAD && t==Pz.PERIODO)(Pz.PESO*B_OnOff_UMenor[Um][t]*Bandera_Seg[Um][t])
		    	>=Valor_Z_UndMin[Zn][t]-Ho_Z_UndMin[Zn][t]*c_NO_Z;
	}	   
	
	forall (Zn in Zonas_MWMinimos,t in Periodos: t>=Pini && Valor_Z_MWMin[Zn][t]>0 && (TipoMod=="DPC" || TipoMod=="RDP")){
		MW_Minimos_Seg[Zn][t]:											/*Cumplimiento de generaci�n m�nima  necesaria por seguridad*/
			sum(UH in (Und_Hidraulica union Und_Solar union Und_Eolica),Iz in Info_Z_MWMin: Zn==Iz.ZONA && UH==Iz.UNIDAD)(V_Gen_Und[UH][t]*Bandera_Seg[UH][t])+
			sum(Um in Und_noCentral,Iz in Info_Z_MWMin: Zn==Iz.ZONA && Um==Iz.UNIDAD)(V_Gen_Und[Um][t]*Bandera_Seg[Um][t])+
			sum(Ui in Und_Internacional,Iz in Info_Z_MWMin: Zn==Iz.ZONA && Ui==Iz.UNIDAD)(V_Gen_Und[Ui][t]*Bandera_Seg[Ui][t])+
			sum(UT in Und_Termica,Iz in Info_Z_MWMin: Zn==Iz.ZONA && UT==Iz.UNIDAD)(V_GenUndFirme[UT][t]*Bandera_Seg[UT][t])
			>=Valor_Z_MWMin[Zn][t]-Ho_Z_MWMin[Zn][t]*c_NO_Z;  
	}	

	forall (Zn in Zonas_MWMaximos,t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")){
		MW_Maximos_Seg[Zn][t]:											/*Cumplimiento de generaci�n m�xima necesaria por seguridad*/
			sum(U in Unidades,Iz in Info_Z_MWMax: Zn==Iz.ZONA && U==Iz.UNIDAD)(V_Gen_Und[U][t]+BanderaAGCZona[Zn]*sum(UAGC in UnidadesAGC: UAGC==U)AGCUnd[U][t])
			<=Valor_Z_MWMax[Zn][t]+Ho_Z_MWMax[Zn][t]*c_NO_Z;  
	}	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������������������������������������L�MITES DE EXPORTACI�N E IMPORTACI�N�����������������������������������������������������������������������������������|*/
	forall(S in Subarea,t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")){
		Intercambio_Sub[S][t]:											/*Restricci�n de la variable para almacenar el intercambio de la subarea*/
			V_IntSubArea[S][t]==DemandaSubarea[S][t]-V_RacionamientoSubArea[S][t]-sum(US in UnidadSubarea: US.SUBAREA==S)(V_Gen_Und[US.UNIDAD][t]*Bandera_Seg[US.UNIDAD][t]);								
       		
		Limite_Imp_Sub[S][t]:											/*Cumplimiento del l�mite de importaci�n de la sub�rea*/
			V_IntSubArea[S][t]+sum(US in UnidadSubarea, UniT in Und_Termica: US.SUBAREA==S && US.UNIDAD==UniT)((V_GenUndRampaUR[UniT][t]+V_GenUndRampaDR[UniT][t])*Bandera_Seg[UniT][t])
			<=ImpSubarea[S][t]*BanderaSubarea[S]+ImpSub_Unico[S]*(1-BanderaSubarea[S]);  
       		
		Limite_Exp_Sub[S][t]:											/*Cumplimiento del l�mite de exportaci�n de la sub�rea*/
			sum(US in UnidadSubarea: US.SUBAREA==S)(V_Gen_Und[US.UNIDAD][t]*Bandera_Seg[US.UNIDAD][t])-DemandaSubarea[S][t]+V_RacionamientoSubArea[S][t]
       		<=ExpSubarea[S][t]*BanderaSubarea[S]+ExpSub_Unico[S]*(1-BanderaSubarea[S]);  
	} 
	
	forall(S in Subarea,t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP" || TipoMod=="PID")){
		Rac_Minimo[S][t]:											/*Cumplimiento del racionamiento obligado para cada sub�rea en cada periodo*/
		  	if (TipoMod=="PID"){V_RacSubAreaProgramado[S][t]==0;}
			else{V_RacSubAreaProgramado[S][t]==RacMin_Subarea[S][t];}  
			
		Tipo_Racionamiento[S][t]:										/*Tipo racionamiento para cada sub�rea en cada periodo*/
			V_RacionamientoSubArea[S][t]==V_RacSubAreaFO[S][t]+V_RacSubAreaProgramado[S][t];
	} 	

	forall(A in Areas,t in Periodos: t>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")){
		Intercambio_Are[A][t]:											/*Restricci�n de la variable para almacenar el intercambio del �rea*/
			V_IntArea[A][t]==DemandaArea[A][t]-sum(SA in SubareaArea: SA.AREA==A)V_RacionamientoSubArea[SA.SUBAREA][t]
								-sum(SA in SubareaArea: SA.AREA==A)(sum(US in UnidadSubarea: US.SUBAREA==SA.SUBAREA)(V_Gen_Und[US.UNIDAD][t]*Bandera_Seg[US.UNIDAD][t])); 
			
		Limite_Imp_Area[A][t]:											/*Cumplimiento del l�mite de importaci�n de la sub�rea*/
			V_IntArea[A][t]+
			sum(SA in SubareaArea: SA.AREA==A)(sum(US in UnidadSubarea, UniT in Und_Termica: US.SUBAREA==SA.SUBAREA && US.UNIDAD==UniT)((V_GenUndRampaUR[UniT][t]+V_GenUndRampaDR[UniT][t])*Bandera_Seg[UniT][t]))
			<=ImpArea[A][t]*BanderaArea[A]+ImpArea_Unico[A]*(1-BanderaArea[A]);  
       		
		Limite_Exp_Area[A][t]:											/*Cumplimiento del l�mite de exportaci�n de la sub�rea*/
			sum(SA in SubareaArea: SA.AREA==A)(sum(US in UnidadSubarea: US.SUBAREA==SA.SUBAREA)(V_Gen_Und[US.UNIDAD][t]*Bandera_Seg[US.UNIDAD][t]))
			-DemandaArea[A][t]+sum(SA in SubareaArea: SA.AREA==A)V_RacionamientoSubArea[SA.SUBAREA][t]
       		<=ExpArea[A][t]*BanderaArea[A]+ExpArea_Unico[A]*(1-BanderaArea[A]);  
	} 		
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

}


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   POSTPROCESO   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*|�������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DEL N�MERO DE BLOQUES, CONFIGURACI�N Y ESTADO PARA  CADA PERIODO DE AN�LISIS�������������������������������������������������|*/
/*La siguiente infomaci�n se construye con el objetivo de alimentar las condiciones iniciales del problema para dias o periodos posteriores con la informaci�n del problema actual*/

range tP=Pini..Pfin;													/*Rango de periodos de an�lisis*/
range nEmax=1..Nmax;													/*Rango de segmentos hasta el valor m�ximo permitido*/
int u_UP[Rec_Termicos][Pini-1..Pfin];									/*N�mero de bloques de entrada que lleva el recurso en cada periodo de an�lisis*/
int u_DN[Rec_Termicos][Pini-1..Pfin];									/*N�mero de bloques de salida que lleva el recurso en cada periodo de an�lisis*/
string c_UP[Rec_Termicos][tP];											/*Configuraci�n del bloque de entrada para cada recurso en cada periodo de an�lisis*/
string Est[Rec_Termicos][tP];											/*Estado del bloque de entrada para cada recurso en cada periodo de an�lisis*/
string c_DN[Rec_Termicos][tP];											/*Configuraci�n del bloque de salida para cada recurso en cada periodo de an�lisis*/

execute Bloques_Ini{													/*Rutina que calcula el n�mero de bloques de entrada y salida que lleva el recurso en cada periodo*/
	for(var RT in Rec_Termicos){
	  	u_UP[RT][Pini-1]=nEnt_ini[RT];
	  	u_DN[RT][Pini-1]=nSal_ini[RT];
		for(var t in tP){
		  	if(V_GenRampaUR[RT][t]>0.000001 && V_Gen_Rec[RT][t]>0.000001){
		  	  	u_UP[RT][t]=1+u_UP[RT][t-1];	  	  
		  	}
			else{
			 	  u_UP[RT][t]=0;
			}
		  	if(V_GenRampaDR[RT][t]>0.000001 && V_Gen_Rec[RT][t]>0.000001){
		  	  	u_DN[RT][t]=1+u_DN[RT][t-1];	  	  
		  	}
			else{
			  	  u_DN[RT][t]=0;
			}			
		}	  
	}	
}	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*|������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DE CONFIGURACI�N Y ESTADO DE BLOQUES DE ENTRADA PARA  CADA PERIODO DE AN�LISIS������������������������������������������������|*/

execute Conf_Estado_Ini_UP{												/*Rutina que encuentra la configuraci�n y el estado del recurso en cada periodo para los bloques de entrada*/
	for(var RT in Rec_Termicos){
		for( var t in tP){		
		  	Est[RT][t]="NA";
		  	c_UP[RT][t]="NA";
		  	c_DN[RT][t]="NA";	
		  	if(B_Arranque[RT][t]>0 && c_Mod1_Ent[RT]==1){				  	
				for(var RCt in Conf_Tabla){			  	  	
					if(RCt.RECURSO==RT && Conf_Prd[RT][t]==RCt.NUMERO){				  					  		  	
				  		for(var t_En in nEmax){
					  		if(B_Arranque[RT][t]>0 && B_Arr_Caliente[RT][t]>0 && nSegmentosCaliente[RCt.CONF]>0 && nSegmentosCaliente[RCt.CONF]>=t_En && t-t_En>=Pini){
					  				c_UP[RT][t-t_En]=RCt.NUMERO;
					  				Est[RT][t-t_En]="C";
							}
							if(B_Arranque[RT][t]>0 && B_Arr_Tibio[RT][t]>0 && nSegmentosTibio[RCt.CONF]>0 && nSegmentosTibio[RCt.CONF]>=t_En && t-t_En>=Pini){
					  				c_UP[RT][t-t_En]=RCt.NUMERO;
					  				Est[RT][t-t_En]="T";
					  		}	
					  		if(B_Arranque[RT][t]>0 && B_Arr_Frio[RT][t]>0 && nSegmentosFrio[RCt.CONF]>0 && nSegmentosFrio[RCt.CONF]>=t_En && t-t_En>=Pini){
					  				c_UP[RT][t-t_En]=RCt.NUMERO;
					  				Est[RT][t-t_En]="F";
					  		}					  				
	     					}				  						  						  				  			  
					}  			  	  
				}
 			}						
		}
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*|������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DE CONFIGURACI�N Y ESTADO DE BLOQUES DE SALIDA PARA  CADA PERIODO DE AN�LISIS�������������������������������������������������|*/

execute Conf_Estado_Ini_DN{												/*Rutina que encuentra la configuraci�n y el estado del recurso en cada periodo para los bloques de salida*/
	for(var RT in Rec_Termicos){
		for(var t in tP){	
			if(t+1<=Pfin && c_Mod1_Sal[RT]==1){
				if(B_Parada[RT][t+1]>0){					  	
					for(var RCt in Conf_Tabla){
						if(RCt.RECURSO==RT && Conf_Prd[RT][t]==RCt.NUMERO){				  					  		  	
						  	for(var t_En in nEmax){
							  	if(B_Par_Normal[RT][t+1]>0 && nSegmentoSalida[RCt.CONF]>0 && nSegmentoSalida[RCt.CONF]>=t_En && t+t_En>=Pini && t+t_En<=Pfin){
							  		c_DN[RT][t+t_En]=RCt.NUMERO;							  		
							  		Est[RT][t+t_En]="DN";
							  	}				  
							  	if(B_Par_Especial[RT][t+1]>0 && 1>=t_En && t+t_En>=Pini && t+t_En<=Pfin){
							  		c_DN[RT][t+t_En]=RCt.NUMERO;
							  		Est[RT][t+t_En]="DNE";
							  	}
        					}					  					
		     			}				  						  						  				  			  
					}  	
  				}						  	  
			}	
			if(t==Pini && c_Mod1_Sal[RT]==1){
				if(B_Parada[RT][Pini]>0){
					for(var RCt1 in Conf_Tabla){
						if(RCt1.RECURSO==RT && Conf_t_1[RT]==RCt1.NUMERO){				  					  		  	
						  	for(var t_En1 in nEmax){
							  	if(B_Par_Normal[RT][Pini]>0 && nSegmentoSalida[RCt1.CONF]>0 && nSegmentoSalida[RCt1.CONF]>=t_En1  && Pini-1+t_En1<=Pfin){
							  		c_DN[RT][Pini-1+t_En1]=RCt1.NUMERO;							  		
							  		Est[RT][Pini-1+t_En1]="DN";
							  	}				  
							  	if(B_Par_Especial[RT][Pini]>0 && 1>=t_En1  && Pini-1+t_En1<=Pfin){
							  		c_DN[RT][Pini-1+t_En1]=RCt1.NUMERO;
							  		Est[RT][Pini-1+t_En1]="DNE";
							  	}
        					}					  					
		     			}				  						  						  				  			  
					}  	
  				}		  
			}	
		}
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DE CE PENDIENTE PARA CADA PERIODO DE AN�LISIS SEG�N LA CONDICION INICIAL���������������������������������������������������|*/
int T_Pend_CE[Rec_Termicos][tP];										/*N�mero de periodos que el recurso debe de carga estable dado para cada periodo de an�lisis */
int Tiene_CE[Rec_Termicos][tP];											/*1 si en el periodo t el recurso est� cumpliendo carga estable*/

execute CE_pendienteCI{													/*Rutina que calcula el n�mero de periodos pendientes por CE de cada recurso en cada periodo, en funci�n del TCE inicial*/
	for(var RT in Rec_Termicos){	
		for(var t in tP){
			if(TCE_P[RT]>0 && c_CE[RT][t]==1){		  
				if(TCE_P[RT]-(t-Pini+1)>=0 && V_GenFirme[RT][t]>0.00001){  	
					T_Pend_CE[RT][t]=TCE_P[RT]-(t-Pini+1);
					Tiene_CE[RT][t]=1;
  				}	
  				else{
  				  	T_Pend_CE[RT][t]=0;
  				  	Tiene_CE[RT][t]=0;
  				}
   			}
   			else{
   				T_Pend_CE[RT][t]=0;
   				Tiene_CE[RT][t]=0;
   			}  			
		}	
	}
}			

/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*|�������������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DE CE PENDIENTE PARA CADA PERIODO DE AN�LISIS SEG�N LA BANDERA DE CE���������������������������������������������������|*/

execute CE_pendiente{													/*Rutina que calcula el n�mero de periodos pendientes por CE de cada recurso en cada periodo, en funci�n la bandera de CE*/
	for(var RecT in Rec_Termicos){
		for(var RT in RT_ModCE){
			if(RecT==RT){
				for(var t in tP){
					if(B_bCE[RT][t]>0 && V_GenFirme[RT][t]>0.00001 && c_CE[RT][t]==1){					  
						for(var RCt1 in Conf_Tabla){
							if(t==Pini && RCt1.RECURSO==RT && Conf_t_1[RT]==RCt1.NUMERO){
								for(var CE in Dat_ModCE){
									if(RCt1.CONF==CE.CONF){
										if(CE.TCE>1 && Math.round((Math.abs(V_GenFirme[RT][t]-GenRecT_t_1[RT]))*100000)/100000>CE.MAXCE){											
											for(var ti in Periodos){
												if(t+ti-1<=Pfin){ 
													if(CE.TCE-ti>=0){
														T_Pend_CE[RT][t+ti-1]=CE.TCE-ti;
														Tiene_CE[RT][t+ti-1]=1;
													} 
													if(CE.TCE-ti<0){
														T_Pend_CE[RT][t+ti-1]=0;														
				       									}
		              									}		       																
											}  
		      								}  															
									}
		    						}												  
							}
							if(t>Pini && RCt1.RECURSO==RT && Conf_Prd[RT][t-1]==RCt1.NUMERO){
								for(var CEx in Dat_ModCE){
									if(RCt1.CONF==CEx.CONF){
										if(CEx.TCE>1 && Math.round((Math.abs(V_GenFirme[RT][t]-V_GenFirme[RT][t-1]))*100000)/100000>CEx.MAXCE){										  	
											for(var tx in Periodos){
												if(t+tx-1<=Pfin){ 
													if(CEx.TCE-tx>=0){
														T_Pend_CE[RT][t+tx-1]=CEx.TCE-tx;
														Tiene_CE[RT][t+tx-1]=1;
													} 
													if(CEx.TCE-tx<0){
														T_Pend_CE[RT][t+tx-1]=0;														
				       									}
		              									}		       												  
											}
		       								}									  							
									}						  
		    						}											
							}
		  				}				
		 			}			
				}
 			} 						
		}			
	}
}	

/*Se realiza una correci�n a este valor para los recuros infactibles especiales*/ 		
execute CE_pendiente_Esp{	
		for(var RI in RecInfact_Esp){
			for (var t in tP){
				 	if(B_uInfact[RI][t]>0){
						 T_Pend_CE[RI][t]=0;
						 Tiene_CE[RI][t]=0;
				 	}
				 	if(V_GenRampaUR[RI][t]+V_GenRampaDR[RI][t]>0.00001){
						 T_Pend_CE[RI][t]=0;
						 Tiene_CE[RI][t]=0;
				 	}				 	
			}
		}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|���������������������������������������������CONSTRUCCI�N DE INFORMACI�N DE TIEMPO EN LINEA Y TIEMPO FUERA DE LINEA DEL RECURSO PARA CADA PERIODO DE AN�LISIS���������������������������������������������|*/
int T_Linea_Post[Rec_Termicos][Pini-1..Pfin];							/*N�mero de periodos que el recurso lleva en l�nea para cada periodo de an�lisis*/
int T_FLinea_Post[Rec_Termicos][Pini-1..Pfin];							/*N�mero de periodos que el recurso lleva fuera de l�nea para cada periodo de an�lisis*/

execute TiempoLineaPost{												/*Rutina que calcula el tiempo en l�nea y fuera de l�nea de cada recurso en cada periodo de an�lisis*/
	for(var RT in Rec_Termicos){
	  	T_Linea_Post[RT][Pini-1]=Tiempo_en_Linea[RT];
	  	T_FLinea_Post[RT][Pini-1]=Tiempo_fuera_Linea[RT];
		for(var t in tP){
			if(B_OnOff_RecT[RT][t]>0){
				T_Linea_Post[RT][t]=T_Linea_Post[RT][t-1]+1;
			}
			if(B_OnOff_RecT[RT][t]<=0){
				T_Linea_Post[RT][t]=0;
			}
		  	if(V_Gen_Rec[RT][t]<=0.00001){
				T_FLinea_Post[RT][t]=T_FLinea_Post[RT][t-1]+1;
			}
			if(V_Gen_Rec[RT][t]>0.00001){
				T_FLinea_Post[RT][t]=0;
			}
			if(T_FLinea_Post[RT][t]>0){
				T_Linea_Post[RT][t]=0;
			}			
		} 
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DEL TIEMPO QUE LLEVA DISPONIBLE EL RECURSO PARA CADA PERIODO DE AN�LISIS��������������������������������������������������|*/
int TDisp_Post[Rec_Termicos][Pini-1..Pfin];								/*N�mero de periodos que el recurso lleva disponible para cada periodo de an�lisis*/


execute TDisponiblePost{												/*Rutina que calcula el tiempo que el recurso lleva disponible en cada periodo de an�lisis*/
	for(var RT in Rec_Termicos){
	  	TDisp_Post[RT][Pini-1]=TDispPini_1[RT];	
		for(var t in tP){
			if(Bandera_Disp[RT][t]>0){
				TDisp_Post[RT][t]=TDisp_Post[RT][t-1]+1;
			}
			else{
				TDisp_Post[RT][t]=0;
			}  	
		}		  	  
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������CONSTRUCCI�N DE INFORMACI�N N�MERO DE ARRANQUES QUE LLEVA EL RECURSO PARA CADA PERIODO DE AN�LISIS���������������������������������������������������|*/
int nArranques_Post[Rec_Termicos][Pini-1..Pfin];								/*N�mero de arranques que el recurso lleva para cada periodo de an�lisis*/

execute numeroArranques_Post{													/*Rutina que calcula el tiempo que el N�mero de arranques que el recurso lleva para cada periodo de an�lisis*/
	for(var RT in Rec_Termicos){
	  	nArranques_Post[RT][Pini-1]=nArr_ini[RT];	
		for(var t in tP){
		  	if(t==1){
		  		nArranques_Post[RT][Pini-1]=0;	  
		  	}
			if(B_Arranque[RT][t]>0){
				nArranques_Post[RT][t]=nArranques_Post[RT][t-1]+1;
			}
			if(B_Arranque[RT][t]<=0){
				nArranques_Post[RT][t]=nArranques_Post[RT][t-1];
			}		
		}		  	  
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������CONSTRUCCI�N DE INFORMACI�N DEL TIEMPO DE AVISO PARA PUBLICAR CUANDO SE CAMBIA EN UN PERIODO���������������������������������������������������|*/
int Publicacion_Post[Rec_Termicos][Pini..Pfin];								/*Tiempo de aviso para publicar de cada periodo, se hereda el mismo para los periodos posteriores*/

execute PubliPost{													/*Rutina que calcula el tiempo de aviso para publicar de cada periodo*/
	for(var RT in Rec_Termicos){	  	
		for(var t in tP){
			Publicacion_Post[RT][t]=Publicacion[RT];	
			if(t=Pfin){
				Publicacion_Post[RT][t]=-10;	
			}
		}		  	  
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   POSTPROCESO - ESCRITURA DE RESULTADOS   ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

/*|���������������������������������������������������������������ESCRITURA DE INFORMACI�N DE LA GENERACI�N DE CADA RECURSO PARA PERIODO>=PINI���������������������������������������������������������������|*/
string  SQL_BorrarGen;
execute BorrarGen{
	SQL_BorrarGen="DELETE FROM "+ Esquema +".DRPT_GENERACIONXRECURSO_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
} 

string  SQL_BorrarGenA;
execute BorrarGenA{
	SQL_BorrarGenA="DELETE FROM "+ Esquema +".DRPT_GENERACIONXRECURSO_AREAS WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
} 

tuple ResultadosRecursos {string CODCASO; string VERSION; string CODRECURSO;string FECHA; string TIPO;  int PERIODO; float  VALOR;} 
{ResultadosRecursos}DespachoRecursos = 
{<CodCaso,Version,Codigo_Rec[Rec],Fecha,"PRIMAL", Prd, round(V_Gen_Rec[Rec][Prd]*1000000)/1000000>|
	Rec in Recursos,Prd in Periodos: Prd>=Pini};
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|����������������������������������������������������������������ESCRITURA DE INFORMACI�N DE LA GENERACI�N DE CADA UNIDAD PARA PERIODO>=PINI���������������������������������������������������������������|*/
string  SQL_BorrarGenU;
execute BorrarGenU{
	SQL_BorrarGenU="DELETE FROM "+ Esquema +".DRPT_GENERACIONSPUNIDAD_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
} 

tuple ResultadosUnidades {string CODCASO; string VERSION; string CODUNIDAD;string FECHA; string TIPO;  int PERIODO; float  VALOR;} 
{ResultadosUnidades}DespachoUnidades = 
{<CodCaso,Version,Codigo_Und[Und],Fecha,"PRIMAL", Prd, round(V_Gen_Und[Und][Prd]*1000000)/1000000>|
	Und in Unidades,Prd in Periodos: Prd>=Pini};
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL INTERCAMBIO DE CADA AREA PARA PERIODO>=PINI����������������������������������������������������������������|*/
string  SQL_BorrarIntA;
execute BorrarIntA{
	SQL_BorrarIntA="DELETE FROM "+ Esquema +".DRPT_INTERCAMBIOAREA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
} 

tuple Info_IntA_T {string CODCASO; string VERSION; string CODAREA;string FECHA; string TIPO;  int PERIODO; float  VALOR;} 
{Info_IntA_T}Info_IntA = 
{<CodCaso,Version,Codigo_Area[Are],Fecha,"PRIMAL", Prd, round(V_IntArea[Are][Prd]*1000000)/1000000>|
	Are in Areas,Prd in Periodos: Prd>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")};
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL INTERCAMBIO DE CADA SUBAREA PARA PERIODO>=PINI���������������������������������������������������������������|*/
string  SQL_BorrarIntSa;
execute BorrarIntSa{
	SQL_BorrarIntSa="DELETE FROM "+ Esquema +".DRPT_INTERCAMBIOGLOBALSAR_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
} 

tuple Info_IntSa_T {string CODCASO; string VERSION; string CODSUBAREA;string FECHA; string TIPO;  int PERIODO; float  VALOR;} 
{Info_IntSa_T}Info_IntSa = 
{<CodCaso,Version,Codigo_Subarea[Sub],Fecha,"PRIMAL", Prd, round(V_IntSubArea[Sub][Prd]*1000000)/1000000>|
	Sub in Subarea,Prd in Periodos: Prd>=Pini && (TipoMod=="DPC" || TipoMod=="RDP")};
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL RACIONAMIENTO PARA PERIODO>=PINI�����������������������������������������������������������������������|*/
string  SQL_BorrarRac;	
execute BorrarRac{
	SQL_BorrarRac="DELETE FROM "+ Esquema +".DRPT_RACIONAMIENTOSUBAREA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
} 

tuple Racionamientos {string CODCASO; string VERSION; string CODSUBAREA;string FECHA; string TIPO;  int PERIODO; float  VALOR;} 
{Racionamientos} RacionaSubArea = 
{<CodCaso,Version,Codigo_Subarea[Sub],Fecha,"PRIMAL", Prd, round(V_RacionamientoSubArea[Sub][Prd]*1000000)/1000000>|
	Sub in Subarea,Prd in Periodos: Prd>=Pini};
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|�����������������������������������������������������������PROCESAMIENTO DE INFORMACI�N NECESARIO PARA ESCRIBIR EN LA TABLA DRPT_DATOSALIDA_RES�����������������������������������������������������������|*/
string CODSUBINDICE_Rec[Recursos][Periodos];					/*Vector tipo string que contiene el C�digo Num�rico del recurso y el periodo concatenados separados por coma*/
string CODSUBINDICE_Und[Unidades][Periodos];					/*Vector tipo string que contiene el C�digo Num�rico de la unidad y el periodo concatenados separados por coma*/
string t_Texto[Periodos];										/*Vector tipo string que contiene los periodos expresados como texto*/
string Rec_Und[Unidades];										/*Vector tipo string que entrega el recurso al cual pertenece la unidad*/

execute CodSubindice{
  for (var Tcod in Periodos){
    t_Texto[Tcod]=Tcod;
  	for(var RCod in Recursos){
  	  	CODSUBINDICE_Rec[RCod][Tcod]=Numero_Rec[RCod]+","+Tcod;
  	}
	for(var Ucod in Unidades){
  	  	CODSUBINDICE_Und[Ucod][Tcod]=Numero_Und[Ucod]+","+Tcod;
  	}
  } 
  for (var R_U in RecursoUnidades){
  		Rec_Und[R_U.UNIDAD]=R_U.RECURSO;  
  }
}

float Arr_Mod[Rec_Termicos][Periodos];
execute ArranqueModelo{
	for (var RTm in Rec_Termicos){
		for(var tm in tP){
			Arr_Mod[RTm][tm]==0;
			if(tm==Pini){
				if(TipoMod=="PID"){
					if(B_OnOff_RecT[RTm][tm]>0 && B_Arranque[RTm][tm]>0){Arr_Mod[RTm][tm]=B_Arranque[RTm][tm];}
				}
				else{
					if(B_MC_On[RTm][tm]>0 && GenRecT_t_1[RTm]<0.0001 && B_MC_Arr[RTm][tm]>0){Arr_Mod[RTm][tm]=B_MC_Arr[RTm][tm];}
				}
			}
			else{
				if(TipoMod=="PID"){
					if(B_OnOff_RecT[RTm][tm]>0 && B_OnOff_RecT[RTm][tm-1]==0 && B_Arranque[RTm][tm]>0){Arr_Mod[RTm][tm]=B_Arranque[RTm][tm];}
				}
				else{
					if(B_MC_On[RTm][tm]>0 && B_MC_On[RTm][tm-1]==0 && B_MC_Arr[RTm][tm]>0){Arr_Mod[RTm][tm]=B_MC_Arr[RTm][tm];}
				}			
			}
		}
	}
}
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|������������������������������������������ESCRITURA DE INFORMACI�N DE LOS RECURSOS QUE TUVIERON ARRANQUE RESPECTO A LA GENERACION MAYOR A CERO PARA PERIODO>=PINI�����������������������������������������|*/
string  SQL_BorrarArr;
execute BorrarArr{	
	SQL_BorrarArr="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='RGAQ' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
}


tuple Info_Arr_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_Arr_T}Info_Arr = 
{<CodCaso,Version,"RGAQ",Fecha,"PRIMAL",CODSUBINDICE_Rec[RT][t],Arr_Mod[RT][t],Numero_Rec[RT],t_Texto[t],"0","0","0","0","0">|
	RT in Rec_Termicos,t in Periodos: t>=Pini && Arr_Mod[RT][t]>0};   
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|��������������������������������������������ESCRITURA DE INFORMACI�N DE LOS RECURSOS QUE TUVIERON ARRANQUE RESPECTO A LA GENERACION EN FIRME PARA PERIODO>=PINI�������������������������������������������|*/
string  SQL_BorrarArrF;
execute BorrarArrF{	
	SQL_BorrarArrF="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='RGAQF' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
}


tuple Info_ArrF_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_ArrF_T}Info_ArrF = 
{<CodCaso,Version,"RGAQF",Fecha,"PRIMAL",CODSUBINDICE_Rec[RT][t],B_Arranque[RT][t],Numero_Rec[RT],t_Texto[t],"0","0","0","0","0">|
	RT in Rec_Termicos,t in Periodos: t>=Pini && B_Arranque[RT][t]>0};   
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


/*|�������������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL ONOFF DE LOS RECURSOS  PARA PERIODO>=PINI�����������������������������������������������������������������|*/
string  SQL_BorrarOnR;
execute BorrarOnR{	
	SQL_BorrarOnR="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='RGON' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
} 

tuple Info_OnRT_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_OnRT_T}Info_OnRT = 
{<CodCaso,Version,"RGON",Fecha,"PRIMAL",CODSUBINDICE_Rec[RT][t],B_OnOff_RecT[RT][t],Numero_Rec[RT],t_Texto[t],"0","0","0","0","0">|
	RT in Rec_Termicos,t in Periodos: t>=Pini && B_OnOff_RecT[RT][t]>0};   
	
tuple Info_OnRH_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_OnRH_T}Info_OnRH = 
{<CodCaso,Version,"RGON",Fecha,"PRIMAL",CODSUBINDICE_Rec[RH][t],B_OnOff_Rec[RH][t],Numero_Rec[RH],t_Texto[t],"0","0","0","0","0">|
	RH in (Rec_Hidraulico union Rec_Solar union Rec_Eolico),t in Periodos: t>=Pini && B_OnOff_Rec[RH][t]>0}; 	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/
	

/*|�������������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL ONOFF DE LAS UNIDADES  PARA PERIODO>=PINI�����������������������������������������������������������������|*/
string  SQL_BorrarOnU;
execute BorrarOnU{	
	SQL_BorrarOnU="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='UGON' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
} 

tuple Info_OnUT_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_OnUT_T}Info_OnUT = 
{<CodCaso,Version,"UGON",Fecha,"PRIMAL",CODSUBINDICE_Und[UT][t],B_OnOff_UndT[UT][t],Numero_Und[UT],t_Texto[t],"0","0","0","0","0">|
	UT in Und_Termica,t in Periodos: t>=Pini && B_OnOff_UndT[UT][t]>0};   
	
tuple Info_OnUH_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_OnUH_T}Info_OnUH = 
{<CodCaso,Version,"UGON",Fecha,"PRIMAL",CODSUBINDICE_Und[UH][t],B_OnOff_Und[UH][t],Numero_Und[UH],t_Texto[t],"0","0","0","0","0">|
	UH in (Und_Hidraulica union Und_Solar union Und_Eolica),t in Periodos: t>=Pini && B_OnOff_Und[UH][t]>0}; 	
	
tuple Info_OnUm_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_OnUm_T}Info_OnUm = 
{<CodCaso,Version,"UGON",Fecha,"PRIMAL",CODSUBINDICE_Und[Um][t],B_OnOff_UMenor[Um][t],Numero_Und[Um],t_Texto[t],"0","0","0","0","0">|
	Um in Und_noCentral,t in Periodos: t>=Pini && B_OnOff_UMenor[Um][t]>0}; 	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL TIEMPO EN LINEA EN CADA PERIODO PARA UNIDADES T�RMICAS����������������������������������������������������������|*/
string  SQL_BorrarTLU;
execute BorrarTLU{	
	SQL_BorrarTLU="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='UGTMON' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
} 

tuple Info_TLU_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_TLU_T}Info_TLU = 
{<CodCaso,Version,"UGTMON",Fecha,"PRIMAL",CODSUBINDICE_Und[UT][t],T_Linea_Post[Rec_Und[UT]][t],Numero_Und[UT],t_Texto[t],"0","0","0","0","0">|
	UT in Und_Termica,t in Periodos: t>=Pini && T_Linea_Post[Rec_Und[UT]][t]>0}; 
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|����������������������������������������������������������ESCRITURA DE INFORMACI�N DEL TIEMPO FUERA DE LINEA EN CADA PERIODO PARA UNIDADES T�RMICAS�������������������������������������������������������|*/
string  SQL_BorrarTFLU;
execute BorrarTFLU{	
	SQL_BorrarTFLU="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='UGTMOF' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
} 

tuple Info_TFLU_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_TFLU_T}Info_TFLU = 
{<CodCaso,Version,"UGTMOF",Fecha,"PRIMAL",CODSUBINDICE_Und[UT][t],T_FLinea_Post[Rec_Und[UT]][t],Numero_Und[UT],t_Texto[t],"0","0","0","0","0">|
	UT in Und_Termica,t in Periodos: t>=Pini && T_FLinea_Post[Rec_Und[UT]][t]>0}; 
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������������������������������ESCRITURA DE INFORMACI�N PARA LA FUNCION OBJETIVO�����������������������������������������������������������������������������|*/
string  SQL_BorrarFO;
execute BorrarFO{
	SQL_BorrarFO="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='FUNOBJ'";
}

tuple Info_FOp_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_FOp_T}Info_FOp = 
{<CodCaso,Version,"FUNOBJ",Fecha,"PRIMAL","0",CostoDespachoIni+F_Despacho,"0","0","0","0","0","0","0">}; 

tuple Info_FOd_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_FOd_T}Info_FOd = 
{<CodCaso,Version,"FUNOBJ",Fecha,"DUAL","0",CostoDespachoIni+F_Despacho,"0","0","0","0","0","0","0">};
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�����������������������������������������������������������������������������ESCRITURA DE INFORMACI�N PARA CONDICIONES FINALES�����������������������������������������������������������������������������|*/	
string  SQL_BorrarCF;
execute BorrarCF{
	SQL_BorrarCF="DELETE FROM "+ Esquema +".DRPT_CONDICINIXUNI_BAS WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND TIPOCOND='F' AND PERIODO>=" + Pini;	
} 	
	
tuple Info_CF_T{string CODCASO; string VERSION;string FECHA; string CODRECURSO; int PERIODO; string TIPOCOND;				
				string ESTADOPINI1; int BLOQUESPINI1; string CONFENTRADA; string CONFSALIDA; int TAPUBLICAR;
				int TDISPPINI1; int NARRANQUESPINI1; int TCEPENDIENTE; int TL; int TFL;}

{Info_CF_T} Info_CF =
{<CodCaso,Version,Fecha,Codigo_Rec[RT],t,"F",Est[RT][t],u_DN[RT][t]+u_UP[RT][t],c_UP[RT][t],c_DN[RT][t],Publicacion_Post[RT][t],TDisp_Post[RT][t],nArranques_Post[RT][t],T_Pend_CE[RT][t],T_Linea_Post[RT][t],T_FLinea_Post[RT][t]>|
	RT in Rec_Termicos, t in Periodos:  t>=Pini && (TipoMod=="RDP")};  	
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/

/*|������������������������������������������������������������������������ESCRITURA DE INFORMACI�N PARA CARGA ESTABLE EN EL PERIODO�������������������������������������������������������������������������|*/
string  SQL_BorrarCE;
execute BorrarCE{	
	SQL_BorrarCE="DELETE FROM "+ Esquema +".DRPT_DATOSALIDA_RES WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND CODVARIABLE='RGCE' AND CAST(SUBINDICE2 AS INTEGER)>=" + Pini;
}

tuple Info_CE_T {	string CODCASO; string VERSION; string CODVARIABLE; string FECHA; string TIPO; string CODSUBINDICE; float VALOR; string SUBINDICE1;string SUBINDICE2;string SUBINDICE3;
					string SUBINDICE4;string SUBINDICE5;string SUBINDICE6;string SUBINDICE7;} 
{Info_CE_T}Info_CE = 
{<CodCaso,Version,"RGCE",Fecha,"PRIMAL",CODSUBINDICE_Rec[RT][t],Tiene_CE[RT][t],Numero_Rec[RT],t_Texto[t],"0","0","0","0","0">|
	RT in Rec_Termicos,t in Periodos: t>=Pini && Tiene_CE[RT][t]>0 && V_GenFirme[RT][t]>0.00001};  
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


/*|�������������������������������������������������������������������������������������ESCRITURA DE INFORMACI�N DEL MODELO 1��������������������������������������������������������������������������������|*/
string  SQL_BorrarMod1; string  SQL_Mod1A; string  SQL_Mod1B; string  SQL_Mod1C;

execute BorrarMod1{													/*Se borra solamente la informaci�n de las unidades t�rmicas*/
	SQL_Mod1A="DELETE FROM "+ Esquema +".DRPT_RAMPASUNIDAD_BAS WHERE CODCASO='" + CodCaso + "' AND VERSION='"+ Version +"' AND PERIODO>=" + Pini;
	SQL_Mod1B=" AND CODUNIDAD IN (SELECT DISTINCT U.CODUNIDAD FROM "+ Esquema +".DRPT_UNIDADGENERACION_BAS U, "+ Esquema +".DRPT_RECURSOGENERACION_BAS R WHERE U.CODCASO='" + CodCaso +"' AND R.CODCASO=U.CODCASO";
	SQL_Mod1C=" AND U.VERSION='"+ Version +"' AND R.VERSION=U.VERSION AND U.ESTADO='ACTIVO' AND U.CODRECURSO=R.CODRECURSO AND R.ESTADO='ACTIVO' AND R.DESPACHOCENTRAL='S' AND R.TIPO LIKE 'T%' AND R.TIPO<>'TI')";
	SQL_BorrarMod1=SQL_Mod1A+SQL_Mod1B+SQL_Mod1C;					
} 	

tuple Info_Mod1_T{string CODCASO; string VERSION; string CODUNIDAD;string FECHA; int PERIODO; float  VALOR;}
{Info_Mod1_T} Info_Mod1 =
{<CodCaso,Version,Codigo_Und[Und],Fecha, Prd, round((V_GenUndRampaDR[Und][Prd]+V_GenUndRampaUR[Und][Prd])*1000000)/1000000>|
	Und in Und_Termica,Prd in Periodos: Prd>=Pini};	   
/*|__________________________________________________________________________________________________________________________________________________________________________________________________________|*/


