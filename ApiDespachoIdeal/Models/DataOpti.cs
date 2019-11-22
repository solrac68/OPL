using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiDespachoIdeal.Models
{
    /// <summary>
    /// Información básica para ls optimización y seguimiento del proceso.
    /// </summary>
    public class DataOpti
    {
        public string FileId { get; set; }
        public string JobMRID { get; set; }
        public string CodCaso { get; set; }
        public string Proceso { get; set; }
        public DateTime FechaOperativa { get; set; }
        public DateTime FechaEjecucion => DateTime.Now;
    }
}
