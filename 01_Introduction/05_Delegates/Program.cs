using System;

namespace _05_Delegates
{
    class Program
    {
        public delegate int Calc(int a, int b, string opName); //Delegate sind sichere Methodenzeiger. In diesem Beispiel wird ein Delegat definiert, der auf Methoden zeigen kann
        //die einen int Zurückgeben, zwei Integer und einen String entgegennehmen. 


        //Hier wird ein Delegat erzeugt, welches einen int zurückgibt und zweit Integer als Parameter entgegennehmen kann
        public delegate int Calc1(int a, int b);

        static void Main(string[] args)
        {
            Calc c1 = Addieren; //Zuweiung der Methode Addieren an das Calc Delegat c1
            Calc c2 = Multiplizieren;
            Calc c3 = delegate (int a, int b, string opName) //Anonymen Methode
            {
                Console.WriteLine(opName);
                return a - b;
            };

            //Lambda-Ausdruck
            Calc c4 = (a, b, opName) =>
            {
                Console.WriteLine(opName);
                return a / b;
            };


            string[] opNames = { "Addieren", "Multiplizieren", "Subtrahieren", "Dividieren" };
            int counter = 0;

            //Alle delegate in einem Array zusammenfassen
            Calc[] cArr = { c1, c2, c3, c4 };

            //Alle delegate in einer Schleifen durchlaufen und ausführen
            foreach (var c in cArr)
            {
                Console.WriteLine(c(10, 5, opNames[counter++]));

            }


            Calc1 calc = (a, b) => a + b;

            Console.WriteLine(calc(5, 6));

            //Beispiele für die Verwendung der Func Delegate
            Func<int, int, int> add = (a, b) => a + b;

            Console.WriteLine(add(6,7)) ;

            Func<int, int, bool> compare = (a, b) => a > b;

            Console.WriteLine(compare(5,6));

            Func<string, string, string> ToUpperConcat = (s1, s2) => (s1 + s2).ToUpper();

            Console.WriteLine(ToUpperConcat("C#", " macht spass"));


        }


        static int Addieren(int a, int b, string opName)
        {
            Console.WriteLine(opName);
            return a + b;
        }

        static int Multiplizieren(int a, int b, string opName)
        {
            Console.WriteLine(opName);
            return a * b;
        }

    }

}
