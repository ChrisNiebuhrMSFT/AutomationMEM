using System;

namespace _02_C_Sharp_Basics
{
    class Program
    {
        static void Main(string[] args)
        {
            //Jede Zeile wird in C# mit einem ; abgeschlossen
            string str = "Hallo Welt"; //Datentypen können explizit angegeben werden
            int zahl = 5;

            Console.WriteLine(str);
            Console.WriteLine(zahl);

            //Type inference
            var variable = 10; //Datentyp wird anhand der Zuweisung ermittelt
            Console.WriteLine(variable.GetType());

            //Definition eines Interger- Arrays
            int[] intarr = { 1, 2, 3, 4, 5 };

            //Beispiel zum Auslesen der Prozessinfos
            var procs = System.Diagnostics.Process.GetProcesses();

            foreach(var proc in procs)
            {
                Console.WriteLine($"Processname:{proc.ProcessName} - WorkingSet:{proc.WorkingSet64} Bytes");
            }

        }
    }


}
