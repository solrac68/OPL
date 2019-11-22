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
    }
}
