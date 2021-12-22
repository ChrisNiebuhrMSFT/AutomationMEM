using System;

namespace _04_OOP
{
    class Program
    {
        static void Main(string[] args)
        {
            //Ein Auto und ein Motorrad Objekt erzeugen
            Auto a1 = new Auto("BMW", 4); 
            Motorrad m1 = new Motorrad("Ducati");
            Array arr; 
            Fahrzeug[] fahrzeuge = { a1, m1 }; //Ein Fahrzeug Array erzeugen (Fahrzeug ist die Basisklasse zu Auto und Motorrad)

            foreach (Fahrzeug f in fahrzeuge)
            {
                Console.WriteLine(f.Hersteller);
                f.Beschleunigen(); //Hier wird immer die korrekte Methode verwendet (Für Auto und Motorrad) Dieses verhalten nennt man auch Polymorphie
            }

            //Hier folgt ein weiteres Beispiel (Calculator und Calculator2 implementieren beide das IAddable Interface
            Calculator calc1 = new Calculator();
            Calculator2 calc2 = new Calculator2();

            IAddable[] AddableObjects = { calc1, calc2 }; //Daher können sie hier in einem IAddable Array zusammengefasst werden
            
            foreach(var ao in AddableObjects)
            {
                Console.WriteLine(ao.Add(1,2)); 
            }

        }
    }
}
