using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _04_OOP
{
    /// <summary>
    /// Beschreibt die Eigenschaften eines Fahrzeugs
    /// </summary>
    public abstract class Fahrzeug //Aus abstraktren Klassen können nicht direkt Objekte erzeugt werden. 
    {
        public string Hersteller { get; } //Öffentliche Eigenschaft, die von außen nur lesend zugegriffen werden kann. 

        //Standardkonstruktor
        /// <summary>
        /// Standardkonstruktor
        /// </summary>
        public Fahrzeug() 
        {
            Console.WriteLine("Konstruktor von Fahrzeug wird aufgerufen");
            this.Hersteller = "Audi";
        }
        //Speziellem Konstruktor
        /// <summary>
        /// Spezieller Konstruktor
        /// </summary>
        /// <param name="hersteller">Hersteller des Fahrzeugs</param>
        public Fahrzeug(string hersteller)
        {
            this.Hersteller = hersteller;
        }

        public abstract void Beschleunigen();
    }

    public class Auto :Fahrzeug //Auto erbt die eigenschaften und Methoden von Fahrzeug 
    {
        public int Anzahlreifen { get;} 

        public Auto () :base()
        {
            Console.WriteLine("Konstruktor von Auto wird aufgerufen");
        }

        public Auto (string hersteller, int anzahlReifen): base(hersteller) //Zur Erzeugung eines Autos wird auch der Konstruktor von Fahrzeug verwendet (base Schlüsselwort)
        {
            this.Anzahlreifen = anzahlReifen;
        }


        public override void Beschleunigen()
        {
            Console.WriteLine("Ich beschleunige schnell");
        }

    }

    public class Motorrad : Fahrzeug
    {
        public Motorrad(string hersteller): base(hersteller)
        {

        }
        public override void Beschleunigen()
        {
            Console.WriteLine("Ich beschleunige schneller");
        }
    }
}
