using System;
using System.Collections.Generic;
using RabbitMQ.Client;
using System.Text;

namespace WorkerOpl
{
    public class Enqueue
    {
        private String cola;
        private String server;

        public string Cola { get => cola; set => cola = value; }
        public string Server { get => server; set => server = value; }

        public Enqueue(String cola, String server)
        {
            this.server = server;
            this.cola = cola;
        }

        public Enqueue(String cola) : this(cola, "localhost")
        { }

        public Enqueue() : this("cola") { }

        public void add(String message)
        {
            var factory = new ConnectionFactory() { HostName = server };

            using (var connection = factory.CreateConnection())
            {
                using (var channel = connection.CreateModel())
                {
                    channel.QueueDeclare(queue: cola,
                                 durable: true,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);


                    var body = Encoding.UTF8.GetBytes(message);

                    var properties = channel.CreateBasicProperties();
                    properties.Persistent = true;

                    channel.BasicPublish(exchange: "",
                                    routingKey: cola,
                                    basicProperties: properties,
                                    body: body);
                }
            }
        }
    }
}
