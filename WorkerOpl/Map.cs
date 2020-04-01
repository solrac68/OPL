using System;
using System.Collections.Generic;
using System.Text;

namespace WorkerOpl
{
    class Map
    {
        public static DataOpti StrToDataOpti(String mensaje)
        {
            String[] listMensaje = mensaje.Split(',');
            if(listMensaje == null || listMensaje.Length != 6)
            {
                throw new Exception("El mensaje no tiene el formato correcto");
            }

            return new DataOpti
            {
                FileId = listMensaje[0],
                JobMRID = listMensaje[1],
                CodCaso = listMensaje[2],
                Proceso = listMensaje[3],
                FechaOperativa = DateTime.Parse(listMensaje[4], null),
                FechaEncolamiento = DateTime.Parse(listMensaje[5], null),
                FechaFincalculo = DateTime.Now
            };

        }
        /// <summary>
        /// Se almacena en un dictionario el resultado del proceso de cálculo del OPL
        /// </summary>
        /// <param name="dataOpti">Información de entrada.</param>
        /// <param name="result">Resultado.</param>
        /// <param name="failed">Falló</param>
        /// <param name="error">Error</param>
        /// <param name="ok">Proceso exitoso</param>
        /// <returns></returns>
        public static Dictionary<string, object> DataOptiToDic(DataOpti dataOpti, String result, String failed, String error, String ok)
        {
            Dictionary<string, object> dictResponse = new Dictionary<string, object>();

            dictResponse.Add("codCaso", dataOpti.CodCaso);
            dictResponse.Add("jobMRID", dataOpti.JobMRID);
            dictResponse.Add("proceso", dataOpti.Proceso);
            dictResponse.Add("fechaOperativa", dataOpti.FechaOperativa.ToString("s"));
            dictResponse.Add("fechaFincalculo", dataOpti.FechaFincalculo.ToString("s"));
            dictResponse.Add("fileId", dataOpti.FileId);

            result = result.Replace("\n", string.Empty).Replace("\r", string.Empty).Replace("\u003C", string.Empty).Replace("\u003E", string.Empty);

            dictResponse.Add("result", result);

            if (result.Contains(ok))
            {
                dictResponse.Add("state", "OK");
            }
            else if (result.Contains(error))
            {
                dictResponse.Add("state", "ERROR");
            }
            else if (result.Contains(failed))
            {
                dictResponse.Add("state", "FAILED");
            }
            else
            {
                dictResponse.Add("State", "UNDETERMINATED");
            }

            return dictResponse;
        }
    }
}
