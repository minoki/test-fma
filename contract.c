#include <math.h>
#include <stddef.h>
#include <stdio.h>

// coeff[0] + x * (coeff[1] + x * (... * (coeff[n-2] + x * coeff[n-1]) ...))
double horner(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

double horner_fma(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = fma(x, acc, coeff[m - 1]);
    }
    return acc;
}

double horner_contract(size_t n, double coeff[], double x)
{
    #pragma STDC FP_CONTRACT ON
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

double horner_no_contract(size_t n, double coeff[], double x)
{
    #pragma STDC FP_CONTRACT OFF
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

#if defined(__GNUC__) && !defined(__clang__)

__attribute__((optimize("fp-contract=fast")))
double horner_contract_attr_fast(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

__attribute__((optimize("fp-contract=on")))
double horner_contract_attr_on(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

__attribute__((optimize("fp-contract=off")))
double horner_contract_attr_off(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

#endif

#if defined(_MSC_VER)

#pragma float_control(push)
#pragma float_control(precise, off)
#pragma fp_contract(on)

double horner_contract_msvc(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

#pragma float_control(precise, on)
#pragma fp_contract(off)

double horner_no_contract_msvc(size_t n, double coeff[], double x)
{
    double acc = 0;
    for (size_t m = n; m > 0; --m) {
        acc = coeff[m - 1] + x * acc;
    }
    return acc;
}

#pragma float_control(pop)

#endif

int main(void)
{
#if defined(FP_FAST_FMA)
    puts("FP_FAST_FMA is defined.");
#else
    puts("FP_FAST_FMA is not defined.");
#endif
    double coeff[2] = {-0x1p-1074, 0x1.0000000000001p500};
    double x = 0x1.8p500;
    double value_if_fma = 0x1.8000000000001p1000;
    double value_if_not_fma = 0x1.8000000000002p1000;
    struct {
        const char *name;
        double (*f)(size_t, double coeff[], double x);
    } const cases[] = {
        {"default", horner},
        {"fma", horner_fma},
        {"#pragma STDC FP_CONTRACT ON", horner_contract},
        {"#pragma STDC FP_CONTRACT OFF", horner_no_contract},
#if defined(__GNUC__) && !defined(__clang__)
        {"-ffp-contract=fast", horner_contract_attr_fast},
        {"-ffp-contract=on", horner_contract_attr_on},
        {"-ffp-contract=off", horner_contract_attr_off},
#endif
#if defined(_MSC_VER)
        {"#pragma fp_contract(on)", horner_contract_msvc},
        {"#pragma fp_contract(off)", horner_no_contract_msvc},
#endif
    };
    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        double y = cases[i].f(2, coeff, x);
        if (y == value_if_fma) {
            printf("%s: FMA is used.\n", cases[i].name);
        } else if (y == value_if_not_fma) {
            printf("%s: FMA is not used.\n", cases[i].name);
        } else {
            printf("%s: Unexpected result (%a).\n", cases[i].name, y);
        }
    }
}
