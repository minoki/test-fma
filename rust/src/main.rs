use std::ptr::{read_volatile};

fn do_not_optimize<T>(x: T) -> T {
    let ptr = &x as *const T;
    unsafe { read_volatile(ptr) }
}

fn main() {
    {
        let cases_i: &[[u64; 4]] = &[
            [0x7E70000000000000u64, 0x7E70000000000000u64, 0xFFF0000000000000u64, 0xFFF0000000000000u64],
            [0xFFE4F8AC19291FFAu64, 0x00027386791A736Eu64, 0x3FEEE11F685E2E12u64, 0x3FE2071B0283F156u64],
            [0x5F30000000000008u64, 0x5F31000000000000u64, 0x0000000000000001u64, 0x7E71000000000009u64],
            [0x5F30000000000001u64, 0x5F38000000000000u64, 0x8000000000000001u64, 0x7E78000000000001u64],
            [0x5FFFFFFFFC000000u64, 0x5FE0000002000000u64, 0x8000000000000001u64, 0x7FEFFFFFFFFFFFFFu64],
        ];
        let mut all_tests_passed = true;
        for case in cases_i.iter() {
            let a = do_not_optimize(f64::from_bits(case[0]));
            let b = do_not_optimize(f64::from_bits(case[1]));
            let c = do_not_optimize(f64::from_bits(case[2]));
            let expected = do_not_optimize(f64::from_bits(case[3]));
            let result = a.mul_add(b, c); // a * b + c
            let same = if expected.is_nan() { result.is_nan() } else { expected == result && expected.is_sign_negative() == result.is_sign_negative() };
            if !same {
                all_tests_passed = false;
                println!("f64::mul_add({}, {}, {}): Expected {}, but got {}.\n", a, b, c, expected, result);
            }
        }
        if all_tests_passed {
            println!("All tests passed for f64::mul_add");
        }
    }
    {
        let cases_i: &[[u32; 4]] = &[
            [0x71800000u32, 0x71800000u32, 0xFF800000u32, 0xFF800000u32],
            [0x4B7FFFFFu32, 0x4D800002u32, 0x427E0000u32, 0x59800001u32],
            [0x7E425718u32, 0x00000160u32, 0x00000001u32, 0x38059BE1u32],
            [0x58800008u32, 0x58880000u32, 0x00000001u32, 0x71880009u32],
            [0x58800001u32, 0x58C00000u32, 0x80000001u32, 0x71C00001u32],
            [0x41C1DEBCu32, 0xFAE00000u32, 0xBE9A2084u32, 0xFD29A2E5u32],
        ];
        let mut all_tests_passed = true;
        for case in cases_i.iter() {
            let a = do_not_optimize(f32::from_bits(case[0]));
            let b = do_not_optimize(f32::from_bits(case[1]));
            let c = do_not_optimize(f32::from_bits(case[2]));
            let expected = do_not_optimize(f32::from_bits(case[3]));
            let result = a.mul_add(b, c); // a * b + c
            let same = if expected.is_nan() { result.is_nan() } else { expected == result && expected.is_sign_negative() == result.is_sign_negative() };
            if !same {
                all_tests_passed = false;
                println!("f32::mul_add({}, {}, {}): Expected {}, but got {}.\n", a, b, c, expected, result);
            }
        }
        if all_tests_passed {
            println!("All tests passed for f32::mul_add");
        }
    }
}
