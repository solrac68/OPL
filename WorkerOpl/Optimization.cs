using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace WorkerOpl
{
    sealed class Optimization
    {
        private static readonly Lazy<Optimization>
            lazy =
            new Lazy<Optimization>(() => new Optimization());

        public static Optimization Instance { get { return lazy.Value; } }


        private Optimization() { }


        public string ARCHIVO { get; set; }
        public string DATA { get; set; }
        public string DATADIR { get; set; }

        private void cambio(String codi, String codf, String veri, String verf)
        {
            string text = System.IO.File.ReadAllText(String.Format("{0}/{1}", DATADIR, DATA));
            text = text.Replace(codi, codf);
            text = text.Replace(veri, verf);
            System.IO.File.WriteAllText(String.Format("{0}/{1}", DATADIR, DATA), text);
        }

        public String Execute(string codCaso, string version)
        {
            cambio("<codcaso>", codCaso, "<version>", version);

            // Se inicia
            Process p = new Process();
            p.StartInfo.FileName = "oplrun.exe";
            p.StartInfo.Arguments = String.Format("{0}/{1}", DATADIR, ARCHIVO);
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.RedirectStandardOutput = true;
            p.Start();
            string output = String.Format("CodCaso: {0}, Version: {1}\n", codCaso, version) + p.StandardOutput.ReadToEnd();
            p.WaitForExit();
            p.Dispose();

            cambio(codCaso, "<codcaso>", version, "<version>");

            return output;
        }

    }
}
