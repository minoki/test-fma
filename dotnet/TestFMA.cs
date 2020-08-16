using System;
using System.Diagnostics;

class Program
{
    static string HexFloat(double x)
    {
        if (x == 0.0)
        {
            return Double.IsNegative(x) ? "-0x0p0" : "0x0p0";
        }
        else if (Double.IsFinite(x))
        {
            int e = Math.ILogB(x);
            double y = Math.ScaleB(Math.Abs(x), 52-e);
            long yy = (long)y;
            Debug.Assert((double)yy == y);
            string s = String.Format("{0:x}", yy);
            string s1 = s.Substring(0, 1);
            Debug.Assert(s1 == "1");
            string s2 = s.Substring(1).TrimEnd('0');
            return String.Format("{0}0x{1}{2}p{3}", Double.IsNegative(x) ? "-" : "", s1, s2 == "" ? s2 : "." + s2, e);
        }
        else
        {
            // Infinity, NaN
            return x.ToString();
        }
        /*
        else if (Double.IsInfinity(x))
        {
            return x > 0 ? "Infinity" : "-Infinity";
        }
        else if (Double.IsNaN(x))
        {
            return "NaN";
        }
        */
    }
    static void Main(string[] args)
    {
        {
            ulong[][] cases = new ulong[][]
            {
                new ulong[] {0x7E70000000000000ul, 0x7E70000000000000ul, 0xFFF0000000000000ul, 0xFFF0000000000000ul},
                new ulong[] {0xFFE4F8AC19291FFAul, 0x00027386791A736Eul, 0x3FEEE11F685E2E12ul, 0x3FE2071B0283F156ul},
                new ulong[] {0x5F30000000000008ul, 0x5F31000000000000ul, 0x0000000000000001ul, 0x7E71000000000009ul},
                new ulong[] {0x5F30000000000001ul, 0x5F38000000000000ul, 0x8000000000000001ul, 0x7E78000000000001ul},
                new ulong[] {0x5FFFFFFFFC000000ul, 0x5FE0000002000000ul, 0x8000000000000001ul, 0x7FEFFFFFFFFFFFFFul},
            };
            bool allOk = true;
            foreach (ulong[] t in cases)
            {
                double x = BitConverter.Int64BitsToDouble((long)t[0]);
                double y = BitConverter.Int64BitsToDouble((long)t[1]);
                double z = BitConverter.Int64BitsToDouble((long)t[2]);
                double expected = BitConverter.Int64BitsToDouble((long)t[3]);
                double result = Math.FusedMultiplyAdd(x, y, z);
                bool sameFloat = Double.IsNaN(result) ? Double.IsNaN(expected) : result == expected && Double.IsNegative(result) == Double.IsNegative(expected);
                if (!sameFloat)
                {
                    allOk = false;
                    Console.WriteLine("Math.FusedMultiplyAdd({0}, {1}, {2}): Expected {3}, but got {4}.", HexFloat(x), HexFloat(y), HexFloat(z), HexFloat(expected), HexFloat(result));
                }
            }
            if (allOk)
            {
                Console.WriteLine("Math.FusedMultiplyAdd: All tests passed.");
            }
        }
        {
            uint[][] cases = new uint[][]
            {
                new uint[] {0x71800000u, 0x71800000u, 0xFF800000u, 0xFF800000u},
                new uint[] {0x4B7FFFFFu, 0x4D800002u, 0x427E0000u, 0x59800001u},
                new uint[] {0x7E425718u, 0x00000160u, 0x00000001u, 0x38059BE1u},
                new uint[] {0x58800008u, 0x58880000u, 0x00000001u, 0x71880009u},
                new uint[] {0x58800001u, 0x58C00000u, 0x80000001u, 0x71C00001u},
                new uint[] {0x41C1DEBCu, 0xFAE00000u, 0xBE9A2084u, 0xFD29A2E5u},
            };
            bool allOk = true;
            foreach (uint[] t in cases)
            {
                float x = BitConverter.Int32BitsToSingle((int)t[0]);
                float y = BitConverter.Int32BitsToSingle((int)t[1]);
                float z = BitConverter.Int32BitsToSingle((int)t[2]);
                float expected = BitConverter.Int32BitsToSingle((int)t[3]);
                float result = MathF.FusedMultiplyAdd(x, y, z);
                bool sameFloat = Single.IsNaN(result) ? Single.IsNaN(expected) : result == expected && Single.IsNegative(result) == Single.IsNegative(expected);
                if (!sameFloat)
                {
                    allOk = false;
                    Console.WriteLine("MathF.FusedMultiplyAdd({0}, {1}, {2}): Expected {3}, but got {4}.", HexFloat(x), HexFloat(y), HexFloat(z), HexFloat(expected), HexFloat(result));
                }
            }
            if (allOk)
            {
                Console.WriteLine("MathF.FusedMultiplyAdd: All tests passed.");
            }
        }
    }
}
