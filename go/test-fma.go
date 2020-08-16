package main;

import "fmt"
import "math"

func main() {
    cases := [][4]float64{
        {0x1p1000, 0x1p1000, math.Inf(-1), math.Inf(-1)},
        {-0x1.4f8ac19291ffap1023, 0x1.39c33c8d39b7p-1025, 0x1.ee11f685e2e12p-1, 0x1.2071b0283f156p-1},
        {0x1.0000000000008p500, 0x1.1p500, 0x1p-1074, 0x1.1000000000009p1000},
        {0x1.0000000000001p500, 0x1.8p500, -0x1p-1074, 0x1.8000000000001p1000},
        {0x0.ffffffep513, 0x1.0000002p511, -0x1p-1074, 0x1.fffffffffffffp1023},
    }
    all_tests_passed := true
    for _, t := range cases {
        a := t[0]
        b := t[1]
        c := t[2]
        expected := t[3]
        result := math.FMA(a, b, c)
        var same bool
        if math.IsNaN(expected) {
            same = math.IsNaN(result) 
        } else {
            same = expected == result && math.Signbit(expected) == math.Signbit(result)
        }
        if !same {
            all_tests_passed = false
            fmt.Printf("math.FMA(%x, %x, %x): Expected %x, but got %x.\n", a, b, c, expected, result)
        }
    }
    if all_tests_passed {
        fmt.Printf("All tests passed for math.FMA(float64, float64, float64).\n")
    }
}
