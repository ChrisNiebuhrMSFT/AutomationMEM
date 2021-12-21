using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _04_OOP
{
    /// <summary>
    /// Calculator2 implementiert ebenfalls das IAddable Interface aber auf eine andere Weise als Calculator
    /// </summary>
    public class Calculator2 : IAddable
    {
        public int Add(int a, int b)
        {
            return a + b + 1;
        }
    }
}
