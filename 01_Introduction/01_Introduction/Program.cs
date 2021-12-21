using System; //Damit der jeweilige Namespace automatisch benutzt wird. 
using MyTest;
namespace _01_Introduction
{
    class Program
    {
        //void => Bedeutet kein Rückgabewert
        static void Main(string[] args) //Methode "Funktion, die zu einer Klasse/Object gehört" (aka Member-Function)
        {
            //"Fullqualified" Angabe inklusice Namensraum
            /* System.Console.WriteLine("Hello World!");
             Console.WriteLine("Noch eine weitere Zeile");*/
            MyTestClass test = new MyTestClass(); //Ein neues Objekt der Klasse TestClass erzeugen
            test.Ausgabe(); //Eine nicht-statische Methode am Objekt der Klasse aufrufen
            MyTestClass.Ausgabe2(); //Eine statische Methode direkt an der Klasse aufrufen


        }
    }

}

namespace MyTest //Einen eigenen Namespace definieren
{  
    public class MyTestClass
    {
        public void Ausgabe() //Eine nicht statische Methode definieren
        {
            Console.WriteLine("I am a non static Method");
        }

        public static void Ausgabe2() //Eine statische Methode mit dem Schlüsselwort static definieren
        {
            Console.WriteLine("I am a static Method");
        }
    }
}
