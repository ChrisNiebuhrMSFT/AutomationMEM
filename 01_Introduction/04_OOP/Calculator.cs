using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _04_OOP
{
    /// <summary>
    /// Calculator Klasse, die das Interface IAddable implementiert
    /// </summary>
    public class Calculator : IAddable
    {
        public int Add(int a, int b)
        {
            return a + b; 
        }
    }
}
