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

namespace WorkerOpl
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _configuration = null;
        private HttpClient client;
        private Dequeue dequeue;
        private String _DATADIR = null;
        private String _ARCHIVO = null;
        private String _DATA = null;
        private String _COLA = null;
        

        public Worker(ILogger<Worker> logger, IConfiguration configuration)
        {
            _logger = logger;
            this._configuration = configuration;
            this._DATADIR = _configuration["dir"];
            this._ARCHIVO = _configuration["main"];
            this._DATA = _configuration["data"];
            this._COLA = _configuration["cola"];
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
            dequeue = new Dequeue(this._COLA);
            dequeue.mensaje += Dequeue_mensaje;
            await dequeue.CreateListenerQueue(stoppingToken);
        }

        private void Dequeue_mensaje(object sender, string e)
        {

            _logger.LogInformation(" [x] Received {0}\n", e);

            DataOpti dataOpti = Map.StrToDataOpti(e);

            Optimization opt = Optimization.Instance;
            opt.ARCHIVO = this._ARCHIVO;
            opt.DATA = this._DATA;
            opt.DATADIR = this._DATADIR;

            String result = opt.Execute(dataOpti.CodCaso, dataOpti.Proceso);

            dataOpti.FechaFincalculo = DateTime.Now;

            _logger.LogInformation(" [x] Codcaso: {0}", dataOpti.CodCaso);
            _logger.LogInformation(" [x] FechaEncolamiento: {0}", dataOpti.FechaEncolamiento.ToString("s"));
            _logger.LogInformation(" [x] FechaOperativa: {0}", dataOpti.FechaOperativa.ToString("s"));
            _logger.LogInformation(" [x] FechaFincalculo: {0}", dataOpti.FechaFincalculo.ToString("s"));
            _logger.LogInformation(" Resultados:\n {0}", result);

        }
    }
}