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
        readonly int portQueue = 0;
        readonly String userQueue = null;
        readonly String passQueue = null;

        public string Cola { get => cola; set => cola = value; }
        public string Server { get => server; set => server = value; }

        public Enqueue(String cola, String server, String userQueue, String passQueue, int portQueue)
        {
            this.server = server;
            this.cola = cola;
            this.portQueue = portQueue;
            this.userQueue = userQueue;
            this.passQueue = passQueue;
        }

        public Enqueue(String cola) : this(cola, "localhost","guest","guest", 5672)
        { }

        public Enqueue() : this("colaOutputOpl") { }

        public void add(String message)
        {
            var factory = new ConnectionFactory() { HostName = server, UserName = this.userQueue, Password = this.passQueue, Port = this.portQueue };

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
