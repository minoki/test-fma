#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

struct fma_test_case_d
{
    double a, b, c, expected;
}
static const cases_d[] = {
    {0x1p1000, 0x1p1000, -INFINITY, -INFINITY},
    {-0x1.4f8ac19291ffap1023, 0x1.39c33c8d39b7p-1025, 0x1.ee11f685e2e12p-1, 0x1.2071b0283f156p-1},
    {0x1.0000000000008p500, 0x1.1p500, 0x1p-1074, 0x1.1000000000009p1000},
    {0x1.0000000000001p500, 0x1.8p500, -0x1p-1074, 0x1.8000000000001p1000},
    {0x0.ffffffep513, 0x1.0000002p511, -0x1p-1074, 0x1.fffffffffffffp1023},
};

struct fma_test_case_f
{
    float a, b, c, expected;
}
static const cases_f[] = {
    {0x1p100f, 0x1p100f, -INFINITY, -INFINITY},
    {0x1.fffffep23f, 0x1.000004p28f, 0x1.fcp5f, 0x1.000002p52f},
    {0x1.84ae3p125f, 0x1.6p-141f, 0x1p-149f, 0x1.0b37c2p-15f},
    {0x1.00001p50f, 0x1.1p50f, 0x1p-149f, 0x1.100012p100f},
    {0x1.000002p50f, 0x1.8p50f, -0x1p-149f, 0x1.800002p100f},
    {0x1.83bd78p4f, -0x1.cp118f, -0x1.344108p-2f, -0x1.5345cap123f},
};

uint64_t double_to_int64(double x)
{
    union {
        double f;
        uint64_t i;
    } u;
    u.f = x;
    return u.i;
}

uint32_t float_to_int32(float x)
{
    union {
        float f;
        uint32_t i;
    } u;
    u.f = x;
    return u.i;
}

int main(int argc, char *argv[])
{
    if (argc > 1 && strcmp(argv[1], "cs") == 0) {
        for (size_t i = 0; i < sizeof(cases_d) / sizeof(cases_d[0]); ++i) {
            double a = cases_d[i].a;
            double b = cases_d[i].b;
            double c = cases_d[i].c;
            double expected = cases_d[i].expected;
            printf("new ulong[] {0x%016" PRIX64 "ul, 0x%016" PRIX64 "ul, 0x%016" PRIX64 "ul, 0x%016" PRIX64 "ul},\n", double_to_int64(a), double_to_int64(b), double_to_int64(c), double_to_int64(expected));
        }
        for (size_t i = 0; i < sizeof(cases_f) / sizeof(cases_f[0]); ++i) {
            float a = cases_f[i].a;
            float b = cases_f[i].b;
            float c = cases_f[i].c;
            float expected = cases_f[i].expected;
            printf("new uint[] {0x%08" PRIX32 "u, 0x%08" PRIX32 "u, 0x%08" PRIX32 "u, 0x%08" PRIX32 "u},\n", float_to_int32(a), float_to_int32(b), float_to_int32(c), float_to_int32(expected));
        }
    } else {
        printf("Usage: %s cs\n", argv[0]);
    }
}
