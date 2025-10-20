// Type.java
public enum Type {
    INT, FLOAT, BOOL, STRING, VOID, CLASS; // CLASS برای نوع‌های کاربر-ساخت
    public boolean isNumeric() {
        return this == INT || this == FLOAT;
    }
    public boolean isAssignableFrom(Type from) {
        if (this == from) return true;
        if (this == FLOAT && from == INT) return true; // implicit int->float
        // افزودن قوانین بیشتر در صورت نیاز
        return false;
    }
}
