using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;

namespace WorkerOpl
{
    class Dequeue
    {
        readonly String host = null;
        readonly String cola = null;
        readonly int portQueue = 0;
        readonly String userQueue = null;
        readonly String passQueue = null;


        public event EventHandler<String> mensaje;
        public Dequeue(String host, String cola, string userQueue, string passQueue, int portQueue)
        {
            this.host = host;
            this.cola = cola;
            this.userQueue = userQueue;
            this.passQueue = passQueue;
            this.portQueue = portQueue;
        }

        public Dequeue(String cola) : this("localhost", cola,"guest","guest",5672) { }

        public Dequeue():this("colaInputOpl")
        {}

        public async Task CreateListenerQueue(CancellationToken stoppingToken)
        {
            var factory = new ConnectionFactory() { HostName = this.host, UserName= this.userQueue, Password= this.passQueue, Port= this.portQueue};
            using (var connection = factory.CreateConnection())
            {
                using (var channel = connection.CreateModel())
                {
                    channel.QueueDeclare(queue: this.cola,
                                            durable: true,
                                            exclusive: false,
                                            autoDelete: false, // era false
                                            arguments: null);

                    channel.BasicQos(prefetchSize: 0, prefetchCount: 1, global: false);

                    var consumer = new EventingBasicConsumer(channel);

                    consumer.Received += (model, ea) =>
                    {
                        var body = ea.Body;
                        var message = Encoding.UTF8.GetString(body);

                        mensaje?.Invoke(this, message);

                        channel.BasicAck(deliveryTag: ea.DeliveryTag, multiple: false);

                    };

                    channel.BasicConsume(queue: this.cola,
                                            autoAck: false, // era false
                                            consumer: consumer);

                    while (!stoppingToken.IsCancellationRequested && channel.IsOpen)
                    {
                        await Task.Delay(5000, stoppingToken);
                    }
                }

            }
        }



    }
}
