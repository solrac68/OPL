using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ApiDespachoIdeal.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;
using System.Text;
using System.Globalization;

namespace ApiDespachoIdeal.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OplController : Controller
    {
        private readonly IConfiguration _configuration = null;
        private readonly String SERVER = null;
        private readonly String COLAENTRANTE = null;


        public OplController(IConfiguration configuration)
        {
            this._configuration = configuration;
            SERVER = _configuration["brokerserver"];
            COLAENTRANTE = _configuration["cola"];
        }

        [HttpPost]
        public void Post([FromBody] DataOpti value)
        {
            Enqueue enqueue = new Enqueue(COLAENTRANTE, SERVER);
            var message = GetMessage(value);
            enqueue.add(message);
        }

        [HttpGet]
        public IEnumerable<DataOpti> Get()
        {
            var rng = new Random();

            return Enumerable.Range(1, 5).Select(index => new DataOpti
            {
                FileId = DateTime.Now.Ticks.ToString(),
                JobMRID = DateTime.Now.Ticks.ToString(),
                CodCaso = DateTime.Now.Millisecond.ToString(),
                Proceso = "Proceso: " + rng.Next(-20, 55).ToString(),
                FechaOperativa = DateTime.Now
            })
            .ToArray();
        }

        private static string GetMessage(DataOpti value)
        {
            var fechaOperativa = value.FechaOperativa.ToString("s");
            var fechaEjecucion = value.FechaEjecucion.ToString("s");
            var mensaje = String.Format("{0},{1},{2},{3},{4},{5}",
                value.FileId,value.JobMRID,value.CodCaso,value.Proceso,fechaOperativa, fechaEjecucion);

            return mensaje;
        }

    }
}