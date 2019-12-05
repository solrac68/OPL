/*=========================================================================================================================================================================================================================================================
													 __________________________________________________________________________________
									                                |                                                                                  |
													| CONTROL DE FLUJO PARA LA EJECUCIÓN DEL MODELO PROG_REC Y EL CÁLCULOD EL MARGINAL |
													|                                                                                  |
									                                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯													      
===========================================================================================================================================================================================================================================================*/

main{												/*El comando Main indica que se va a realizar un control de flujo de otros modelos, en este caso el modelo Prog_Rec*/

/*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯SOLUCIÓN DEL MODELO PROG_REC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*/  
	var FuenteModelo = new IloOplModelSource("ProgRec.mod");		/*Se indica cual va a ser la fuente del modelo, para este caso es lo contenido en el archivo ProgRec.mod*/ 	
 	var DefModelo= new IloOplModelDefinition (FuenteModelo);  				/*Se realiza la definición del modelo en función de la variable que contiene la fuente*/			
 	var Cplex = new IloCplex();								/*Se crea un nuevo elemento de Cplex para poder especificar los diferentes parámetros que se desean para la ejecución del método*/ 	
 	  
	var ProgRecModel = new IloOplModel (DefModelo, Cplex); 					/*Se determina la relación entre el modelo definido y el elemento Cplex, este objeto es el modelo como tal y es el que se soluciona*/
	var FuenteDatos  = new IloOplDataSource ("Main.dat");					/*Se indica cual va a ser la fuente de datos del modelo, para este caso es lo contenido en el archivo ProgRec.dat*/
	
 	
 	ProgRecModel.addDataSource (FuenteDatos); 						/*Se adiciona la fuente de datos al objeto que representa el modelo*/
 	ProgRecModel.generate();								/*Se hace la generación del modelo*/									
 	
 	Cplex.exportModel("ArchivosLP\\ProgRec"+ProgRecModel.CodCaso+ProgRecModel.Version+".lp");	/*Se genera la matriz LP del modelo Prog_Rec*/
 	 	
  	Cplex.tilim=180;  Cplex.epgap=1E-40; Cplex.epagap=1E-40;  Cplex.epint=1E-40;  Cplex.mipemphasis=2;  Cplex.numericalemphasis=true;  	 Cplex.epmrk=0.99999;
  	
  		/*Construcción del archivo para escribir el marginal______________________*/
  		var ArchivoEscrituraMarg=new IloOplOutputFile("ArchivosLP\\EscrituraMarg"+ProgRecModel.CodCaso+ProgRecModel.Version+".dat");
 		ArchivoEscrituraMarg.write("");
		//ArchivoEscrituraMarg.writeln("DBConnection DRP(\"odbc\",\"odbc_e/TRABAJO/DRPTRB02\");");
		ArchivoEscrituraMarg.writeln("DBConnection DRPe(\"oracle11\",\"TRABAJO/DRPTRB02@RDSPCND8\");");
		ArchivoEscrituraMarg.writeln("Rec_Marginal=[];");
		//ArchivoEscrituraMarg.writeln("DBExecute(DRP,SQL_BorrarMar);");
		ArchivoEscrituraMarg.writeln("DBExecute(DRPe,SQL_BorrarMar);");
		//ArchivoEscrituraMarg.writeln("Info_Mar to DBUpdate(DRP,\"INSERT INTO " +ProgRecModel.Esquema+".DRPT_COSTOMARGINALRECURSO_RES(CODCASO,VERSION,FECHA,PERIODO,VALOR) VALUES(?,?,?,?,ROUND(?,5))\");");
		ArchivoEscrituraMarg.writeln("Info_Mar to DBUpdate(DRPe,\"INSERT INTO " +ProgRecModel.Esquema+".DRPT_COSTOMARGINALRECURSO_RES(CODCASO,VERSION,FECHA,PERIODO,VALOR) VALUES(:1,:2,:3,:4,ROUND(:5,5))\");");
		/*________________________________________________________________________*/
 	
 	
 	if(Cplex.solve()){									/*Se soluciona el modelo matématico contenido en el objeto ProgRecModel*/																														
/*|________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|*/ 	


	/*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯CREACIÓN DEL MODELO PARA EL CÁLCULO DEL MARGINAL¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*/
		var FuenteModeloLineal = new IloOplModelSource("ProgRecLineal.mod");	/*Se indica cual va a ser la fuente del modelo, para este caso es lo contenido en el archivo ProgRecLineal.mod*/
		var DefModeloLineal= new IloOplModelDefinition (FuenteModeloLineal); 				/*Se realiza la definición del modelo en función de la variable que contiene la fuente*/
		var CplexM = new IloCplex();									/*Se crea un nuevo elemento de CplexM para poder especificar los diferentes parámetros que se desean para la ejecución del método en el cálculo del marginal*/
		
		CplexM.tilim=180;  CplexM.epgap=1E-40; CplexM.epagap=1E-40;  CplexM.epint=1E-40;  CplexM.mipemphasis=2;  CplexM.numericalemphasis=true;  	
		var MargRecModel= new IloOplModel (DefModeloLineal, CplexM); 					/*Se determina la relación entre el modelo definido y el elemento CplexM*/
		MargRecModel.addDataSource (FuenteDatos); 							/*Se adiciona la fuente de datos al objeto que representa el modelo, es la misma fuente de datos ProgRec.dat*/
					
		MargRecModel.generate();									/*Se genera el modelo para el cálculo del marginal*/
	/*|________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|*/	


	/*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯FIJACIÓN DE LAS VARIABLES BINARIAS EN LA SOLUCIÓN DEL PROG_REC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*/	
		for(var tf in ProgRecModel.Periodos){								/*Esta rutina se encarga de fijar los límites superior e inferior (UB y LB) de las variables binarias del marginal en el valor de solución del modelo ProgRec.  
														SI SE CREA UNA  NUEVA VARIABLE BINARIA EN EL MODELO PROGREC HAY QUE INCLUIRLA EN ESTE CICLO*/
			for(var RH in ProgRecModel.Rec_Hidraulico){	MargRecModel.B_OnOff_Rec[ RH ][tf].UB=ProgRecModel.B_OnOff_Rec[ RH ][tf].solutionValue;MargRecModel.B_OnOff_Rec[ RH ][tf].LB=ProgRecModel.B_OnOff_Rec[ RH ][tf].solutionValue;}
			for(var RS in ProgRecModel.Rec_Solar){		MargRecModel.B_OnOff_Rec[ RS ][tf].UB=ProgRecModel.B_OnOff_Rec[ RS ][tf].solutionValue;MargRecModel.B_OnOff_Rec[ RS ][tf].LB=ProgRecModel.B_OnOff_Rec[ RS ][tf].solutionValue;}
			for(var RE in ProgRecModel.Rec_Eolico){		MargRecModel.B_OnOff_Rec[ RE ][tf].UB=ProgRecModel.B_OnOff_Rec[ RE ][tf].solutionValue;MargRecModel.B_OnOff_Rec[ RE ][tf].LB=ProgRecModel.B_OnOff_Rec[ RE ][tf].solutionValue;}

			for(var RT in ProgRecModel.Rec_Termicos){	MargRecModel.B_OnOff_RecT[ RT ][tf].UB=ProgRecModel.B_OnOff_RecT[ RT ][tf].solutionValue;MargRecModel.B_OnOff_RecT[ RT ][tf].LB=ProgRecModel.B_OnOff_RecT[ RT ][tf].solutionValue;
									MargRecModel.B_RampaUR[ RT ][tf].UB=ProgRecModel.B_RampaUR[ RT ][tf].solutionValue;MargRecModel.B_RampaUR[ RT ][tf].LB=ProgRecModel.B_RampaUR[ RT ][tf].solutionValue;
									MargRecModel.B_RampaDR[ RT ][tf].UB=ProgRecModel.B_RampaDR[ RT ][tf].solutionValue;MargRecModel.B_RampaDR[ RT ][tf].LB=ProgRecModel.B_RampaDR[ RT ][tf].solutionValue;
									MargRecModel.B_Arranque[ RT ][tf].UB=ProgRecModel.B_Arranque[ RT ][tf].solutionValue;MargRecModel.B_Arranque[ RT ][tf].LB=ProgRecModel.B_Arranque[ RT ][tf].solutionValue;
									MargRecModel.B_Parada[ RT ][tf].UB=ProgRecModel.B_Parada[ RT ][tf].solutionValue;MargRecModel.B_Parada[ RT ][tf].LB=ProgRecModel.B_Parada[ RT ][tf].solutionValue;
									MargRecModel.B_Arr_Caliente[ RT ][tf].UB=ProgRecModel.B_Arr_Caliente[ RT ][tf].solutionValue;MargRecModel.B_Arr_Caliente[ RT ][tf].LB=ProgRecModel.B_Arr_Caliente[ RT ][tf].solutionValue;
									MargRecModel.B_Arr_Tibio[ RT ][tf].UB=ProgRecModel.B_Arr_Tibio[ RT ][tf].solutionValue;MargRecModel.B_Arr_Tibio[ RT ][tf].LB=ProgRecModel.B_Arr_Tibio[ RT ][tf].solutionValue;
									MargRecModel.B_Arr_Frio[ RT ][tf].UB=ProgRecModel.B_Arr_Frio[ RT ][tf].solutionValue;MargRecModel.B_Arr_Frio[ RT ][tf].LB=ProgRecModel.B_Arr_Frio[ RT ][tf].solutionValue;
									MargRecModel.B_Par_Normal[ RT ][tf].UB=ProgRecModel.B_Par_Normal[ RT ][tf].solutionValue;MargRecModel.B_Par_Normal[ RT ][tf].LB=ProgRecModel.B_Par_Normal[ RT ][tf].solutionValue;
									MargRecModel.B_Par_Especial[ RT ][tf].UB=ProgRecModel.B_Par_Especial[ RT ][tf].solutionValue;MargRecModel.B_Par_Especial[ RT ][tf].LB=ProgRecModel.B_Par_Especial[ RT ][tf].solutionValue;
									MargRecModel.B_MC_On[RT][tf].UB=ProgRecModel.B_MC_On[RT][tf].solutionValue;MargRecModel.B_MC_On[RT][tf].LB=ProgRecModel.B_MC_On[RT][tf].solutionValue;
									MargRecModel.B_MC_Arr[RT][tf].UB=ProgRecModel.B_MC_Arr[RT][tf].solutionValue;MargRecModel.B_MC_Arr[RT][tf].LB=ProgRecModel.B_MC_Arr[RT][tf].solutionValue;
									MargRecModel.B_MC_Par[RT][tf].UB=ProgRecModel.B_MC_Par[RT][tf].solutionValue;MargRecModel.B_MC_Par[RT][tf].LB=ProgRecModel.B_MC_Par[RT][tf].solutionValue;
									MargRecModel.B_MC_Arr_Caliente[RT][tf].UB=ProgRecModel.B_MC_Arr_Caliente[RT][tf].solutionValue;MargRecModel.B_MC_Arr_Caliente[RT][tf].LB=ProgRecModel.B_MC_Arr_Caliente[RT][tf].solutionValue;
									MargRecModel.B_MC_Arr_Tibio[RT][tf].UB=ProgRecModel.B_MC_Arr_Tibio[RT][tf].solutionValue;MargRecModel.B_MC_Arr_Tibio[RT][tf].LB=ProgRecModel.B_MC_Arr_Tibio[RT][tf].solutionValue;
									MargRecModel.B_MC_Arr_Frio[RT][tf].UB=ProgRecModel.B_MC_Arr_Frio[RT][tf].solutionValue;MargRecModel.B_MC_Arr_Frio[RT][tf].LB=ProgRecModel.B_MC_Arr_Frio[RT][tf].solutionValue;}													
			for(var BF in ProgRecModel.BloquesFactibles){	MargRecModel.B_Ufact[ BF ][tf].UB=ProgRecModel.B_Ufact[ BF ][tf].solutionValue;MargRecModel.B_Ufact[ BF ][tf].LB=ProgRecModel.B_Ufact[ BF ][tf].solutionValue;}		
			for(var RiEsp in ProgRecModel.RecInfact_Esp){	MargRecModel.B_uFact_min[ RiEsp ][tf].UB=ProgRecModel.B_uFact_min[ RiEsp ][tf].solutionValue;MargRecModel.B_uFact_min[ RiEsp ][tf].LB=ProgRecModel.B_uFact_min[ RiEsp ][tf].solutionValue;
									MargRecModel.B_uInfact[ RiEsp ][tf].UB=ProgRecModel.B_uInfact[ RiEsp ][tf].solutionValue;MargRecModel.B_uInfact[ RiEsp ][tf].LB=ProgRecModel.B_uInfact[ RiEsp ][tf].solutionValue;
									MargRecModel.B_uFact_max[ RiEsp ][tf].UB=ProgRecModel.B_uFact_max[ RiEsp ][tf].solutionValue;MargRecModel.B_uFact_max[ RiEsp ][tf].LB=ProgRecModel.B_uFact_max[ RiEsp ][tf].solutionValue;}																
			for(var I_UR in ProgRecModel.Interv_UR){	MargRecModel.B_UR[ I_UR ][tf].UB=ProgRecModel.B_UR[ I_UR ][tf].solutionValue;MargRecModel.B_UR[ I_UR ][tf].LB=ProgRecModel.B_UR[ I_UR ][tf].solutionValue;}		
			for(var I_DR in ProgRecModel.Interv_DR){	MargRecModel.B_DR[ I_DR ][tf].UB=ProgRecModel.B_DR[ I_DR ][tf].solutionValue;MargRecModel.B_DR[ I_DR ][tf].LB=ProgRecModel.B_DR[ I_DR ][tf].solutionValue;}		
			for(var R_DRp in ProgRecModel.RT_DRPrima){	MargRecModel.B_DR_Prima[ R_DRp ][tf].UB=ProgRecModel.B_DR_Prima[ R_DRp ][tf].solutionValue;MargRecModel.B_DR_Prima[ R_DRp ][tf].LB=ProgRecModel.B_DR_Prima[ R_DRp ][tf].solutionValue;
									MargRecModel.B_uDisp[ R_DRp ][tf].UB=ProgRecModel.B_uDisp[ R_DRp ][tf].solutionValue;MargRecModel.B_uDisp[ R_DRp ][tf].LB=ProgRecModel.B_uDisp[ R_DRp ][tf].solutionValue;}
			for(var R_Urp in ProgRecModel.RT_URPrima){	MargRecModel.B_UR_Prima[ R_Urp ][tf].UB=ProgRecModel.B_UR_Prima[ R_Urp ][tf].solutionValue;MargRecModel.B_UR_Prima[ R_Urp ][tf].LB=ProgRecModel.B_UR_Prima[ R_Urp ][tf].solutionValue;}
									MargRecModel.B_uMinT[ R_Urp ][tf].UB=ProgRecModel.B_uMinT[ R_Urp ][tf].solutionValue;MargRecModel.B_uMinT[ R_Urp ][tf].LB=ProgRecModel.B_uMinT[ R_Urp ][tf].solutionValue;
			for(var R_CE in ProgRecModel.RT_ModCE){		MargRecModel.B_bCE[ R_CE ][tf].UB=ProgRecModel.B_bCE[ R_CE ][tf].solutionValue;MargRecModel.B_bCE[ R_CE ][tf].LB=ProgRecModel.B_bCE[ R_CE ][tf].solutionValue;}
			for(var IH_UR in ProgRecModel.IntervRH_UR){	MargRecModel.B_RHUR[ IH_UR ][tf].UB=ProgRecModel.B_RHUR[ IH_UR ][tf].solutionValue;MargRecModel.B_RHUR[ IH_UR ][tf].LB=ProgRecModel.B_RHUR[ IH_UR ][tf].solutionValue;}
			for(var IH_DR in ProgRecModel.IntervRH_DR){	MargRecModel.B_RHDR[ IH_DR ][tf].UB=ProgRecModel.B_RHDR[ IH_DR ][tf].solutionValue;MargRecModel.B_RHDR[ IH_DR ][tf].LB=ProgRecModel.B_RHDR[ IH_DR ][tf].solutionValue;}
			for(var UH in ProgRecModel.Und_Hidraulica){	MargRecModel.B_OnOff_Und[ UH ][tf].UB=ProgRecModel.B_OnOff_Und[ UH ][tf].solutionValue;MargRecModel.B_OnOff_Und[ UH ][tf].LB=ProgRecModel.B_OnOff_Und[ UH ][tf].solutionValue;}
			for(var US in ProgRecModel.Und_Solar){		MargRecModel.B_OnOff_Und[ US ][tf].UB=ProgRecModel.B_OnOff_Und[ US ][tf].solutionValue;MargRecModel.B_OnOff_Und[ US ][tf].LB=ProgRecModel.B_OnOff_Und[ US ][tf].solutionValue;}
			for(var UE in ProgRecModel.Und_Eolica){		MargRecModel.B_OnOff_Und[ UE ][tf].UB=ProgRecModel.B_OnOff_Und[ UE ][tf].solutionValue;MargRecModel.B_OnOff_Und[ UE ][tf].LB=ProgRecModel.B_OnOff_Und[ UE ][tf].solutionValue;}
			for(var UNc in ProgRecModel.Und_noCentral){	MargRecModel.B_OnOff_UMenor[ UNc ][tf].UB=ProgRecModel.B_OnOff_UMenor[ UNc ][tf].solutionValue;MargRecModel.B_OnOff_UMenor[ UNc ][tf].LB=ProgRecModel.B_OnOff_UMenor[ UNc ][tf].solutionValue;}
			for(var UT in ProgRecModel.Und_Termica){	MargRecModel.B_OnOff_UndT[ UT ][tf].UB=ProgRecModel.B_OnOff_UndT[ UT ][tf].solutionValue;MargRecModel.B_OnOff_UndT[ UT ][tf].LB=ProgRecModel.B_OnOff_UndT[ UT ][tf].solutionValue;}
			
			/*Se hace lo mismo para las variables de holgura*/
			
			for(var Zu in ProgRecModel.Zonas_UndMinimas){	MargRecModel.Ho_Z_UndMin[ Zu ][tf].UB=ProgRecModel.Ho_Z_UndMin[ Zu ][tf].solutionValue;MargRecModel.Ho_Z_UndMin[ Zu ][tf].LB=ProgRecModel.Ho_Z_UndMin[ Zu ][tf].solutionValue;}
			for(var ZMW in ProgRecModel.Zonas_MWMinimos){	MargRecModel.Ho_Z_MWMin[ ZMW ][tf].UB=ProgRecModel.Ho_Z_MWMin[ ZMW ][tf].solutionValue;MargRecModel.Ho_Z_MWMin[ ZMW ][tf].LB=ProgRecModel.Ho_Z_MWMin[ ZMW ][tf].solutionValue;}
			for(var ZMx in ProgRecModel.Zonas_MWMaximos){	MargRecModel.Ho_Z_MWMax[ ZMx ][tf].UB=ProgRecModel.Ho_Z_MWMax[ ZMx ][tf].solutionValue;MargRecModel.Ho_Z_MWMax[ ZMx ][tf].LB=ProgRecModel.Ho_Z_MWMax[ ZMx ][tf].solutionValue;}		
																									
		}				
	/*|________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|*/


	/*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ESCRITURA DEL RECURSO MARGINAL DEL MODELO  PROG_REC¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*/
		writeln("<<<< Inicia Cálculo de Marginal para cada periodo   >>>>");		
												
		CplexM.exportModel("ArchivosLP\\MargProgRec"+ProgRecModel.CodCaso+ProgRecModel.Version+".lp");		/*Se genera la matriz LP del modelo del cálculo del marginal*/
		CplexM.solve();												/*Se resuelve el modelo MargRecModel ya convertido en un modelo lineal, esto se hace para poder utilizar la variable dual de la restricción BalanceGlobal*/
		
		
		
		var FuenteModAUX = new IloOplModelSource("EscrituraMarg.mod");			/*Se indica cual va a ser la fuente del modelo auxiliar para la escritura del marginal*/
		var DefModeloAUX= new IloOplModelDefinition(FuenteModAUX);  						/*Se realiza la definición del modelo auxiliar en función de la variable que contiene la fuente*/ 	
		var CplexAUX = new IloCplex();										/*Se crea un nuevo elemento de CplexAUX para poder utilizar el modelo auxiliar MargProgRec para escribir el marginal*/

		var MargAUX= new IloOplModel (DefModeloAUX, CplexAUX); 							/*Se determina la relación entre el modelo definido y el elemento CplexAUX*/
		
		var Datos_Aux=	new IloOplDataElements();								/*Se define una variable para almacenar los datos que se utilizan en MargProgRec.mod y que no están en MargProgRec.dat*/	
						Datos_Aux.Pini=ProgRecModel.Pini;										
						Datos_Aux.Pfin=ProgRecModel.Pfin;
						Datos_Aux.CodCaso=ProgRecModel.CodCaso;						
						Datos_Aux.Version=ProgRecModel.Version;
						Datos_Aux.Esquema=ProgRecModel.Esquema;
						Datos_Aux.Fecha=ProgRecModel.Fecha;					/*Se almacenan el valor del periodo inicial, final, código de caso y demás información necesario de ProgRec*/
		MargAUX.addDataSource (Datos_Aux);									/*Adiciona los datos que no se definen en el .dat al modelo auxiliar para escribir el marginal*/

		var FuenteDatosAUX  = new IloOplDataSource ("ArchivosLP\\EscrituraMarg"+ProgRecModel.CodCaso+ProgRecModel.Version+".dat");	/*Se indica cual va a ser la fuente de datos del modelo auxiliar para la escritura del marginal*/
		MargAUX.addDataSource (FuenteDatosAUX); 								/*Se adiciona la fuente de datos al objeto que representa el modelo auxiliar para la escritura del marginal*/	

		var Modif_Dat= 	MargAUX.dataElements;									/*Se define una variable para modificar los elementos del modelo auxiliar*/
			
				
		var HayMarginal= new Array(ProgRecModel.tP);								/*Bandera que indica si en un periodo se encontró un marginal o no. Es necesaria para saber si en un periodo no*/		
		var NumMarginal;											/*Número de periodos en los cuales se encontró el marginal*/
		NumMarginal=0;
		for(var taux in ProgRecModel.tP){						/*Se modifica el recurso marginal por periodo, en el archivo MargProgRec.dat se carga intencionalmente vacío*/
			//writeln("Dual "+MargRecModel.BalanceGlobal[taux].dual," Periodo"+taux);			
			HayMarginal[taux]=0;			
			for (var raux in MargRecModel.Recursos){ 						
				if(MargRecModel.BalanceGlobal[taux].dual==MargRecModel.OfertaRecurso[raux][taux] && HayMarginal[taux]==0){
					Modif_Dat.Rec_Marginal[taux]=MargRecModel.OfertaRecurso[raux][taux];
					//writeln("Marginal del periodo "+taux," es el recurso "+raux," Generacion : "+MargRecModel.V_Gen_Rec[raux][taux], "  Precio: "+MargRecModel.OfertaRecurso[raux][taux]);
					HayMarginal[taux]=1;
					NumMarginal=NumMarginal+HayMarginal[taux];
				}				
			}		
			for (var racux in MargRecModel.Subarea){ 				/*Eventualmente el marginal puede ser un racionamiento en una subárea*/				
				if(MargRecModel.BalanceGlobal[taux].dual==10*MargRecModel.CostoRacSubarea[racux][taux] && HayMarginal[taux]==0 && MargRecModel.V_RacSubAreaFO[racux][taux]+MargRecModel.V_Racionamiento[taux]>0.000001){  /*¡¡¡¡ DEBE SER COHERENTE CON LA PARTICIPACIÓN DEL RACIONAMIENTO EN LA FO DEL MODELO !!!!*/
					Modif_Dat.Rec_Marginal[taux]=MargRecModel.CostoRacSubarea[racux][taux];					
					//writeln("Marginal del periodo "+taux," es el recurso "+racux,"  Precio: "+MargRecModel.CostoRacSubarea[racux][taux]);
					HayMarginal[taux]=1;
					NumMarginal=NumMarginal+HayMarginal[taux];						
				}				
			}				
		}  		
		//writeln(NumMarginal);					
		if(NumMarginal<(ProgRecModel.Pfin-ProgRecModel.Pini+1)){											/*Si en algún periodo no se encontró el marginal entonces NumMarginal es menor a 24*/
		
				   /*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯CORRECCIÓN DEL MARGINAL¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*/
					/*Para algunos casos la estrategia del modelo lineal no encuentra un valor de marginal que corresponda al precio de oferta, por esto se hace una aproximación del marginal con un cálculo incrementando la demanda en todos los periodos
					simultáneamente.  Se encuentra entonces un marginal corregido para cada periodo, el cual será reemplazado por el que encuentre la estrategia del modelo lineal.*/
					   var CplexMP = new IloCplex();										/*Se crea un elemento cplex para poder parametrtizar la solución que se desea.*/
					   CplexMP.tilim=180;  CplexMP.epgap=1E-40; CplexMP.epagap=1E-40;  CplexMP.epint=1E-40;  CplexMP.mipemphasis=2;  CplexMP.numericalemphasis=true;  	 CplexMP.epmrk=0.99999;		

					   var MarginalPeriodos = new IloOplModel (DefModelo, CplexMP);		/*Se crea un nuevo modelo con las mismas fuentes del modelo ProgRec*/
					   MarginalPeriodos.addDataSource (FuenteDatos);
					   var DemModf = MarginalPeriodos.dataElements;				/*Se modifica la demanda del modelo original en todos los periodos, con un incremento de 0.1*/
					   for(var tdem in ProgRecModel.tP){DemModf.Demanda[tdem]=ProgRecModel.Demanda[tdem]+0.1;}
					   MarginalPeriodos.generate();
					   var WarmStart = new IloOplCplexVectors();  /*Se crea un objeto para dar un arranque tibio a los vectores de CPLEX*/					   					   
					   
					   WarmStart.attach(MarginalPeriodos.V_Gen_Rec,ProgRecModel.V_Gen_Rec.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_GenFirme,ProgRecModel.V_GenFirme.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_GenRampaDR,ProgRecModel.V_GenRampaDR.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_GenRampaUR,ProgRecModel.V_GenRampaUR.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_RacionamientoSubArea,ProgRecModel.V_RacionamientoSubArea.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_RacSubAreaFO,ProgRecModel.V_RacSubAreaFO.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_RacSubAreaProgramado,ProgRecModel.V_RacSubAreaProgramado.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_Racionamiento,ProgRecModel.V_Racionamiento.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_Gen_Und,ProgRecModel.V_Gen_Und.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_GenUndFirme,ProgRecModel.V_GenUndFirme.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_GenUndRampaDR,ProgRecModel.V_GenUndRampaDR.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_GenUndRampaUR,ProgRecModel.V_GenUndRampaUR.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_IntSubArea,ProgRecModel.V_IntSubArea.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.V_IntArea,ProgRecModel.V_IntArea.solutionValue);	
					   WarmStart.attach(MarginalPeriodos.B_OnOff_RecT,ProgRecModel.B_OnOff_RecT.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_RampaUR,ProgRecModel.B_RampaUR.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_RampaDR,ProgRecModel.B_RampaDR.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_Arranque,ProgRecModel.B_Arranque.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_Parada,ProgRecModel.B_Parada.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_Arr_Caliente,ProgRecModel.B_Arr_Caliente.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_Arr_Tibio,ProgRecModel.B_Arr_Tibio.solutionValue);					   
					   WarmStart.attach(MarginalPeriodos.B_Arr_Frio,ProgRecModel.B_Arr_Frio.solutionValue);					   					   
					   WarmStart.attach(MarginalPeriodos.B_Ufact,ProgRecModel.B_Ufact.solutionValue);					   					   					   
					   WarmStart.attach(MarginalPeriodos.B_uFact_min,ProgRecModel.B_uFact_min.solutionValue);					   					   					   					   
					   WarmStart.attach(MarginalPeriodos.B_uInfact,ProgRecModel.B_uInfact.solutionValue);					   					   					   					   					   
					   WarmStart.attach(MarginalPeriodos.B_uFact_max,ProgRecModel.B_uFact_max.solutionValue);				
					   WarmStart.attach(MarginalPeriodos.B_Par_Normal,ProgRecModel.B_Par_Normal.solutionValue);					   					   					   					   					   					   
					   WarmStart.attach(MarginalPeriodos.B_Par_Especial,ProgRecModel.B_Par_Especial.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_UR,ProgRecModel.B_UR.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_DR,ProgRecModel.B_DR.solutionValue);					   
					   WarmStart.attach(MarginalPeriodos.B_DR_Prima,ProgRecModel.B_DR_Prima.solutionValue);					   					   
					   WarmStart.attach(MarginalPeriodos.B_uDisp,ProgRecModel.B_uDisp.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_uMinT,ProgRecModel.B_uMinT.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_bCE,ProgRecModel.B_bCE.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_RHUR,ProgRecModel.B_RHUR.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_RHDR,ProgRecModel.B_RHDR.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_OnOff_Und,ProgRecModel.B_OnOff_Und.solutionValue);					   
					   WarmStart.attach(MarginalPeriodos.B_OnOff_UMenor,ProgRecModel.B_OnOff_UMenor.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_OnOff_UndT,ProgRecModel.B_OnOff_UndT.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_MC_On,ProgRecModel.B_MC_On.solutionValue);					   
					   WarmStart.attach(MarginalPeriodos.B_MC_Arr,ProgRecModel.B_MC_Arr.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_MC_Par,ProgRecModel.B_MC_Par.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_MC_Arr_Caliente,ProgRecModel.B_MC_Arr_Caliente.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_MC_Arr_Tibio,ProgRecModel.B_MC_Arr_Tibio.solutionValue);
					   WarmStart.attach(MarginalPeriodos.B_MC_Arr_Frio,ProgRecModel.B_MC_Arr_Frio.solutionValue);			   
			   		   writeln(WarmStart);
                       			   WarmStart.setVectors(CplexMP); 
					   CplexMP.solve();
					   
					   var OfeComp;
					   for(var taux0 in ProgRecModel.tP){		  							/*Se busca el recurso de menor precio de oferta que haya cambiado su generación.*/
						   OfeComp=99999999999;		
						   //writeln(taux0,";",MarginalPeriodos.Demanda[taux0],";",ProgRecModel.Demanda[taux0]);
						   for(var raux0 in ProgRecModel.Recursos){
						   	//writeln(taux0,";",raux0,";",MarginalPeriodos.V_Gen_Rec[raux0][taux0].solutionValue,";",ProgRecModel.V_Gen_Rec[raux0][taux0].solutionValue);								   		
							   if(Math.abs(MarginalPeriodos.V_Gen_Rec[raux0][taux0].solutionValue-ProgRecModel.V_Gen_Rec[raux0][taux0].solutionValue)>0.05 && ProgRecModel.OfertaRecurso[raux0][taux0]>0){	
							   /*La búsqueda se realiza solamente entre los recursos que ofertan precio, que son los que tienen rampas actualmente*/
								   if(ProgRecModel.OfertaRecurso[raux0][taux0]<=OfeComp && HayMarginal[taux0]==0){
									   Modif_Dat.Rec_Marginal[taux0]=ProgRecModel.OfertaRecurso[raux0][taux0];
									   OfeComp=ProgRecModel.OfertaRecurso[raux0][taux0];
									   //writeln("Marginal inicial del periodo "+taux0," es el recurso "+raux0,"  Precio: "+MargRecModel.OfertaRecurso[raux0][taux0]);
								   }						
							   }
						   }						   
					   }		
				   /*|________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|*/				
		}		
		writeln("<<<< Finaliza Cálculo de Marginal para cada periodo >>>>");
		MargAUX.generate();															/*Se genera el modelo para la escritura del marginal del marginal*/			
		CplexAUX.solve();   
		writeln("<<<< Inicia la escritura en base de datos           >>>>");
		MargAUX.postProcess(); 									/*Se ejecuta el modelo auxiliar para la escritura de la información del recurso marginal*/
		ProgRecModel.postProcess();											/*Se ejecuta el postproceso descrito en el obejto ProgRecModel, el posproceso corresponde al definido en el archivo ProgRec.mod*/		
		writeln("<<<< Finaliza la escritura en base de datos         >>>>");
		writeln("ESTADO_EJECUCION=OK");
		//writeln("ESTADO_EJECUCION=OK, Costo del Despacho: " + ProgRecModel.F_Despacho);
		//writeln("ESTADO_EJECUCION=OK, Costo del Despacho Ini: " + ProgRecModel.CostoDespachoIni);

		

	/*|________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|*/
		var Solucion;	
 			Solucion="Se encontró una solución óptima para el siguiente caso: \n \n"+ProgRecModel.CodCaso+" "+ProgRecModel.Descripcion+"\nCosto del Despacho:  $ "+(ProgRecModel.F_Despacho+ProgRecModel.CostoDespachoIni);			
 		
		var EstadoMod;
			EstadoMod="1";									
		
 			if(ProgRecModel.c_NO_Z==1){
 			  	var ZonasLimInfactible;	
 			  	ZonasLimInfactible="";
 			  						
 			  								
				for(var tz in ProgRecModel.Periodos){
	 				for(var Zuz in ProgRecModel.Zonas_UndMinimas){if(ProgRecModel.Ho_Z_UndMin[Zuz][tz].solutionValue>0)ZonasLimInfactible=ZonasLimInfactible+"Zona: "+Zuz+"   Periodo: "+tz+"   Unds Faltantes: "+ProgRecModel.Ho_Z_UndMin[Zuz][tz].solutionValue+"\n"}
					for(var ZMWz in ProgRecModel.Zonas_MWMinimos){if(ProgRecModel.Ho_Z_MWMin[ZMWz][tz].solutionValue>0)ZonasLimInfactible=ZonasLimInfactible+"Zona: "+ZMWz+"   Periodo: "+tz+"   MW Faltantes: "+ProgRecModel.Ho_Z_MWMin[ZMWz][tz].solutionValue+"\n"}
					for(var ZMxz in ProgRecModel.Zonas_MWMaximos){if(ProgRecModel.Ho_Z_MWMax[ZMxz][tz].solutionValue>0)ZonasLimInfactible=ZonasLimInfactible+"Zona: "+ZMxz+"   Periodo: "+tz+"   MAX Faltante: "+ProgRecModel.Ho_Z_MWMax[ZMxz][tz].solutionValue+"\n"}
  				}	
  				
  				if(ZonasLimInfactible!=""){
  					Solucion=Solucion+"\n\n |¯¯¯¯¯¯¯¯¯¯¯¯¯ DESPACHO INFACTIBLE ¯¯¯¯¯¯¯¯¯¯¯¯¯|\n\n"+ZonasLimInfactible+"\n|_____________________________________________________|";
  					EstadoMod="2";  											
    			}  							
 			}		
			
			var ArchivoFinalizaMain1= new IloOplOutputFile("ArchivosLog\\EstadoModelo"+ProgRecModel.CodCaso+ProgRecModel.Version+".txt");
			var ArchivoMensajeModelo1=new IloOplOutputFile("ArchivosLog\\MensajeModelo"+ProgRecModel.CodCaso+ProgRecModel.Version+".txt");
 			ArchivoFinalizaMain1.write(EstadoMod);	
			ArchivoMensajeModelo1.write(Solucion); 		
			ArchivoFinalizaMain1.close();	
			ArchivoMensajeModelo1.close();

			

	}
	else{	
			var NoSolucion;
			
 			NoSolucion="NO SE ENCONTRÓ UNA SOLUCIÓN ÓPTIMA PARA EL SIGUIENTE CASO: \n \n"+ProgRecModel.CodCaso+" "+ProgRecModel.Descripcion;	 			
 			
 			
 			var ArchivoFinalizaMain2= new IloOplOutputFile("ArchivosLog\\EstadoModelo"+ProgRecModel.CodCaso+ProgRecModel.Version+".txt");
			var ArchivoMensajeModelo2=new IloOplOutputFile("ArchivosLog\\MensajeModelo"+ProgRecModel.CodCaso+ProgRecModel.Version+".txt");
 			ArchivoFinalizaMain2.write("0");
			ArchivoMensajeModelo2.write(NoSolucion);	
			ArchivoFinalizaMain2.close();	
			ArchivoMensajeModelo2.close();

			writeln("ESTADO_EJECUCION=ERROR");							
	}
}