#define PI 3.14159
#define MAX_VALUE 100

template <typename T>
class MathUtils {
public:
    static T add(T a, T b) {
        return a + b;
    }

    static T power(T base, int exponent) {
        T result = 1;
        for (int i = 0; i < exponent; i++) {
            result *= base;
        }
        return result;
    }

private:
    T secretValue;
};

int main() {
    int decimal = 123;
    float scientific = 1.23e-10;
    int binary = 0b1010;
    int hex = 0xFF;
    int octal = 077;
    double floatNum = 3.14;

    string name = "Alice";
    char initial = 'A';

    MathUtils<int> utils;
    int sum = utils.add(10, 20);
    int powResult = utils.power(2, 8);

    if (decimal > MAX_VALUE && scientific < 1.0) {
        for (int i = 0; i < 10; i++) {
            decimal += i;
        }
    } else {
        while (decimal > 0) {
            decimal--;
        }
    }

    // this is comment singel line
    /* this is comment
		multiple line*/
    int x = 10; // this comment is end of line

    return 0;
}