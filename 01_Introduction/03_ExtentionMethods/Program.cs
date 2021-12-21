using System;
using System.Collections;
using System.Linq; //Language integrated Query (Extentionmethoden für IEnumerable IEumerable<T>

namespace _03_ExtentionMethods
{
    class Program
    {
        static void Main(string[] args)
        {
            string str1 = "Hallo";

            Console.WriteLine(str1.ToUpper());

            Console.WriteLine(str1.GiveFirst());

            int[] arr = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            var res = arr.Where(n => n > 5); //Verwendung einer Extentionmethod an einem Array-Datentyp

            foreach(var r in res)
                Console.WriteLine(r);

        }
    }

    //Beispiel zur Erzeugung einer eigenen Extentionmethod
    public static class MyStringExtension
    {
        public static string GiveFirst (this string str)
        {
            return "Huhu, ich bin eine String Extention";
        }
    }
}
