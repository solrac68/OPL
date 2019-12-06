using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace WorkerOpl
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _configuration = null;
        private HttpClient client;
        private Dequeue dequeue;
        private readonly String _DATADIR = null;
        private readonly String _ARCHIVO = null;
        private readonly String _DATA = null;
        private readonly String _COLA = null;
        private readonly String _ERROR = null;
        private readonly String _FAILED = null;
        private readonly String _OK = null;
        private readonly String _COLARESULTADO = null;
        private readonly String _SERVER = null;
        private readonly String _USERQUEUE = null;
        private readonly String _PASSQUEUE = null;
        private readonly int _PORTQUEUE = -1;


        public Worker(ILogger<Worker> logger, IConfiguration configuration)
        {
            _logger = logger;
            this._configuration = configuration;
            this._DATADIR = _configuration["dir"];
            this._ARCHIVO = _configuration["main"];
            this._DATA = _configuration["data"];
            this._COLA = _configuration["cola"];
            this._COLARESULTADO = _configuration["colaresultado"];
            this._SERVER = _configuration["server"];
            this._ERROR = _configuration["error"];
            this._FAILED = _configuration["failed"];
            this._OK = _configuration["ok"];
            this._USERQUEUE = _configuration["userQueue"];
            this._PASSQUEUE = _configuration["passQueue"];
            this._PORTQUEUE = int.Parse(_configuration["portQueue"]);
        }

        public override Task StartAsync(CancellationToken cancellationToken)
        {
            client = new HttpClient();
            return base.StartAsync(cancellationToken);
        }

        public override Task StopAsync(CancellationToken cancellationToken)
        {
            client.Dispose();
            _logger.LogInformation("The service has been stopped...");
            return base.StopAsync(cancellationToken);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stoppingToken"></param>
        /// <returns></returns>
        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            dequeue = new Dequeue(this._SERVER, this._COLA,this._USERQUEUE, this._PASSQUEUE, this._PORTQUEUE);
            dequeue.mensaje += Dequeue_mensaje;
            await dequeue.CreateListenerQueue(stoppingToken);
        }

        private void Dequeue_mensaje(object sender, string e)
        {
            Dictionary<string, object> dictResponse = new Dictionary<string, object>();
            String jsonResponse;
            Enqueue enqueue;

            _logger.LogInformation("\n\n[x] Received {0}\n", e);

            DataOpti dataOpti = Map.StrToDataOpti(e);

            Optimization opt = Optimization.Instance;
            opt.ARCHIVO = this._ARCHIVO;
            opt.DATA = this._DATA;
            opt.DATADIR = this._DATADIR;

            String result = opt.Execute(dataOpti.CodCaso, dataOpti.Proceso);

            dataOpti.FechaFincalculo = DateTime.Now;

            dictResponse = Map.DataOptiToDic(dataOpti, result, this._FAILED, this._ERROR, this._OK);

            jsonResponse = JsonSerializer.Serialize<Dictionary<string, object>>(dictResponse);

            _logger.LogInformation(" [x] Resultados: \n{0}\n", jsonResponse);

            enqueue = new Enqueue(_COLARESULTADO, _SERVER, this._USERQUEUE, this._PASSQUEUE, this._PORTQUEUE);

            enqueue.add(jsonResponse);

        }
    }
}