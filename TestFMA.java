class TestFMA
{
    public static void main(String[] args) {
        {
            double[][] cases = {
                {0x1p1000, 0x1p1000, Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY},
                {-0x1.4f8ac19291ffap1023, 0x1.39c33c8d39b7p-1025, 0x1.ee11f685e2e12p-1, 0x1.2071b0283f156p-1},
                {0x1.0000000000008p500, 0x1.1p500, 0x1p-1074, 0x1.1000000000009p1000},
                {0x1.0000000000001p500, 0x1.8p500, -0x1p-1074, 0x1.8000000000001p1000},
                {0x0.ffffffep513, 0x1.0000002p511, -0x1p-1074, 0x1.fffffffffffffp1023},
            };
            boolean allOk = true;
            for (double[] t : cases) {
                double a = t[0];
                double b = t[1];
                double c = t[2];
                double expected = t[3];
                double result = Math.fma(a, b, c);
                boolean same = Double.isNaN(result) ? Double.isNaN(expected) : result == expected && Math.copySign(1.0, result) == Math.copySign(1.0, expected);
                if (!same) {
                    allOk = false;
                    System.out.printf("Math.fma(%a, %a, %a) (double): Expected %a, but got %a.\n", a, b, c, expected, result);
                }
            }
            if (allOk) {
                System.out.println("All tests passed for Math.fma(double, double, double).");
            }
        }
        {
            float[][] cases = {
                {0x1p100f, 0x1p100f, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY},
                {0x1.fffffep23f, 0x1.000004p28f, 0x1.fcp5f, 0x1.000002p52f},
                {0x1.84ae3p125f, 0x1.6p-141f, 0x1p-149f, 0x1.0b37c2p-15f},
                {0x1.00001p50f, 0x1.1p50f, 0x1p-149f, 0x1.100012p100f},
                {0x1.000002p50f, 0x1.8p50f, -0x1p-149f, 0x1.800002p100f},
                {0x1.83bd78p4f, -0x1.cp118f, -0x1.344108p-2f, -0x1.5345cap123f},
            };
            boolean allOk = true;
            for (float[] t : cases) {
                float a = t[0];
                float b = t[1];
                float c = t[2];
                float expected = t[3];
                float result = Math.fma(a, b, c);
                boolean same = Float.isNaN(result) ? Float.isNaN(expected) : result == expected && Math.copySign(1.0f, result) == Math.copySign(1.0f, expected);
                if (!same) {
                    allOk = false;
                    System.out.printf("Math.fma(%a, %a, %a) (float): Expected %a, but got %a.\n", a, b, c, expected, result);
                }
            }
            if (allOk) {
                System.out.println("All tests passed for Math.fma(float, float, float).");
            }
        }
    }
}
